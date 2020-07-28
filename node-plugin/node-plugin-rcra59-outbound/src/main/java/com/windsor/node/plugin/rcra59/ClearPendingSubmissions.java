package com.windsor.node.plugin.rcra59;

import com.windsor.node.common.domain.ActivityEntry;
import com.windsor.node.common.domain.CommonTransactionStatusCode;
import com.windsor.node.common.domain.DataServiceRequestParameter;
import com.windsor.node.common.domain.NodeTransaction;
import com.windsor.node.common.domain.PluginServiceImplementorDescriptor;
import com.windsor.node.common.domain.ProcessContentResult;
import com.windsor.node.common.domain.ServiceType;
import com.windsor.node.data.dao.PluginServiceParameterDescriptor;
import com.windsor.node.plugin.rcra59.domain.SolicitHistory;
import com.windsor.node.plugin.rcra59.outbound.BaseRcraPlugin;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class ClearPendingSubmissions extends BaseRcraPlugin {

    private static final PluginServiceImplementorDescriptor PLUGIN_SERVICE_IMPLEMENTOR_DESCRIPTOR = new PluginServiceImplementorDescriptor();

    static
    {
        PLUGIN_SERVICE_IMPLEMENTOR_DESCRIPTOR.setName("ClearPendingSubmissions");
        PLUGIN_SERVICE_IMPLEMENTOR_DESCRIPTOR.setDescription("Marks as failed any pending solicits.");
        PLUGIN_SERVICE_IMPLEMENTOR_DESCRIPTOR.setClassName(ClearPendingSubmissions.class.getCanonicalName());
    }

    public ClearPendingSubmissions() {
        super();
        getSupportedPluginTypes().add(ServiceType.TASK);
    }

    @Override
    public List<DataServiceRequestParameter> getServiceRequestParamSpecs(String serviceName) {
        return Collections.emptyList();
    }

    @Override
    public List<PluginServiceParameterDescriptor> getParameters() {
        List<PluginServiceParameterDescriptor> parameters = new ArrayList<>();
        return parameters;
    }

    @Override
    public PluginServiceImplementorDescriptor getPluginServiceImplementorDescription()
    {
        return PLUGIN_SERVICE_IMPLEMENTOR_DESCRIPTOR;
    }

    @Override
    public ProcessContentResult process(NodeTransaction transaction) {

        ProcessContentResult result = new ProcessContentResult();
        result.setStatus(CommonTransactionStatusCode.Failed);
        result.setSuccess(Boolean.FALSE);
        int count = 0;
        try {
            getTargetEntityManager().getTransaction().begin();
            count = getTargetEntityManager()
                    .createNativeQuery("UPDATE RCRA_SUBMISSIONHISTORY SET PROCESSINGSTATUS = :failedStatus WHERE PROCESSINGSTATUS = :pendingStatus")
                    .setParameter("failedStatus", SolicitHistory.Status.FAILED.getName())
                    .setParameter("pendingStatus", SolicitHistory.Status.PENDING.getName())
                    .executeUpdate();
            getTargetEntityManager().getTransaction().commit();
        } catch (Exception e) {

            /**
             * Rollback the transaction when exception is thrown.
             */
            getTargetEntityManager().getTransaction().rollback();

            result.setStatus(CommonTransactionStatusCode.Failed);
            result.setSuccess(Boolean.FALSE);
            result.getAuditEntries().add(new ActivityEntry("Unable to clear pending solicits. Error: " + e.getLocalizedMessage()));
            return result;
        }

        result.setStatus(CommonTransactionStatusCode.Completed);
        result.setSuccess(Boolean.TRUE);
        result.getAuditEntries().add(new ActivityEntry(String.format("Successfully marked %s pending solicits as failed.", count)));

        return result;
    }
}

