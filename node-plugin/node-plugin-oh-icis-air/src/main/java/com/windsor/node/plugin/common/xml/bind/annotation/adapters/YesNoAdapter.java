package com.windsor.node.plugin.common.xml.bind.annotation.adapters;

import javax.xml.bind.annotation.adapters.XmlAdapter;

public class YesNoAdapter extends XmlAdapter<String, String> {
   private static final String JAVA_TRUE_VALUE = "Y";
   private static final String XML_TRUE_VALUE = "true";
   private static final String XML_FALSE_VALUE = "false";

   public String unmarshal(String s) throws Exception {
      return s;
   }

   public String marshal(String value) throws Exception {
      return value == null?null:("Y".equals(value)?"true":"false");
   }
}
