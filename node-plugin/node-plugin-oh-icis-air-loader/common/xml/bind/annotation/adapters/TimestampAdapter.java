package com.windsor.node.plugin.common.xml.bind.annotation.adapters;

import java.sql.Timestamp;
import java.util.GregorianCalendar;
import javax.xml.bind.DatatypeConverter;
import javax.xml.bind.annotation.adapters.XmlAdapter;

public class TimestampAdapter extends XmlAdapter {
   public Timestamp unmarshal(String s) throws Exception {
      return new Timestamp(DatatypeConverter.parseDate(s).getTime().getTime());
   }

   public String marshal(Timestamp timestamp) throws Exception {
      GregorianCalendar cal = new GregorianCalendar();
      cal.setTime(timestamp);
      return DatatypeConverter.printDate(cal);
   }
}
