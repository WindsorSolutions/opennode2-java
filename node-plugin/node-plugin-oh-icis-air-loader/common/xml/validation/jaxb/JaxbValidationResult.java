package com.windsor.node.plugin.common.xml.validation.jaxb;

import com.windsor.node.plugin.common.xml.validation.ValidationResult;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import org.apache.commons.collections.CollectionUtils;

public class JaxbValidationResult implements ValidationResult {
   private final List errors = new ArrayList();

   public void error(String message) {
      this.errors.add(message);
   }

   public Collection errors() {
      return CollectionUtils.unmodifiableCollection(this.errors);
   }

   public boolean hasErrors() {
      return this.errors.size() > 0;
   }
}
