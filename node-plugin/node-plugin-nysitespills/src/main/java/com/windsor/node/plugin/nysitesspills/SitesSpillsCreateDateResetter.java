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

package com.windsor.node.plugin.nysitesspills;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import com.windsor.node.common.domain.*;
import com.windsor.node.data.dao.PluginServiceParameterDescriptor;
import com.windsor.node.plugin.BaseWnosPlugin;
import com.windsor.node.plugin.nysitesspills.dao.DateResetStoredProcedure;

/**
 * Resets the CREATE_DATE column of the DW_NODE_UTILITY table.
 * 
 * <p>
 * Intended to be run from a schedule when, for some reason, a prior
 * agency-to-agency ETL run or node submission failed.
 * </p>
 */
public class SitesSpillsCreateDateResetter extends BaseWnosPlugin {

    private static String DATE_FORMAT = "dd-MMM-yyyy";
    private DataSource pluginDataSource;
    public static final PluginServiceParameterDescriptor RESET_DATE = new PluginServiceParameterDescriptor(
            "Reset Date",
            PluginServiceParameterDescriptor.TYPE_DATE,
            Boolean.TRUE,
            "Date used when resetting the date column, in the format of dd-MM-yyy, i.e. 31-OCT-2015.");

    private static final PluginServiceImplementorDescriptor PLUGIN_SERVICE_IMPLEMENTOR_DESCRIPTOR = new PluginServiceImplementorDescriptor();

    static
    {
        PLUGIN_SERVICE_IMPLEMENTOR_DESCRIPTOR.setName("SiteSpillsCreateDateResetter");
        PLUGIN_SERVICE_IMPLEMENTOR_DESCRIPTOR.setDescription("Perform reset of the various NY Site Spills create dates.");
        PLUGIN_SERVICE_IMPLEMENTOR_DESCRIPTOR.setClassName(SitesSpillsCreateDateResetter.class.getCanonicalName());
    }


    public SitesSpillsCreateDateResetter() {

        super();

        setPublishForEN11(false);
        setPublishForEN20(false);

        debug("Setting internal data source list");
        getDataSources().put(ARG_DS_SOURCE, (DataSource) null);

        debug("Setting service types");
        getSupportedPluginTypes().add(ServiceType.TASK);

        debug("SitesSpillsCreateDateResetter instantiated");
    }

    public ProcessContentResult process(NodeTransaction transaction) {

        debug("Processing transaction...");

        ProcessContentResult result = new ProcessContentResult();
        result.setSuccess(false);
        result.setStatus(CommonTransactionStatusCode.Failed);

        debug("Validating transaction...");
        validateTransaction(transaction);

        try {

            String dateString = getDateStringFromTran(transaction);

            DateResetStoredProcedure proc = new DateResetStoredProcedure(
                    getPluginDataSource());

            result.getAuditEntries().add(
                    makeEntry("Attempting to reset the CREATE_DATE column."));

            proc.execute(dateString);

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

    /**
     * @param transaction
     * @return
     */
    private String getDateStringFromTran(NodeTransaction tran) {

        String s = tran.getRequest().getParameterValues()[0];

        SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT);

        try {
            sdf.parse(s);
        } catch (ParseException e) {

            throw new IllegalArgumentException("Parameter must be of the form "
                    + DATE_FORMAT);
        }

        return s;
    }

    public void validateTransaction(NodeTransaction tran) {

        super.validateTransaction(tran);

        int paramCount = tran.getRequest().getParameters().size();

        if (paramCount != 1) {
            throw new RuntimeException("Request must have exactly 1 parameter.");
        }

    }

    public void afterPropertiesSet() {
        super.afterPropertiesSet();

        debug("Validating data sources");

        if (getDataSources() == null) {
            throw new RuntimeException("Data sources not set");
        }

        if (!getDataSources().containsKey(ARG_DS_SOURCE)) {
            throw new RuntimeException("Data source not set");
        }

        if (null == getPluginDataSource()) {
            setPluginDataSource((DataSource) getDataSources()
                    .get(ARG_DS_SOURCE));
        }

        debug("Data source validated");

    }

    @Override
    public List<DataServiceRequestParameter> getServiceRequestParamSpecs(
            String serviceName) {
        return null;
    }

    public DataSource getPluginDataSource() {
        return pluginDataSource;
    }

    public void setPluginDataSource(DataSource pluginDataSource) {
        this.pluginDataSource = pluginDataSource;
    }

    @Override
    public List<PluginServiceParameterDescriptor> getParameters() {
        List<PluginServiceParameterDescriptor> params = new ArrayList<PluginServiceParameterDescriptor>();
        params.add(RESET_DATE);
        return params;
    }

    @Override
    public PluginServiceImplementorDescriptor getPluginServiceImplementorDescription() {
        return PLUGIN_SERVICE_IMPLEMENTOR_DESCRIPTOR;
    }
}