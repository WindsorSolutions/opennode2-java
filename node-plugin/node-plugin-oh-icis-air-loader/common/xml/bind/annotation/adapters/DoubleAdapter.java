package com.windsor.node.plugin.common.xml.bind.annotation.adapters;

import java.math.BigDecimal;
import javax.xml.bind.annotation.adapters.XmlAdapter;

public class DoubleAdapter extends XmlAdapter {
//   public Double unmarshal(String s) throws Exception {
//      return Double.valueOf(Double.parseDouble(s));
//   }
//
//   public String marshal(Double value) throws Exception {
//      return value == null?null:(new BigDecimal(value.doubleValue())).toPlainString();
//   }

   @Override
   public Object unmarshal(Object v) throws Exception {
      String value = v.toString();
      return Double.valueOf(Double.parseDouble(value));
   }

   @Override
   public Object marshal(Object v) throws Exception {
      Double value = (Double) v;
      return value == null?null:(new BigDecimal(value.doubleValue())).toPlainString();
   }
}
