package com.windsor.node.plugin.common.xml.bind.annotation.adapters;

import java.util.Date;
import java.util.GregorianCalendar;
import javax.xml.bind.DatatypeConverter;
import javax.xml.bind.annotation.adapters.XmlAdapter;

public class DateAdapter extends XmlAdapter<String, Date> {
   public Date unmarshal(String s) throws Exception {
      return DatatypeConverter.parseDate(s).getTime();
   }

   public String marshal(Date date) throws Exception {
      GregorianCalendar cal = new GregorianCalendar();
      cal.setTime(date);
      return DatatypeConverter.printDate(cal);
   }
}
