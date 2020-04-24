package com.windsor.node.plugin.rcra58.solicit;

import com.windsor.node.common.domain.PluginServiceImplementorDescriptor;
import com.windsor.node.common.util.ByIndexOrNameMap;
import com.windsor.node.plugin.rcra58.RcraOutboundException;
import com.windsor.node.plugin.rcra58.domain.SolicitHistory;
import com.windsor.node.plugin.rcra58.solicit.request.SolicitRequest;
import com.windsor.node.plugin.rcra58.solicit.request.SolicitRequestFactory;
import com.windsor.node.plugin.rcra58.solicit.request.SolicitRequestType;

public class SolicitOpGSByHandler extends SolicitOperation {

    public static final String SERVICE_NAME = "SolicitOpGSByHandler";
    private static final PluginServiceImplementorDescriptor PLUGIN_SERVICE_IMPLEMENTOR_DESCRIPTOR =
            new PluginServiceImplementorDescriptor();

    static {
        PLUGIN_SERVICE_IMPLEMENTOR_DESCRIPTOR.setName(SERVICE_NAME);
        PLUGIN_SERVICE_IMPLEMENTOR_DESCRIPTOR.setDescription("Solicits GS Data by Handler from the RCRAInfo service.");
        PLUGIN_SERVICE_IMPLEMENTOR_DESCRIPTOR.setClassName(SolicitOperation.class.getCanonicalName());
    }

    @Override
    public PluginServiceImplementorDescriptor getPluginServiceImplementorDescription() {
        return PLUGIN_SERVICE_IMPLEMENTOR_DESCRIPTOR;
    }

    @Override
    public SolicitRequestType getRequestType() {
        return SolicitRequestType.GS_BY_HANDLER;
    }

    @Override
    public SolicitRequest handleGetRequest(SolicitRequestFactory requestFactory, ByIndexOrNameMap namedParams)
            throws RcraOutboundException {

        String handlerId = namedParams.get(SolicitOperation.PARAM_HANDLER_ID_REQ.getName()).toString();
        String owner = namedParams.get(SolicitOperation.PARAM_OWNER.getName()).toString();
        String sequenceNumber = namedParams.get(SolicitOperation.PARAM_SEQUENCE_NUMBER.getName()).toString();
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

        return requestFactory.getGSDataByHandler(handlerId, owner, sequenceNumber, changeDate);
    }

}
