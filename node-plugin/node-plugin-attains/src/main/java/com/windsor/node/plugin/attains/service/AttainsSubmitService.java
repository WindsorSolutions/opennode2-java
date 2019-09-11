package com.windsor.node.plugin.attains.service;

import com.windsor.node.common.domain.*;
import com.windsor.node.plugin.attains.domain.ObjectFactory;
import com.windsor.node.plugin.attains.domain.OperationType;
import com.windsor.node.plugin.attains.domain.OrganizationDataType;
import com.windsor.node.plugin.attains.domain.ScheduleParameters;
import com.windsor.node.plugin.common.xml.validation.ValidationResult;
import com.windsor.node.plugin.common.xml.validation.Validator;
import com.windsor.node.plugin.common.xml.validation.jaxb.JaxbXmlValidator;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.exception.ExceptionUtils;

import javax.xml.bind.JAXBElement;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * Provides the service for submitting ATTAINS data.
 */
public class AttainsSubmitService extends AbstractAttainsService {

    private static final String ARG_HEADER_STORED_PROCEDURE = "Stored Procedure";
    private static final String ARG_HEADER_SENDER_ADDRESS = "Sender Address";
    private static final String ARG_HEADER_SENDER_CONTACT = "Sender Contact";
    private static final String ARG_VALIDATE_XML = "Validate XML (true or false)";

    private static final List<String> HEADERS = Arrays.asList(
            ARG_HEADER_STORED_PROCEDURE,
            ARG_HEADER_AUTHOR,
            ARG_HEADER_TITLE,
            ARG_HEADER_ORG_NAME,
            ARG_HEADER_SENDER_ADDRESS,
            ARG_HEADER_SENDER_CONTACT,
            ARG_VALIDATE_XML
    );

    private ScheduleParameters scheduleParameters;
    private ObjectFactory objectFactory;


    public AttainsSubmitService() {
        super(OperationType.SUBMIT);

        this.objectFactory = new ObjectFactory();
        debug("Setting internal runtime argument list");
        for (String config : HEADERS) {
            getConfigurationArguments().put(config, "");
        }
        getConfigurationArguments().put(ARG_HEADER_PAYLOAD_OP, getOperationType().getPayloadOperation());
    }

    @Override
    public ProcessContentResult process(NodeTransaction transaction) {
        ProcessContentResult result = new ProcessContentResult();
        result.setStatus(CommonTransactionStatusCode.Failed);
        result.setSuccess(false);

        recordActivity(result, "ATTAINS \"%s\" process starting.", getOperationType());
        validateTransaction(transaction);
        recordActivity(result, "Creating process parameters from transaction.");
        scheduleParameters = new ScheduleParameters(transaction);
        recordActivity(result, String.format("Schedule parameters: ", scheduleParameters));

        try {

            final String documentId = getIdGenerator().createId();
            final String documentName = "ATTAINS_" + getOperationType().name() + documentId + ".xml";
            final String directory = getSettingService().getTempDir().getAbsolutePath();

            String storedProcedure = getConfigValueAsStringNoFail(ARG_HEADER_STORED_PROCEDURE);
            if(StringUtils.isNotBlank(storedProcedure)) {
                recordActivity(result, "Calling stored procedure \"%s\" to populate staging tables.", storedProcedure);
                getAttainsDao().callStoredProcedure(storedProcedure);
            } else {
                recordActivity(result, "No stored procedure defined -- assuming the staging tables are already populated.");
            }

            recordActivity(result, "Preparing XML file creator with file name %s", documentName);
            String docPath = directory + "/" + documentName;
            Document doc = generateNodeDocument(transaction, documentId, docPath);
            List<Document> documents = new ArrayList<>();
            documents.add(doc);
            result.setDocuments(documents);

            if (getConfigValueAsStringNoFail(ARG_VALIDATE_XML) != null
                    && getConfigValueAsStringNoFail(ARG_VALIDATE_XML).toLowerCase().trim().equals("true")) { //scheduleParameters.isValidateXml()
                recordActivity(result, "Starting XML validation.");
                if (isXmlPayloadDocumentNotValid(result, transaction, docPath)) {
                    recordActivity(result, "XML validation failed -- check the attached documents for more info.");
                    getTransactionDao().save(transaction);
                    return result;
                } else {
                    recordActivity(result, "XML validation successful.");
                }
            } else {
                recordActivity(result, "Skipping XML validation.");
            }

            recordActivity(result, "Preparing exchange for delivery. Completed.");
            recordActivity(result, "Saving exchange network transaction.");
            getTransactionDao().save(transaction);
            recordActivity(result, "Saving exchange network transaction. Completed.");
            result.setSuccess(true);
            result.setStatus(CommonTransactionStatusCode.Pending);

            recordActivity(result, "ATTAINS \"%s\" process completed successfully.", getOperationType());
        } catch (Exception exception) {
            result.setSuccess(Boolean.FALSE);
            result.setStatus(CommonTransactionStatusCode.Failed);
            recordActivity(result, exception.getLocalizedMessage() + ", root cause: "
                    + ExceptionUtils.getRootCauseMessage(exception));
        }

        return result;
    }

    private boolean isXmlPayloadDocumentNotValid(ProcessContentResult result, NodeTransaction nodeTransaction, String xmlDocFilePath) throws Exception {

        String schemaFilePath = FilenameUtils.concat(getPluginSourceDir().getAbsolutePath(),
                "xsd/1.0/IR_Organization_v1.0.xsd");

        Validator validator = new JaxbXmlValidator(schemaFilePath);

        ValidationResult validationResult = validator.validate(new FileInputStream(xmlDocFilePath));

        if (validationResult.hasErrors()) {
            String docId = getIdGenerator().createId();
            String filename = FilenameUtils.concat(
                    getSettingService().getTempDir().getAbsolutePath(),
                    "Validation_Errors_" + this.getClass().getSimpleName() + docId + ".txt");

            File errorsFile = new File(filename);
            FileUtils.writeLines(errorsFile, validationResult.errors());

            Document doc = new Document();
            doc.setDocumentId(docId);
            doc.setId(docId);
            doc.setDocumentName("Validation Errors.txt");
            doc.setType(CommonContentType.Flat);
            doc.setDocumentStatus(CommonTransactionStatusCode.Completed);
            doc.setContent(FileUtils.readFileToByteArray(errorsFile));
            nodeTransaction.getDocuments().add(doc);
            errorsFile.delete();
        }

        return validationResult.hasErrors();
    }

    private Document generateNodeDocument(NodeTransaction nodeTransaction, String docId, String tempFilePath) {
        try {
            OrganizationDataType rootEntity = getAttainsDao().getRoot();
            JAXBElement<OrganizationDataType> payload = objectFactory.createOrganization(rootEntity);
            JAXBElement<?> header = processHeaderDirectives(payload, docId, nodeTransaction.getOperation(), nodeTransaction, true);
            writeDocument(header, tempFilePath);
            Document doc = makeDocument(docId, tempFilePath);
            nodeTransaction.getDocuments().add(doc);
            return doc;
        } catch (Exception e) {
            throw new RuntimeException("Error while generating document: " + tempFilePath, e);
        }
    }

    protected Document makeDocument(String documentId, String absolutefilePath) throws IOException
    {
        Document doc = new Document();
        doc.setDocumentId(documentId);
        doc.setId(documentId);

        String zippedFilePath = getCompressionService().zip(absolutefilePath);
        doc.setType(CommonContentType.ZIP);
        doc.setDocumentName(FilenameUtils.getName(zippedFilePath));
        doc.setContent(FileUtils.readFileToByteArray(new File(zippedFilePath)));

        return doc;
    }

    @Override
    protected List<String> getAdditionalPropertyNames() {
        return Arrays.asList(ARG_HEADER_AUTHOR,
                ARG_HEADER_TITLE,
                ARG_HEADER_ORG_NAME,
                ARG_HEADER_SENDER_ADDRESS,
                ARG_HEADER_SENDER_CONTACT);
    }
}
