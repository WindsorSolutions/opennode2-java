package com.windsor.node.plugin.attains.domain;

import com.windsor.node.common.domain.PluginServiceImplementorDescriptor;
import com.windsor.node.common.domain.RequestType;
import com.windsor.node.common.domain.ServiceType;
import com.windsor.node.plugin.attains.service.AttainsGetStatusService;
import com.windsor.node.plugin.attains.service.AttainsSubmitService;

/**
 * Enumeration of valid operations for the ATTAINS plugin.
 */
public enum OperationType {

    SUBMIT(new PluginServiceImplementorDescriptor(
            "Submit ATTAINS Documents",
            "Flow ATTAINS Documents",
            "1.0",
            AttainsSubmitService.class.getCanonicalName()),
            "Update-Insert",
            RequestType.Submit,
            ServiceType.TASK),
    DELETE(new PluginServiceImplementorDescriptor(
            "Delete ATTAINS Documents",
            "Delete ATTAINS Documents",
            "1.0",
            AttainsSubmitService.class.getCanonicalName()),
            "Delete",
            RequestType.Execute,
            ServiceType.TASK),
    GET_STATUS(new PluginServiceImplementorDescriptor(
            "Get Status",
            "Get Status for pending ATTAINS Documents submissions",
            "1.0",
            AttainsGetStatusService.class.getCanonicalName()),
            null,
            RequestType.Query,
            ServiceType.TASK);

    private PluginServiceImplementorDescriptor pluginDescriptor;
    private String payloadOperation;
    private RequestType requestType;
    private ServiceType serviceType;

    OperationType(PluginServiceImplementorDescriptor pluginDescriptor, String payloadOperation, RequestType requestType,
                  ServiceType serviceType) {
        this.pluginDescriptor = pluginDescriptor;
        this.payloadOperation = payloadOperation;
        this.requestType = requestType;
        this.serviceType = serviceType;
    }

    public PluginServiceImplementorDescriptor getPluginDescriptor() {
        return pluginDescriptor;
    }

    public String getPayloadOperation() {
        return payloadOperation;
    }

    public RequestType getRequestType() {
        return requestType;
    }

    public ServiceType getServiceType() {
        return serviceType;
    }
}
