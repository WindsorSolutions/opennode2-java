package com.windsor.node.plugin.common.xml.validation;

public class ValidationException extends RuntimeException {
   private static final long serialVersionUID = 1L;

   public ValidationException(String message, Throwable t) {
      super(message, t);
   }

   public ValidationException(String message) {
      super(message);
   }
}
