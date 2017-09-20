package com.windsor.node.plugin.common.xml.bind.annotation.adapters;

import javax.xml.bind.annotation.adapters.XmlAdapter;

public class IntegerAdapter extends XmlAdapter<String, Integer> {
   public Integer unmarshal(String s) throws Exception {
      return Integer.valueOf(Integer.parseInt(s));
   }

   public String marshal(Integer value) throws Exception {
      return value == null?null:value.toString();
   }
}
