package com.windsor.node.plugin.attains.service;

import com.windsor.node.common.domain.CommonTransactionStatusCode;
import com.windsor.node.common.domain.NodeTransaction;
import com.windsor.node.common.domain.ProcessContentResult;
import com.windsor.node.plugin.attains.domain.ObjectFactory;
import com.windsor.node.plugin.attains.domain.OperationType;
import com.windsor.node.plugin.attains.domain.ScheduleParameters;
import org.apache.commons.lang.exception.ExceptionUtils;

import java.util.Arrays;
import java.util.List;

public class AttainsDeleteService extends AbstractAttainsService {

    private static final List<String> HEADERS = Arrays.asList(
            ARG_HEADER_SENDER_ADDRESS,
            ARG_HEADER_CONTACT_INFO
    );

    public AttainsDeleteService() {
        super(OperationType.DELETE);

        this.objectFactory = new ObjectFactory();
        debug("Setting internal runtime argument list");
        for (String config : HEADERS) {
            getConfigurationArguments().put(config, "");
        }
        getConfigurationArguments().put(ARG_HEADER_PAYLOAD_OP, getOperationType().getPayloadOperation());
    }

    private ScheduleParameters scheduleParameters;
    private ObjectFactory objectFactory;

    @Override
    public ProcessContentResult process(NodeTransaction transaction) {
        ProcessContentResult result = new ProcessContentResult();
        result.setStatus(CommonTransactionStatusCode.Failed);
        result.setSuccess(false);

        recordActivity(result, "ATTAINS \"%s\" process starting.", getOperationType());
        validateTransaction(transaction);
        recordActivity(result, "Creating process parameters from transaction.");
        scheduleParameters = new ScheduleParameters(transaction);
        recordActivity(result, String.format("Schedule parameters: ", scheduleParameters));

        try {

            recordActivity(result, "Preparing exchange for delivery. Completed.");
            recordActivity(result, "Saving exchange network transaction.");
            getTransactionDao().save(transaction);
            recordActivity(result, "Saving exchange network transaction. Completed.");
            result.setSuccess(true);
            result.setStatus(CommonTransactionStatusCode.Pending);

            recordActivity(result, "ATTAINS \"%s\" process completed successfully.", getOperationType());
        } catch (Exception exception) {
            result.setSuccess(Boolean.FALSE);
            result.setStatus(CommonTransactionStatusCode.Failed);
            recordActivity(result, exception.getLocalizedMessage() + ", root cause: "
                    + ExceptionUtils.getRootCauseMessage(exception));
        }

        return result;
    }
}
