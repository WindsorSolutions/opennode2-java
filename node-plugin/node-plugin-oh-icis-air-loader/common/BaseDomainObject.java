package com.windsor.node.plugin.common;

import com.windsor.node.common.domain.DomainStringStyle;
import java.text.DecimalFormat;
import org.apache.commons.lang3.builder.ReflectionToStringBuilder;

public abstract class BaseDomainObject {
   protected static final String DECIMAL_FORMAT = "#.################";

   protected String getFormattedDouble(Double d) {
      DecimalFormat f = new DecimalFormat("#.################");
      return f.format(d);
   }

   public String toString() {
      ReflectionToStringBuilder rtsb = new ReflectionToStringBuilder(this, new DomainStringStyle());
      rtsb.setAppendStatics(false);
      rtsb.setAppendTransients(false);
      return rtsb.toString();
   }
}
