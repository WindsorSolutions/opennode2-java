package com.windsor.node.plugin.common.xml.bind.annotation.adapters;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import javax.xml.bind.annotation.adapters.XmlAdapter;

public abstract class AbstractBigDecimalFormatAdapter extends XmlAdapter {
   protected abstract String getNumberFormatString();

   public BigDecimal unmarshal(String s) throws Exception {
      return new BigDecimal(s);
   }

   public String marshal(BigDecimal value) throws Exception {
      return value == null?null:(new DecimalFormat(this.getNumberFormatString())).format(value);
   }
}
