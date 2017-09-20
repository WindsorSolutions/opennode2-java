package com.windsor.node.plugin.gaeisdata;

import java.util.List;

import org.apache.commons.lang.StringUtils;

import com.windsor.node.common.domain.CommonTransactionStatusCode;
import com.windsor.node.common.domain.DataServiceRequestParameter;
import com.windsor.node.common.domain.NodeTransaction;
import com.windsor.node.common.domain.ProcessContentResult;
import com.windsor.node.data.dao.PluginServiceParameterDescriptor;
import com.windsor.node.plugin.gaeisdata.dao.EisDataSourceDao;

public abstract class EisStagingTablePopulator extends com.windsor.node.plugin.BaseWnosPlugin {
    public static final PluginServiceParameterDescriptor INVENTORY_YEAR = new PluginServiceParameterDescriptor(
            "Inventory Year", "java.lang.Long", Boolean.TRUE,
            "The Inventory Year for which to translate the source data.");
    public static final PluginServiceParameterDescriptor FACILITY_ID = new PluginServiceParameterDescriptor(
            "Facility ID", "java.lang.String", Boolean.FALSE,
            "(Optional) The Facility ID for which to translate the source data.  If blank, all data will be translated.");

    public EisStagingTablePopulator() {
        getDataSources().put("Source Data Provider", null);
        getSupportedPluginTypes().add(com.windsor.node.common.domain.ServiceType.TASK);
    }

    @Override
    public List<PluginServiceParameterDescriptor> getParameters() {
        List<PluginServiceParameterDescriptor> params = new java.util.ArrayList();
        params.add(INVENTORY_YEAR);
        params.add(FACILITY_ID);
        return params;
    }

    @Override
    public ProcessContentResult process(NodeTransaction transaction) {
        debug("Processing transaction...");
        ProcessContentResult result = new ProcessContentResult();
        result.setSuccess(false);
        result.setStatus(CommonTransactionStatusCode.Failed);
        validateTransaction(transaction);
        debug("Transaction is valid.");
        EisDataSourceDao sourceDao = new EisDataSourceDao();
        sourceDao.setDataSource(getDataSources().get("Source Data Provider"));
        Integer year = getInventoryYear(transaction);
        String facilityId = getFacilityId(transaction);
        try {
            executeDataLoad(sourceDao, year, facilityId);
        } catch (Exception e) {
            this.logger.error("Failure while processing transaction...", e);
            debug("Failure while processing transaction: " + e.getMessage());
            return result;
        }
        result.setSuccess(true);
        result.setStatus(CommonTransactionStatusCode.Completed);
        debug("Finished processing transaction.");
        return result;
    }

    protected abstract void executeDataLoad(EisDataSourceDao paramEisDataSourceDao, Integer paramInteger,
            String paramString);

    @Override
    public List<DataServiceRequestParameter> getServiceRequestParamSpecs(String serviceName) {
        return null;
    }

    private Integer getInventoryYear(NodeTransaction transaction) {
        if (transaction == null) {
            throw new IllegalStateException("NodeTransaction transaction cannot be null.");
        }
        if (transaction.getRequest() == null) {
            throw new IllegalStateException("NodeTransaction transaction.getRequest() cannot be null.");
        }
        if (transaction.getRequest().getParameters() == null) {
            throw new IllegalStateException("NodeTransaction transaction.getParameters() cannot be null.");
        }
        String[] args = transaction.getRequest().getParameters().toValueStringArray();
        if ((args == null) || (args.length == 0)) {
            throw new IllegalStateException("NodeTransaction did not have required argument, Inventory Year.");
        }
        Integer year = null;
        try {
            year = new Integer(StringUtils.trimToEmpty(args[0]));
        } catch (NumberFormatException e) {
            throw new IllegalStateException(
                    "NodeTransaction had required argument, Inventory Year, but it could not be parsed to a Numeric year.");
        }
        return year;
    }

    private String getFacilityId(NodeTransaction transaction) {
        if (transaction == null) {
            throw new IllegalStateException("NodeTransaction transaction cannot be null.");
        }
        if (transaction.getRequest() == null) {
            throw new IllegalStateException("NodeTransaction transaction.getRequest() cannot be null.");
        }
        if (transaction.getRequest().getParameters() == null) {
            throw new IllegalStateException("NodeTransaction transaction.getParameters() cannot be null.");
        }
        String[] args = transaction.getRequest().getParameters().toValueStringArray();
        if ((args == null) || (args.length == 0) || (args.length < 2)) {
            return null;
        }
        return StringUtils.trimToEmpty(args[1]);
    }
}
