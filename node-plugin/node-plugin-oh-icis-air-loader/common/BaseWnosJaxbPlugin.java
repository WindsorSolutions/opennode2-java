package com.windsor.node.plugin.common;

import com.windsor.node.common.domain.NodeTransaction;
import com.windsor.node.plugin.BaseWnosPlugin;
import com.windsor.node.plugin.common.domain.DocumentHeaderType;
import com.windsor.node.plugin.common.domain.DocumentPayloadType;
import com.windsor.node.plugin.common.domain.ExchangeNetworkDocumentType;
import com.windsor.node.plugin.common.domain.ObjectFactory;
import com.windsor.node.plugin.common.domain.v10.DocHeader;
import com.windsor.node.plugin.common.domain.v10.ExchangeNetworkDocument;
import com.windsor.node.plugin.common.domain.v10.Payload;
import com.windsor.node.service.helper.id.UUIDGenerator;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.GregorianCalendar;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBElement;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import javax.xml.datatype.DatatypeConfigurationException;
import javax.xml.datatype.DatatypeFactory;
import javax.xml.datatype.XMLGregorianCalendar;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public abstract class BaseWnosJaxbPlugin extends BaseWnosPlugin {
   public static final String ARG_HEADER_DOCUMENT_TITLE = "Document Title";
   public static final String ARG_HEADER_KEYWORDS = "Keywords";
   protected Logger logger = LoggerFactory.getLogger(BaseWnosJaxbPlugin.class);

   protected JAXBElement processHeaderDirectives(JAXBElement jaxbElement, String docId, String operation, NodeTransaction transaction) {
      return this.processHeaderDirectives(jaxbElement, docId, operation, transaction, Boolean.FALSE);
   }

   protected JAXBElement processHeaderDirectives(JAXBElement jaxbElement, String docId, String operation, NodeTransaction transaction, Boolean forceHeaderUse) {
      String addHeader = this.getConfigValueAsStringNoFail("Add Header");
      if(!"true".equalsIgnoreCase(addHeader) && !forceHeaderUse.booleanValue()) {
         return jaxbElement;
      } else {
         ObjectFactory fact = new ObjectFactory();
         ExchangeNetworkDocumentType exchangeNetworkDocumentType = fact.createExchangeNetworkDocumentType();
         exchangeNetworkDocumentType.setId(UUIDGenerator.makeId());
         DocumentHeaderType documentHeader = fact.createDocumentHeaderType();
         exchangeNetworkDocumentType.setHeader(documentHeader);
         String authorName = this.getConfigValueAsStringNoFail("Author");
         documentHeader.setAuthorName(StringUtils.isNotBlank(authorName)?authorName:"");
         String contactInfo = this.getConfigValueAsStringNoFail("Contact Info");
         documentHeader.setSenderContact(StringUtils.isNotBlank(contactInfo)?contactInfo:"");
         String orgName = this.getConfigValueAsStringNoFail("Organization");
         String payloadName = this.getConfigValueAsStringNoFail("Payload Operation");
         String documentTitle = this.getConfigValueAsStringNoFail("Document Title");
         String keywords = this.getConfigValueAsStringNoFail("Keywords");
         documentHeader.setOrganizationName(StringUtils.isNotBlank(orgName)?orgName:"");
         if(StringUtils.isNotBlank(documentTitle)) {
            documentHeader.setDocumentTitle(documentTitle);
         } else {
            documentHeader.setDocumentTitle(operation + docId);
         }

         if(StringUtils.isNotBlank(keywords)) {
            documentHeader.setKeywords(keywords);
         }

         documentHeader.setCreationDateTime(this.getDocumentCreationDateTime());
         documentHeader.setDataFlowName(transaction.getRequest().getFlowName());
         documentHeader.setDataServiceName(transaction.getRequest().getService().getName());
         DocumentPayloadType documentPayloadType = fact.createDocumentPayloadType();
         exchangeNetworkDocumentType.getPayload().add(documentPayloadType);
         documentPayloadType.setId(docId);
         if(StringUtils.isNotBlank(payloadName)) {
            documentPayloadType.setOperation(payloadName);
         }

         documentPayloadType.setAny(jaxbElement);
         return fact.createDocument(exchangeNetworkDocumentType);
      }
   }

   protected JAXBElement processHeaderDirectivesV10(JAXBElement jaxbElement, String docId, String operation, NodeTransaction transaction, Boolean forceHeaderUse) {
      String addHeader = this.getConfigValueAsStringNoFail("Add Header");
      if(!"true".equalsIgnoreCase(addHeader) && !forceHeaderUse.booleanValue()) {
         return jaxbElement;
      } else {
         com.windsor.node.plugin.common.domain.v10.ObjectFactory fact = new com.windsor.node.plugin.common.domain.v10.ObjectFactory();
         ExchangeNetworkDocument exchangeNetworkDocument = fact.createExchangeNetworkDocument();
         exchangeNetworkDocument.setId(UUIDGenerator.makeId());
         DocHeader documentHeader = fact.createDocHeader();
         exchangeNetworkDocument.setHeader(documentHeader);
         String authorName = this.getConfigValueAsStringNoFail("Author");
         documentHeader.setAuthor(StringUtils.isNotBlank(authorName)?authorName:"");
         String contactInfo = this.getConfigValueAsStringNoFail("Contact Info");
         documentHeader.setContactInfo(StringUtils.isNotBlank(contactInfo)?contactInfo:"");
         String orgName = this.getConfigValueAsStringNoFail("Organization");
         String payloadName = this.getConfigValueAsStringNoFail("Payload Operation");
         String documentTitle = this.getConfigValueAsStringNoFail("Document Title");
         documentHeader.setOrganization(StringUtils.isNotBlank(orgName)?orgName:"");
         if(StringUtils.isNotBlank(documentTitle)) {
            documentHeader.setTitle(documentTitle);
         } else {
            documentHeader.setTitle(operation + docId);
         }

         documentHeader.setCreationTime(this.getDocumentCreationDateTime());
         documentHeader.setDataService(transaction.getRequest().getService().getName());
         Payload payload = fact.createPayload();
         exchangeNetworkDocument.getPayload().add(payload);
         if(StringUtils.isNotBlank(payloadName)) {
            payload.setOperation(payloadName);
         }

         payload.setAny(jaxbElement);
         return fact.createDocument(exchangeNetworkDocument);
      }
   }

   protected XMLGregorianCalendar getDocumentCreationDateTime() {
      DatatypeFactory datatypeFactory = null;

      try {
         datatypeFactory = DatatypeFactory.newInstance();
      } catch (DatatypeConfigurationException var3) {
         this.logger.warn("A serious configuration error occured when trying to create a factory to handle XML date objects, recovering, but no dates can be parsed or included in file.", var3.getMessage());
         return null;
      }

      return datatypeFactory.newXMLGregorianCalendar(new GregorianCalendar());
   }

   protected void writeDocument(JAXBElement document, String pathname) throws JAXBException, IOException {
      this.writeDocument(document, pathname, (String)null);
   }

   protected void writeDocument(JAXBElement document, String pathname, String schemaLocation) throws JAXBException, IOException {
      Class clazz = document.getValue().getClass();
      StringBuffer packageNames = new StringBuffer(clazz.getPackage().getName());
      int m;
      if(document.getValue() instanceof ExchangeNetworkDocumentType) {
         ExchangeNetworkDocumentType context = (ExchangeNetworkDocumentType)document.getValue();

         for(m = 0; m < context.getPayload().size(); ++m) {
            packageNames.insert(0, ":").insert(0, ((JAXBElement)((DocumentPayloadType)context.getPayload().get(m)).getAny()).getValue().getClass().getPackage().getName());
         }
      }

      if(document.getValue() instanceof ExchangeNetworkDocument) {
         ExchangeNetworkDocument var8 = (ExchangeNetworkDocument)document.getValue();

         for(m = 0; m < var8.getPayload().size(); ++m) {
            packageNames.insert(0, ":").insert(0, ((JAXBElement)((Payload)var8.getPayload().get(m)).getAny()).getValue().getClass().getPackage().getName());
         }
      }

      JAXBContext var9 = JAXBContext.newInstance(packageNames.toString(), clazz.getClassLoader());
      Marshaller var10 = var9.createMarshaller();
      var10.setProperty("jaxb.formatted.output", Boolean.TRUE);
      if(StringUtils.isNotBlank(schemaLocation)) {
         var10.setProperty("jaxb.schemaLocation", schemaLocation);
      }

      var10.marshal(document, new FileOutputStream(pathname));
   }

   public String getConfigValueAsStringNoFail(String key) {
      if(StringUtils.isBlank(key)) {
         return null;
      } else {
         this.logger.debug("Looking for: " + key);
         if(!this.getConfigurationArguments().containsKey(key)) {
            return null;
         } else {
            String value = (String)this.getConfigurationArguments().get(key);
            return StringUtils.isBlank(value)?null:value;
         }
      }
   }
}
