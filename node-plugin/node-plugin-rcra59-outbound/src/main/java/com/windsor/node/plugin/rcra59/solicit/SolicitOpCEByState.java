package com.windsor.node.plugin.rcra59.solicit;

import com.windsor.node.common.domain.PluginServiceImplementorDescriptor;
import com.windsor.node.common.util.ByIndexOrNameMap;
import com.windsor.node.plugin.rcra59.RcraOutboundException;
import com.windsor.node.plugin.rcra59.domain.SolicitHistory;
import com.windsor.node.plugin.rcra59.solicit.request.SolicitRequest;
import com.windsor.node.plugin.rcra59.solicit.request.SolicitRequestFactory;
import com.windsor.node.plugin.rcra59.solicit.request.SolicitRequestType;

public class SolicitOpCEByState extends SolicitOperation {

    public static final String SERVICE_NAME = "SolicitOpCEByState";
    private static final PluginServiceImplementorDescriptor PLUGIN_SERVICE_IMPLEMENTOR_DESCRIPTOR =
            new PluginServiceImplementorDescriptor();

    static {
        PLUGIN_SERVICE_IMPLEMENTOR_DESCRIPTOR.setName(SERVICE_NAME);
        PLUGIN_SERVICE_IMPLEMENTOR_DESCRIPTOR.setDescription("Solicits CE Data by State from the RCRAInfo service.");
        PLUGIN_SERVICE_IMPLEMENTOR_DESCRIPTOR.setClassName(SolicitOperation.class.getCanonicalName());
    }

    @Override
    public PluginServiceImplementorDescriptor getPluginServiceImplementorDescription() {
        return PLUGIN_SERVICE_IMPLEMENTOR_DESCRIPTOR;
    }

    @Override
    public SolicitRequestType getRequestType() {
        return SolicitRequestType.CE_BY_STATE;
    }

    @Override
    public SolicitRequest handleGetRequest(SolicitRequestFactory requestFactory, ByIndexOrNameMap namedParams)
            throws RcraOutboundException {

        String state = namedParams.get(SolicitOperation.PARAM_STATE_REQ.getName()).toString();
        String changeDate = namedParams.get(SolicitOperation.PARAM_CHANGE_DATE.getName()).toString();

        if(getUseHistory() != null && getUseHistory()) {
            SolicitHistory history = getSolicitHistoryLast(SolicitHistory.Status.COMPLETE);
            if(history != null) {
                changeDate = history.getRunDateFormatted();
            }
        }

        if(getUseHistory() != null && getUseHistory() && changeDate == null) {
            throw new RcraOutboundException("The solicit request cannot be created without a change date! The \"Use " +
                    "solicit history\" flag is set to \"" + getUseHistory() + "\" but there is no solicit history records in " +
                    "the database and the change date is set to \"" + changeDate + "\".");
        }

        return requestFactory.getCEByState(state, changeDate);
    }

}
