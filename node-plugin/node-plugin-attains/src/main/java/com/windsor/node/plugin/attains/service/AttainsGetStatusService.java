package com.windsor.node.plugin.attains.service;

import com.windsor.node.common.domain.CommonTransactionStatusCode;
import com.windsor.node.common.domain.NodeTransaction;
import com.windsor.node.common.domain.ProcessContentResult;
import com.windsor.node.plugin.attains.domain.OperationType;

public class AttainsGetStatusService extends AbstractAttainsService {

    public AttainsGetStatusService() {
        super(OperationType.GET_STATUS);
    }

    @Override
    public ProcessContentResult process(NodeTransaction transaction) {
        ProcessContentResult result = new ProcessContentResult();
        result.setStatus(CommonTransactionStatusCode.Failed);
        result.setSuccess(false);

        return result;
    }
}
