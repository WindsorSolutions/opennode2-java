package com.windsor.node.plugin.attains.domain;

import com.windsor.node.data.dao.PluginServiceParameterDescriptor;

public enum PluginParameters {

    VALIDATE_XML(new PluginServiceParameterDescriptor(
            "Validate Xml (true or false)",
                 PluginServiceParameterDescriptor.TYPE_BOOLEAN,
                 Boolean.TRUE,
            "Whether to validate the generated XML."));

    private PluginServiceParameterDescriptor parameterDescriptor;

    PluginParameters(PluginServiceParameterDescriptor parameterDescriptor) {
        this.parameterDescriptor = parameterDescriptor;
    }

    public PluginServiceParameterDescriptor getParameterDescriptor() {
        return parameterDescriptor;
    }
}
