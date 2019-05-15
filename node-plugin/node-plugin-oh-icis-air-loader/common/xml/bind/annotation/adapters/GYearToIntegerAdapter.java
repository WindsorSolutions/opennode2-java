package com.windsor.node.plugin.common.xml.bind.annotation.adapters;

import javax.xml.bind.annotation.adapters.XmlAdapter;
import org.apache.commons.lang3.StringUtils;

public class GYearToIntegerAdapter extends XmlAdapter {
   public Integer unmarshal(String v) throws Exception {
      return !StringUtils.isBlank(v) && StringUtils.isNumeric(v)?new Integer(v):null;
   }

   public String marshal(Integer v) throws Exception {
      return v == null?"":v.toString();
   }
}
