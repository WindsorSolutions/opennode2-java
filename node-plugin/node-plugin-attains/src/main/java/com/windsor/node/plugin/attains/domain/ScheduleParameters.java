package com.windsor.node.plugin.attains.domain;

import com.windsor.node.common.domain.NodeTransaction;

/**
 * A class to wrap the parameters defined in the schedule.
 *
 */
public class ScheduleParameters {

    private final NodeTransaction transaction;

    public ScheduleParameters(NodeTransaction transaction) {
        this.transaction = transaction;
    }

    @SuppressWarnings("unchecked")
    private <T> T getParameter(PluginParameters parameter, Class<T> clazz) {
        Object obj = transaction.getRequest().getParameters()
                .get(parameter.getParameterDescriptor().getName());
        return (T) (obj != null ? obj : transaction.getRequest()
                .getParameters().get(parameter.ordinal()));
    }

    public boolean isValidateXml() {
        return parseBoolean(getParameter(PluginParameters.VALIDATE_XML, String.class));
    }

    private Boolean parseBoolean(String s) {
        return s == null ? null : Boolean.parseBoolean(s);
    }
}
