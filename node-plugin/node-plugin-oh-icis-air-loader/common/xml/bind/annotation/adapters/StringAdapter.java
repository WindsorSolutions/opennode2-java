package com.windsor.node.plugin.common.xml.bind.annotation.adapters;

import javax.xml.bind.annotation.adapters.XmlAdapter;

public class StringAdapter extends XmlAdapter {
   public String unmarshal(String s) throws Exception {
      return s;
   }

   public String marshal(String value) throws Exception {
      return value;
   }
}
