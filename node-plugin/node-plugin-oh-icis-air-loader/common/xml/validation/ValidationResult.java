package com.windsor.node.plugin.common.xml.validation;

import java.util.Collection;

public interface ValidationResult {
   boolean hasErrors();

   Collection errors();
}
