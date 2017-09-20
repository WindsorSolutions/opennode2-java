package com.windsor.node.plugin.common.xml.bind.annotation.adapters;

import java.util.Date;
import javax.xml.bind.DatatypeConverter;
import javax.xml.bind.annotation.adapters.XmlAdapter;
import org.apache.commons.lang3.time.DateFormatUtils;

public class DateNoTimeZoneAdapter extends XmlAdapter<String, Date> {
   private static final String DATE_FORMAT = "yyyy-MM-dd";

   public Date unmarshal(String s) throws Exception {
      return DatatypeConverter.parseDate(s).getTime();
   }

   public String marshal(Date date) throws Exception {
      return DateFormatUtils.format(date, "yyyy-MM-dd");
   }
}
