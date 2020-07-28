package com.windsor.node.plugin.rcra59;

/**
 * Provides an exception that encapsulates an exception for the RCRA 5.4 Outbound plugin.
 */
public class RcraOutboundException extends Exception {

    public RcraOutboundException(String message) {
        super(message);
    }

    public RcraOutboundException(String message, Exception exception) {
        super(message, exception);
    }
}
