package com.windsor.node.plugin.common.xml.bind.annotation.adapters;

import javax.xml.bind.annotation.adapters.XmlAdapter;

public class TwoDigitIntegerAdapter extends XmlAdapter<String, Integer> {
   public Integer unmarshal(String s) throws Exception {
      return Integer.valueOf(Integer.parseInt(s));
   }

   public String marshal(Integer value) throws Exception {
      return value == null?null:String.format("%02d", new Object[]{value});
   }
}
