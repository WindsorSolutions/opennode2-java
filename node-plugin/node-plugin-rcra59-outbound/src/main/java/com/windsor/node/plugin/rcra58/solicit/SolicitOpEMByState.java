package com.windsor.node.plugin.rcra58.solicit;

import com.windsor.node.common.domain.PluginServiceImplementorDescriptor;
import com.windsor.node.common.util.ByIndexOrNameMap;
import com.windsor.node.plugin.rcra58.RcraOutboundException;
import com.windsor.node.plugin.rcra58.domain.SolicitHistory;
import com.windsor.node.plugin.rcra58.solicit.request.SolicitRequest;
import com.windsor.node.plugin.rcra58.solicit.request.SolicitRequestFactory;
import com.windsor.node.plugin.rcra58.solicit.request.SolicitRequestType;

public class SolicitOpEMByState extends SolicitOperation {

    public static final String SERVICE_NAME = "SolicitOpEMByState";
    private static final PluginServiceImplementorDescriptor PLUGIN_SERVICE_IMPLEMENTOR_DESCRIPTOR =
            new PluginServiceImplementorDescriptor();

    static {
        PLUGIN_SERVICE_IMPLEMENTOR_DESCRIPTOR.setName(SERVICE_NAME);
        PLUGIN_SERVICE_IMPLEMENTOR_DESCRIPTOR.setDescription("Solicits EManifest Data by State from the RCRAInfo service.");
        PLUGIN_SERVICE_IMPLEMENTOR_DESCRIPTOR.setClassName(SolicitOperation.class.getCanonicalName());
    }

    @Override
    public PluginServiceImplementorDescriptor getPluginServiceImplementorDescription() {
        return PLUGIN_SERVICE_IMPLEMENTOR_DESCRIPTOR;
    }

    @Override
    public SolicitRequestType getRequestType() {
        return SolicitRequestType.EM_BY_STATE;
    }

    @Override
    public SolicitRequest handleGetRequest(SolicitRequestFactory requestFactory, ByIndexOrNameMap namedParams)
            throws RcraOutboundException {

        String state = namedParams.get(SolicitOperation.PARAM_STATE_REQ.getName()).toString();

        String changeDate = null;
        if (namedParams.containsKey(SolicitOperation.PARAM_CHANGE_DATE.getName())) {
            changeDate = namedParams.get(SolicitOperation.PARAM_CHANGE_DATE.getName()).toString();
        }

        String endDate = null;
        if (namedParams.containsKey(SolicitOperation.PARAM_END_DATE.getName())) {
            endDate = namedParams.get(SolicitOperation.PARAM_END_DATE.getName()).toString();
        }

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

        return requestFactory.getEMDataByState(state, changeDate, endDate);
    }

}
