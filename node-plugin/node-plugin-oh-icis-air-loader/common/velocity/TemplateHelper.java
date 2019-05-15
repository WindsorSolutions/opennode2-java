package com.windsor.node.plugin.common.velocity;

import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.TimeZone;
import org.apache.commons.beanutils.converters.BooleanConverter;
import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.time.DateUtils;
import org.apache.commons.lang3.time.StopWatch;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class TemplateHelper {
   public static final String XML_DATE_FORMAT = "yyyy-MM-dd";
   public static final String DATE_FORMAT_ORACLE_DEFAULT = "dd-MMM-yy";
   public static final String TIMESTAMP_FORMAT_MINS = "yyyy-MM-dd HH:mm";
   public static final String TIMESTAMP_FORMAT_SECS = "yyyy-MM-dd HH:mm:ss";
   public static final String TIMESTAMP_FORMAT_MILLI = "yyyy-MM-dd HH:mm:ss.S";
   public static final String TIMESTAMP_FORMAT_MILLI2 = "yyyy-MM-dd HH:mm:ss.SS";
   public static final String TIMESTAMP_FORMAT_MILLI3 = "yyyy-MM-dd HH:mm:ss.SSS";
   public static final String TIMESTAMP_FORMAT_MILLI4 = "yyyy-MM-dd HH:mm:ss.SSSS";
   public static final String AM_PM_INPUT_ERROR = "input must be in hh:mm:ss [AM|PM] format";
   public static final String[] DATE_FORMATS = new String[]{"yyyy-MM-dd", "dd-MMM-yy", "yyyy-MM-dd HH:mm", "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm:ss.S", "yyyy-MM-dd HH:mm:ss.SS", "yyyy-MM-dd HH:mm:ss.SSS", "yyyy-MM-dd HH:mm:ss.SSSS"};
   protected static final int NUM_TIME_PARTS = 3;
   protected static final int HOURS_IN_HALF_DAY = 12;
   protected Logger logger = LoggerFactory.getLogger(this.getClass());
   protected StopWatch watch = new StopWatch();
   protected BooleanConverter booleanConverter;
   protected SimpleDateFormat simpleDateFormat;

   public void startStopWatch() {
      this.watch.start();
   }

   public void stopStopWatch() {
      this.watch.stop();
   }

   public void printElapsedTime() {
      this.print(this.watch.toString());
   }

   public String escapeXml(String val) {
      return StringEscapeUtils.escapeXml(val);
   }

   public String escapeCsv(String val) {
      return StringEscapeUtils.escapeCsv(val);
   }

   public String escapeHtml(String val) {
      return StringEscapeUtils.escapeHtml4(val);
   }

   public String currentTimeAsXmlDate() {
      SimpleDateFormat sdfInput = new SimpleDateFormat("yyyy-MM-dd");
      return sdfInput.format(Calendar.getInstance(TimeZone.getDefault()).getTime());
   }

   public String toXmlBoolean(Object val) {
      if(null == this.booleanConverter) {
         this.booleanConverter = new BooleanConverter();
      }

      return ((Boolean)this.booleanConverter.convert((Class)null, val)).toString();
   }

   public String toXmlDate(Object val) throws ParseException {
      if(null == this.simpleDateFormat) {
         this.simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
      }

      return this.simpleDateFormat.format(DateUtils.parseDate(val.toString(), DATE_FORMATS));
   }

   public String toXmlDateTime(Object val) {
      SimpleDateFormat sdfInput = new SimpleDateFormat("yyyy-MM-dd\'T\'HH:mm:ss.S");
      return sdfInput.format(val);
   }

   public String amPmStringToXmlTime(Object val) {
      String input = (String)val;
      this.logger.trace("amPmStringToXmlTime: input = " + input);
      boolean isPm = false;
      String[] timeAndAmPm = StringUtils.split(input);
      if(timeAndAmPm.length == 2) {
         String timeParts = timeAndAmPm[1];
         isPm = timeParts.equalsIgnoreCase("PM");
      } else if(timeAndAmPm.length > 2) {
         throw new IllegalArgumentException("input must be in hh:mm:ss [AM|PM] format");
      }

      String[] timeParts1 = StringUtils.split(timeAndAmPm[0], ":");
      if(timeParts1.length != 3) {
         throw new IllegalArgumentException("input must be in hh:mm:ss [AM|PM] format");
      } else {
         int hour = Integer.parseInt(timeParts1[0]);
         if(isPm) {
            hour += 12;
         }

         int minute = Integer.parseInt(timeParts1[1]);
         int second = Integer.parseInt(timeParts1[2]);
         GregorianCalendar cal = new GregorianCalendar();
         cal.set(11, hour);
         cal.set(12, minute);
         cal.set(13, second);
         SimpleDateFormat sdfOutput = new SimpleDateFormat("HH:mm:ss");
         String output = sdfOutput.format(cal.getTime());
         this.logger.trace("amPmStringToXmlTime: output = " + output);
         return output;
      }
   }

   public String getCurrentDateTime() {
      return this.toXmlDateTime(new Long(System.currentTimeMillis()));
   }

   public void print(Object val) {
      if(val != null) {
         this.logger.info(val.toString());
      } else {
         this.logger.info("");
      }

   }

   protected Date makeSqlDate(Object val) throws ParseException {
      return new Date(DateUtils.parseDate(val.toString(), DATE_FORMATS).getTime());
   }

   protected Object[] trapArrayList(Object arg) {
      Object[] newArgs = null;
      if(null != arg) {
         if(arg instanceof ArrayList) {
            this.logger.debug("converting ArrayList to Object[]");
            ArrayList realArgs = (ArrayList)arg;
            newArgs = realArgs.toArray();
         } else {
            newArgs = new Object[]{arg};
         }
      }

      return newArgs;
   }
}
