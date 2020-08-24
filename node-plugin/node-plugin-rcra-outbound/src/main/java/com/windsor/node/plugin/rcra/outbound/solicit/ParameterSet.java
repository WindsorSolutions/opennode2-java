package com.windsor.node.plugin.rcra.outbound.solicit;

import com.windsor.node.data.dao.PluginServiceParameterDescriptor;
import com.windsor.node.plugin.rcra.outbound.outbound.BaseRcraPlugin;
import com.windsor.node.plugin.rcra.outbound.solicit.request.SolicitRequestType;

/**
 * An enumeration with the sets of parameters for each of the RCRA functions.
 */
public enum ParameterSet {

    CA_BY_HANDLER(SolicitRequestType.CA_BY_HANDLER, new PluginServiceParameterDescriptor[] {
            BaseRcraPlugin.PARAM_USE_SOLICIT_HISTORY, BaseRcraPlugin.PARAM_HANDLER_ID_REQ, BaseRcraPlugin.PARAM_CHANGE_DATE
    }),
    CA_BY_STATE(SolicitRequestType.CA_BY_STATE, new PluginServiceParameterDescriptor[] {
            BaseRcraPlugin.PARAM_USE_SOLICIT_HISTORY, BaseRcraPlugin.PARAM_STATE_REQ, BaseRcraPlugin.PARAM_CHANGE_DATE
    }),
    CE_BY_HANDLER(SolicitRequestType.CE_BY_HANDLER, new PluginServiceParameterDescriptor[] {
            BaseRcraPlugin.PARAM_USE_SOLICIT_HISTORY, BaseRcraPlugin.PARAM_HANDLER_ID_REQ, BaseRcraPlugin.PARAM_STATE, BaseRcraPlugin.PARAM_AGENCY, BaseRcraPlugin.PARAM_CHANGE_DATE
    }),
    CE_BY_STATE(SolicitRequestType.CE_BY_STATE, new PluginServiceParameterDescriptor[] {
            BaseRcraPlugin.PARAM_USE_SOLICIT_HISTORY, BaseRcraPlugin.PARAM_STATE_REQ, BaseRcraPlugin.PARAM_CHANGE_DATE
    }),
    CE_DELETES_BY_STATE(SolicitRequestType.CE_DELETES_BY_STATE, new PluginServiceParameterDescriptor[] {
            BaseRcraPlugin.PARAM_USE_SOLICIT_HISTORY, BaseRcraPlugin.PARAM_STATE_REQ, BaseRcraPlugin.PARAM_CHANGE_DATE
    }),
    CE_EVALUATION_BY_HANDLER(SolicitRequestType.CE_EVALUATION_BY_HANDLER, new PluginServiceParameterDescriptor[] {
            BaseRcraPlugin.PARAM_USE_SOLICIT_HISTORY, BaseRcraPlugin.PARAM_HANDLER_ID_REQ, BaseRcraPlugin.PARAM_STATE, BaseRcraPlugin.PARAM_AGENCY, BaseRcraPlugin.PARAM_FROM_DATE, BaseRcraPlugin.PARAM_TO_DATE, BaseRcraPlugin.PARAM_CHANGE_DATE
    }),
    FA_BY_HANDLER(SolicitRequestType.FA_BY_HANDLER, new PluginServiceParameterDescriptor[] {
            BaseRcraPlugin.PARAM_USE_SOLICIT_HISTORY, BaseRcraPlugin.PARAM_HANDLER_ID_REQ, BaseRcraPlugin.PARAM_CHANGE_DATE
    }),
    FA_BY_STATE(SolicitRequestType.FA_BY_STATE, new PluginServiceParameterDescriptor[] {
            BaseRcraPlugin.PARAM_USE_SOLICIT_HISTORY, BaseRcraPlugin.PARAM_STATE_REQ, BaseRcraPlugin.PARAM_CHANGE_DATE
    }),
    GS_BY_HANDLER(SolicitRequestType.GS_BY_HANDLER, new PluginServiceParameterDescriptor[] {
            BaseRcraPlugin.PARAM_USE_SOLICIT_HISTORY, BaseRcraPlugin.PARAM_HANDLER_ID_REQ, BaseRcraPlugin.PARAM_CHANGE_DATE, BaseRcraPlugin.PARAM_OWNER, BaseRcraPlugin.PARAM_SEQUENCE_NUMBER
    }),
    GS_BY_STATE(SolicitRequestType.GS_BY_STATE, new PluginServiceParameterDescriptor[] {
            BaseRcraPlugin.PARAM_USE_SOLICIT_HISTORY, BaseRcraPlugin.PARAM_STATE_REQ, BaseRcraPlugin.PARAM_CHANGE_DATE
    }),
    HD_BY_HANDLER(SolicitRequestType.HD_BY_HANDLER, new PluginServiceParameterDescriptor[] {
            BaseRcraPlugin.PARAM_USE_SOLICIT_HISTORY, BaseRcraPlugin.PARAM_HANDLER_ID_REQ, BaseRcraPlugin.PARAM_CHANGE_DATE, BaseRcraPlugin.PARAM_STATE, BaseRcraPlugin.PARAM_SOURCE_TYPE, BaseRcraPlugin.PARAM_SEQUENCE_NUMBER
    }),
    HD_BY_STATE(SolicitRequestType.HD_BY_STATE, new PluginServiceParameterDescriptor[] {
            BaseRcraPlugin.PARAM_USE_SOLICIT_HISTORY, BaseRcraPlugin.PARAM_STATE_REQ, BaseRcraPlugin.PARAM_CHANGE_DATE, BaseRcraPlugin.PARAM_END_DATE
    }),
    PM_DATA_BY_HANDLER(SolicitRequestType.PM_BY_HANDLER, new PluginServiceParameterDescriptor[] {
            BaseRcraPlugin.PARAM_USE_SOLICIT_HISTORY, BaseRcraPlugin.PARAM_HANDLER_ID_REQ, BaseRcraPlugin.PARAM_CHANGE_DATE
    }),
    PM_DATA_BY_STATE(SolicitRequestType.PM_BY_STATE, new PluginServiceParameterDescriptor[] {
            BaseRcraPlugin.PARAM_USE_SOLICIT_HISTORY, BaseRcraPlugin.PARAM_STATE_REQ, BaseRcraPlugin.PARAM_CHANGE_DATE
    }),
    CH_DATA_BY_HANDLER(SolicitRequestType.CH_BY_HANDLER, new PluginServiceParameterDescriptor[] {
            BaseRcraPlugin.PARAM_USE_SOLICIT_HISTORY, BaseRcraPlugin.PARAM_HANDLER_ID_REQ, BaseRcraPlugin.PARAM_CHANGE_DATE
    }),
    CH_DATA_BY_STATE(SolicitRequestType.CH_BY_STATE, new PluginServiceParameterDescriptor[] {
            BaseRcraPlugin.PARAM_USE_SOLICIT_HISTORY, BaseRcraPlugin.PARAM_STATE_REQ, BaseRcraPlugin.PARAM_CHANGE_DATE
    }),
    EM_DATA_BY_HANDLER(SolicitRequestType.EM_BY_HANDLER, new PluginServiceParameterDescriptor[] {
            BaseRcraPlugin.PARAM_USE_SOLICIT_HISTORY, BaseRcraPlugin.PARAM_HANDLER_ID_REQ, BaseRcraPlugin.PARAM_CHANGE_DATE
    }),
    EM_DATA_BY_STATE(SolicitRequestType.EM_BY_STATE, new PluginServiceParameterDescriptor[] {
            BaseRcraPlugin.PARAM_USE_SOLICIT_HISTORY, BaseRcraPlugin.PARAM_STATE_REQ, BaseRcraPlugin.PARAM_CHANGE_DATE, BaseRcraPlugin.PARAM_END_DATE
    }),
    HD_MAX_SEQUENCE(SolicitRequestType.HD_MAX_SEQUENCE, new PluginServiceParameterDescriptor[] {
            BaseRcraPlugin.PARAM_USE_SOLICIT_HISTORY, BaseRcraPlugin.PARAM_HANDLER_ID_REQ, BaseRcraPlugin.PARAM_SOURCE_TYPE, BaseRcraPlugin.PARAM_STATE
    });

    /**
     * The solicit request type for this parameter set.
     */
    private SolicitRequestType solicitRequestType;

    /**
     * Array of plugin parameters for this parameter set.
     */
    private PluginServiceParameterDescriptor[] parameterDescriptors;

    /**
     * Creates a new parameter set.
     *
     * @param solicitRequestType The solicit request type
     * @param parameterDescriptors Array of plugin service parameters
     */
    ParameterSet(SolicitRequestType solicitRequestType,
                 PluginServiceParameterDescriptor... parameterDescriptors) {
        this.solicitRequestType = solicitRequestType;
        this.parameterDescriptors = parameterDescriptors;
    }

    /**
     * Returns the solicit request type.
     * @return The solicit request type
     */
    public SolicitRequestType getSolicitRequestType() {
        return solicitRequestType;
    }

    /**
     * Returns the plugin service parameters.
     * @return Array of plugin service parameters
     */
    public PluginServiceParameterDescriptor[] getParameterDescriptors() {
        return parameterDescriptors;
    }

    /**
     * Returns a String with the name of this parameter set.
     * @return String with the name of the parameter set
     */
    @Override
    public String toString() {
        return solicitRequestType.toString();
    }

    /**
     * Returns the parameter set for the given name.
     * @param name String with the name of the parameter set
     * @return The matching parameter set or null if no match is found
     */
    public static ParameterSet getByName(String name) {
        ParameterSet parameterSetOut = null;

        if(name == null)  {
            return parameterSetOut;
        }

        for(ParameterSet parameterSet : values()) {
            if(parameterSet.getSolicitRequestType().toString().trim().toLowerCase()
                    .equals(name.trim().toLowerCase())) {
                parameterSetOut = parameterSet;
                break;
            }
        }

        return parameterSetOut;
    }
}
