package com.windsor.node.plugin.rcra.outbound;

public class PendingSubmissionInProgressException extends RuntimeException {

    public PendingSubmissionInProgressException(String msg) {
        super(msg);
    }

}
