/*
Copyright (c) 2009, The Environmental Council of the States (ECOS)
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

 * Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
 * Neither the name of the ECOS nor the names of its contributors may
   be used to endorse or promote products derived from this software
   without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
 */

/**
 * 
 */
package com.windsor.node.plugin.nysitesspills;

import java.io.File;
import java.util.List;

import javax.sql.DataSource;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;

import com.windsor.node.common.domain.CommonContentType;
import com.windsor.node.common.domain.CommonTransactionStatusCode;
import com.windsor.node.common.domain.DataServiceRequestParameter;
import com.windsor.node.common.domain.Document;
import com.windsor.node.common.domain.NodeTransaction;
import com.windsor.node.common.domain.ProcessContentResult;
import com.windsor.node.common.domain.ServiceType;
import com.windsor.node.plugin.BaseWnosPlugin;
import com.windsor.node.service.helper.CompressionService;
import com.windsor.node.service.helper.settings.SettingServiceProvider;

public abstract class BaseSitesSpillsDocumentCreator extends BaseWnosPlugin {

    private static final int MEGA = 1024;

    private static final int MAX_LIST_ITEMS_INDEX = 0;

    private String filenameTail;

    private String templatePath;

    private SitesSpillsDocBuilder builder;

    /**
     * Default constructor.
     */
    protected BaseSitesSpillsDocumentCreator() {
        super();

        setPublishForEN11(false);
        setPublishForEN20(false);

        debug("Setting internal data source list");
        getDataSources().put(ARG_DS_SOURCE, (DataSource) null);

        debug("Setting service types");
        getSupportedPluginTypes().add(ServiceType.SOLICIT);

        debug("BaseSitesSpillsDocumentCreator initialized");
    }

    protected ProcessContentResult processNodeTransaction(
            NodeTransaction transaction) {

        debug("Processing transaction...");

        ProcessContentResult result = new ProcessContentResult();
        result.setSuccess(false);
        result.setStatus(CommonTransactionStatusCode.Failed);

        try {

            /* HELPERS */

            result.getAuditEntries().add(
                    makeEntry("Validating SettingServiceProvider..."));
            SettingServiceProvider settingService = (SettingServiceProvider) getServiceFactory()
                    .makeService(SettingServiceProvider.class);

            if (settingService == null) {
                throw new RuntimeException(
                        "Unable to obtain SettingServiceProvider");
            }

            CompressionService compressionService = (CompressionService) getServiceFactory()
                    .makeService(CompressionService.class);

            if (compressionService == null) {
                throw new RuntimeException(
                        "Unable to obtain CompressionService");
            }

            // data source for this flow
            DataSource ds = (DataSource) getDataSources().get(ARG_DS_SOURCE);

            /* EXECUTE */

            // the output filename
            String targetFilePath = settingService.getTempFilePath()
                    + getFilenameTail();
            result.getAuditEntries().add(
                    makeEntry("Output will be written to " + targetFilePath));

            if (getOptionalValueFromTransactionArgs(transaction,
                    MAX_LIST_ITEMS_INDEX) != null) {

                debug("Value for MAX_LIST_ITEMS_INDEX key: "
                        + getOptionalValueFromTransactionArgs(transaction,
                                MAX_LIST_ITEMS_INDEX));

                int maxListItems = Integer
                        .parseInt(getOptionalValueFromTransactionArgs(
                                transaction, MAX_LIST_ITEMS_INDEX));

                debug("optional parameter value: " + maxListItems);

                builder.buildDocument(ds, targetFilePath, result, maxListItems);

            } else {

                builder.buildDocument(ds, targetFilePath, result);

            }

            // compress the file output file
            File fileToZip = new File(targetFilePath);

            float sizeInMB = ((float) fileToZip.length() / MEGA) / MEGA;
            result
                    .getAuditEntries()
                    .add(
                            makeEntry("Output file size (in megabytes) prior to compression: "
                                    + sizeInMB));

            File zippedFile = compressionService.zip(fileToZip);

            if (!zippedFile.exists()) {

                throw new RuntimeException(zippedFile.getAbsolutePath()
                        + " does not exist");

            } else {

                sizeInMB = ((float) zippedFile.length() / MEGA) / MEGA;
                result
                        .getAuditEntries()
                        .add(
                                makeEntry("Output file size (in megabytes) after compression: "
                                        + sizeInMB));
            }

            // create the node doc and save our hard work
            Document doc = new Document();
            result.getAuditEntries()
                    .add(makeEntry("Creating Node document..."));

            result.getAuditEntries().add(makeEntry("Result: " + zippedFile));

            doc.setType(CommonContentType.ZIP);

            doc.setDocumentName(FilenameUtils.getName(zippedFile
                    .getAbsolutePath()));

            doc.setContent(FileUtils.readFileToByteArray(zippedFile));

            result.getAuditEntries().add(makeEntry("Saving file to db..."));

            result.getDocuments().add(doc);

            result.setSuccess(true);
            result.setStatus(CommonTransactionStatusCode.Processed);
            result.getAuditEntries().add(makeEntry("Done: OK"));

        } catch (Exception ex) {

            error(ex);
            ex.printStackTrace();

            result.setSuccess(false);
            result.setStatus(CommonTransactionStatusCode.Failed);

            result.getAuditEntries().add(
                    makeEntry("Error while executing: "
                            + this.getClass().getName() + "Message: "
                            + ex.getMessage()));

        }
        return result;
    }

    public void afterPropertiesSet() {
        super.afterPropertiesSet();

        debug("Validating data sources");

        if (getDataSources() == null) {
            throw new RuntimeException("Data source not set");
        }

        if (!getDataSources().containsKey(ARG_DS_SOURCE)) {
            throw new RuntimeException("Data source not set");
        }

        debug("Data source validated");

        // get the location of Velocity templates and create the object that
        // does the work
        debug("Setting templatePath");
        templatePath = getPluginSourceDir().getAbsolutePath();

        if (templatePath == null) {
            // something went wrong in the subclass and wasn't already
            // handled
            throw new RuntimeException("Couldn't set templatePath");
        }

    }

    protected String getFilenameTail() {
        return filenameTail;
    }

    protected void setFilenameTail(String filenameTail) {
        this.filenameTail = filenameTail;
    }

    protected SitesSpillsDocBuilder getBuilder() {
        return builder;
    }

    protected void setBuilder(SitesSpillsDocBuilder builder) {
        this.builder = builder;
    }

    protected String getTemplatePath() {
        return templatePath;
    }

    protected void setTemplatePath(String templatePath) {
        this.templatePath = templatePath;
    }

    @Override
    public List<DataServiceRequestParameter> getServiceRequestParamSpecs(
            String serviceName) {
        return null;
    }
}