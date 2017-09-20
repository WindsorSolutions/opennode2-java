package com.windsor.node.plugin.common.velocity.jdbc;

import com.windsor.node.plugin.common.velocity.TemplateHelper;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Iterator;
import javax.sql.DataSource;
import org.apache.commons.beanutils.BasicDynaBean;
import org.apache.commons.beanutils.BasicDynaClass;
import org.apache.commons.beanutils.ConvertUtils;
import org.apache.commons.beanutils.DynaBean;
import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.beanutils.ResultSetDynaClass;
import org.apache.commons.lang3.StringUtils;

public class JdbcTemplateHelper extends TemplateHelper {
   private static final String ORACLE = "oracle";
   private static final String MS_SQL = "microsoft sql server";
   private static final String MY_SQL = "mysql";
   private Connection connection;
   private int resultingRecordCount = 0;

   public JdbcTemplateHelper() {
   }

   public JdbcTemplateHelper(DataSource dataSource) {
      if(dataSource == null) {
         throw new IllegalArgumentException("null datasource");
      } else {
         try {
            this.connection = dataSource.getConnection();
         } catch (SQLException var3) {
            throw new RuntimeException(var3);
         }
      }
   }

   public JdbcTemplateHelper.DbType getDbType() {
      JdbcTemplateHelper.DbType type = JdbcTemplateHelper.DbType.Unrecognized;
      if(null != this.connection) {
         String driverName;
         try {
            driverName = this.connection.getMetaData().getDriverName();
            this.logger.debug("Driver name: " + driverName);
         } catch (SQLException var4) {
            throw new RuntimeException("couldn\'t get jdbc driver name from connection");
         }

         if(StringUtils.containsIgnoreCase(driverName, "oracle")) {
            type = JdbcTemplateHelper.DbType.Oracle;
         } else if(StringUtils.containsIgnoreCase(driverName, "microsoft sql server")) {
            type = JdbcTemplateHelper.DbType.MSSQL;
         } else if(StringUtils.containsIgnoreCase(driverName, "mysql")) {
            type = JdbcTemplateHelper.DbType.MySQL;
         }
      }

      this.logger.debug("Using database type " + type);
      return type;
   }

   /** @deprecated */
   public String toDbDateString(String dateString) {
      this.logger.debug("toDbDateString: " + dateString);

      Date date;
      try {
         date = this.makeSqlDate(dateString);
      } catch (ParseException var6) {
         throw new IllegalArgumentException("Not a recognized date format, root exception: " + var6);
      }

      String formatStr;
      if(this.getDbType().equals(JdbcTemplateHelper.DbType.Oracle)) {
         formatStr = "dd-MMM-yy";
      } else {
         formatStr = "yyyy-MM-dd";
      }

      SimpleDateFormat sdf = new SimpleDateFormat(formatStr);
      String output = sdf.format(date);
      this.logger.debug("toDbDateString output: " + output);
      return output;
   }

   public Date covertToDbDate(String dateString) {
      this.logger.debug("covertToDbDate: " + dateString);

      Date date;
      try {
         date = this.makeSqlDate(dateString);
      } catch (ParseException var4) {
         throw new IllegalArgumentException("Not a recognized date format, root exception: " + var4);
      }

      SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
      this.logger.debug("covertToDbDate output: " + sdf.format(date));
      return date;
   }

   public Object[] getList(String sql, String propertyName) {
      return this.getList(sql, (Object[])null, propertyName, 12);
   }

   public Object[] getList(String sql, Object arg, String propertyName) {
      return this.getList(sql, (Object[])this.trapArrayList(arg), propertyName, 12);
   }

   public Object[] getList(String sql, Object arg, String propertyName, int type) {
      return this.getList(sql, this.trapArrayList(arg), propertyName, type);
   }

   public Object[] getList(String sql, Object[] args, String propertyName, int type) {
      try {
         PreparedStatement ex = this.getPreparedStatement(sql, args, type);
         ResultSetDynaClass rsdc = new ResultSetDynaClass(ex.executeQuery());
         ArrayList results = new ArrayList();
         Iterator rows = rsdc.iterator();

         while(rows.hasNext()) {
            DynaBean bean = (DynaBean)rows.next();
            results.add(bean.get(propertyName));
         }

         ex.close();
         return results.toArray();
      } catch (Exception var10) {
         this.logger.error(var10.getMessage(), var10);
         throw new RuntimeException("Error while getting list: " + var10.getMessage(), var10);
      }
   }

   public Object getObject(String sql, Object arg) {
      return this.getObject(sql, this.trapArrayList(arg));
   }

   public Object getObject(String sql, Object[] args) {
      try {
         PreparedStatement ex = this.getPreparedStatement(sql, args, 12);
         ResultSetDynaClass rsdc = new ResultSetDynaClass(ex.executeQuery());
         BasicDynaClass bdc = new BasicDynaClass("objectCopy", BasicDynaBean.class, rsdc.getDynaProperties());
         DynaBean newRow = null;
         Iterator rows = rsdc.iterator();
         if(rows.hasNext()) {
            DynaBean oldRow = (DynaBean)rows.next();
            newRow = bdc.newInstance();
            PropertyUtils.copyProperties(newRow, oldRow);
         }

         ex.close();
         return newRow;
      } catch (Exception var9) {
         this.logger.error(var9.getMessage(), var9);
         throw new RuntimeException("Error in getObject(): " + var9.getMessage(), var9);
      }
   }

   public Iterator<DynaBean> getData(String sql) {
      return this.getData(sql, (Object[])null);
   }

   public Iterator<DynaBean> getData(String sql, Object arg) {
      return this.getData(sql, this.trapArrayList(arg));
   }

   public Iterator<DynaBean> getData(String sql, Object[] args) {
      return this.getData(sql, args, 12);
   }

   public Iterator<DynaBean> getData(String sql, Object[] args, int type) {
      try {
         PreparedStatement ex = this.getPreparedStatement(sql, args, type);
         ResultSetDynaClass rsdc = new ResultSetDynaClass(ex.executeQuery());
         ArrayList results = new ArrayList();
         BasicDynaClass bdc = new BasicDynaClass("objectCopy", BasicDynaBean.class, rsdc.getDynaProperties());
         Iterator rows = rsdc.iterator();

         while(rows.hasNext()) {
            DynaBean oldRow = (DynaBean)rows.next();
            DynaBean newRow = bdc.newInstance();
            PropertyUtils.copyProperties(newRow, oldRow);
            results.add(newRow);
         }

         ex.close();
         this.logger.trace("query returned " + results.size() + " results");
         return results.iterator();
      } catch (Exception var11) {
         this.logger.error(var11.getMessage(), var11);
         throw new RuntimeException("Error in getData(): " + var11.getMessage(), var11);
      }
   }

   private PreparedStatement getPreparedStatement(String sql, Object[] args, int type) {
      this.checkConnection();
      this.traceArgs(sql, args, (String)null, type);

      try {
         PreparedStatement ex = this.connection.prepareStatement(sql);
         if(args != null && args.length > 0) {
            for(int i = 1; i <= args.length; ++i) {
               Object argVal = args[i - 1];
               if(type != -5 && type != 4) {
                  if(type == 93) {
                     this.logger.trace("Converting " + argVal + " to Timestamp");
                     ex.setTimestamp(i, new Timestamp(this.makeSqlDate(argVal).getTime()));
                  } else if(type == 91) {
                     this.logger.trace("Converting " + argVal + " to Sql Date");
                     ex.setDate(i, this.makeSqlDate(argVal));
                  } else {
                     ex.setObject(i, argVal);
                  }
               } else {
                  this.logger.trace("Converting " + argVal + " to int");
                  ex.setInt(i, ((Integer)ConvertUtils.convert(argVal, Integer.TYPE)).intValue());
               }
            }
         }

         return ex;
      } catch (Exception var7) {
         this.logger.error(var7.getMessage(), var7);
         throw new RuntimeException("Error preparing statement : " + var7.getMessage(), var7);
      }
   }

   private void traceArgs(String sql, Object[] args, String propertyName, int type) {
      if(StringUtils.isNotBlank(sql)) {
         this.logger.trace("sql = " + sql);
      }

      if(null != args && args.length > 0) {
         this.logger.trace("args.length = " + args.length);

         for(int i = 0; i < args.length; ++i) {
            this.logger.trace("args[" + i + "] = " + args[i]);
         }
      }

      if(StringUtils.isNotBlank(propertyName)) {
         this.logger.trace("propertyName = " + propertyName);
      }

      this.logger.trace("type = " + type);
   }

   private void checkConnection() {
      if(null == this.connection) {
         throw new RuntimeException("Connection is null");
      } else {
         try {
            if(this.connection.isClosed()) {
               throw new RuntimeException("Connection is closed");
            }
         } catch (SQLException var2) {
            throw new RuntimeException("Problem checking connection status: " + var2);
         }
      }
   }

   public int getResultingRecordCount() {
      return this.resultingRecordCount;
   }

   public void setResultingRecordCount(int resultingRecordCount) {
      this.resultingRecordCount = resultingRecordCount;
   }

   public Connection getConnection() {
      return this.connection;
   }

   public void setConnection(Connection connection) {
      this.connection = connection;
   }

   public static enum DbType {
      Oracle,
      MSSQL,
      MySQL,
      Unrecognized;
   }
}
