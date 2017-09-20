package com.windsor.node.plugin.common.xml.bind.annotation.adapters;

import java.math.BigDecimal;
import javax.xml.bind.annotation.adapters.XmlAdapter;

public class DoubleAdapter extends XmlAdapter<String, Double> {
   public Double unmarshal(String s) throws Exception {
      return Double.valueOf(Double.parseDouble(s));
   }

   public String marshal(Double value) throws Exception {
      return value == null?null:(new BigDecimal(value.doubleValue())).toPlainString();
   }
}
