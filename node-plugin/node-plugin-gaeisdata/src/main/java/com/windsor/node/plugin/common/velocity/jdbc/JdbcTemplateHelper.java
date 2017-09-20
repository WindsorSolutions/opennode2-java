package com.windsor.node.plugin.common.velocity.jdbc;

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
import org.apache.commons.lang.NullArgumentException;
import org.apache.commons.lang.StringUtils;

import com.windsor.node.plugin.common.velocity.TemplateHelper;


public class JdbcTemplateHelper extends TemplateHelper {
    private static final String ORACLE = "oracle";
    private static final String IBM_DB2 = "ibm db2";
    private static final String MS_SQL = "microsoft sql server";
    private static final String MY_SQL = "mysql";
    private Connection connection;

    public JdbcTemplateHelper() {
    }

    public static enum DbType {
        Oracle, DB2, MSSQL, MySQL, Unrecognized;
        private DbType() {
        }
    }

    private int resultingRecordCount = 0;

    public JdbcTemplateHelper(DataSource dataSource) {
        if (dataSource == null) {
            throw new NullArgumentException("null datasource");
        }
        try {
            this.connection = dataSource.getConnection();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public DbType getDbType() {
        DbType type = DbType.Unrecognized;
        if (null != this.connection) {
            String driverName;
            try {
                driverName = this.connection.getMetaData().getDriverName();
                this.logger.debug("Driver name: " + driverName);
            } catch (SQLException sqle) {
                throw new RuntimeException("couldn't get jdbc driver name from connection");
            }
            if (StringUtils.containsIgnoreCase(driverName, "oracle")) {
                type = DbType.Oracle;
            } else if (StringUtils.containsIgnoreCase(driverName, "ibm db2")) {
                type = DbType.DB2;
            } else if (StringUtils.containsIgnoreCase(driverName, "microsoft sql server")) {
                type = DbType.MSSQL;
            } else if (StringUtils.containsIgnoreCase(driverName, "mysql")) {
                type = DbType.MySQL;
            }
        }
        this.logger.debug("Using database type " + type);
        return type;
    }

    public String toDbDateString(String dateString) {
        this.logger.debug("toDbDateString: " + dateString);
        Date date;
        try {
            date = makeSqlDate(dateString);
        } catch (ParseException pe) {
            throw new IllegalArgumentException("Not a recognized date format, root exception: " + pe);
        }
        String formatStr;
        if (getDbType().equals(DbType.Oracle)) {
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
            date = makeSqlDate(dateString);
        } catch (ParseException pe) {
            throw new IllegalArgumentException("Not a recognized date format, root exception: " + pe);
        }
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        this.logger.debug("covertToDbDate output: " + sdf.format(date));
        return date;
    }

    public Object[] getList(String sql, String propertyName) {
        return getList(sql, null, propertyName, 12);
    }

    public Object[] getList(String sql, Object arg, String propertyName) {
        return getList(sql, trapArrayList(arg), propertyName, 12);
    }

    public Object[] getList(String sql, Object arg, String propertyName, int type) {
        return getList(sql, trapArrayList(arg), propertyName, type);
    }

    public Object[] getList(String sql, Object[] args, String propertyName, int type) {
        try {
            PreparedStatement ps = getPreparedStatement(sql, args, type);
            ResultSetDynaClass rsdc = new ResultSetDynaClass(ps.executeQuery());
            ArrayList<Object> results = new ArrayList();
            Iterator<Object> rows = rsdc.iterator();
            while (rows.hasNext()) {
                DynaBean bean = (DynaBean) rows.next();
                results.add(bean.get(propertyName));
            }
            ps.close();
            return results.toArray();
        } catch (Exception ex) {
            this.logger.error(ex.getMessage(), ex);
            throw new RuntimeException("Error while getting list: " + ex.getMessage(), ex);
        }
    }

    public Object getObject(String sql, Object arg) {
        return getObject(sql, trapArrayList(arg));
    }

    public Object getObject(String sql, Object[] args) {
        try {
            PreparedStatement ps = getPreparedStatement(sql, args, 12);
            ResultSetDynaClass rsdc = new ResultSetDynaClass(ps.executeQuery());
            BasicDynaClass bdc = new BasicDynaClass("objectCopy", BasicDynaBean.class, rsdc.getDynaProperties());
            DynaBean newRow = null;
            Iterator<Object> rows = rsdc.iterator();
            if (rows.hasNext()) {
                DynaBean oldRow = (DynaBean) rows.next();
                newRow = bdc.newInstance();
                PropertyUtils.copyProperties(newRow, oldRow);
            }
            ps.close();
            return newRow;
        } catch (Exception ex) {
            this.logger.error(ex.getMessage(), ex);
            throw new RuntimeException("Error in getObject(): " + ex.getMessage(), ex);
        }
    }

    public Iterator<DynaBean> getData(String sql) {
        return getData(sql, null);
    }

    public Iterator<DynaBean> getData(String sql, Object arg) {
        return getData(sql, trapArrayList(arg));
    }

    public Iterator<DynaBean> getData(String sql, Object[] args) {
        return getData(sql, args, 12);
    }

    public Iterator<DynaBean> getData(String sql, Object[] args, int type) {
        try {
            PreparedStatement ps = getPreparedStatement(sql, args, type);
            ResultSetDynaClass rsdc = new ResultSetDynaClass(ps.executeQuery());
            ArrayList<DynaBean> results = new ArrayList();
            BasicDynaClass bdc = new BasicDynaClass("objectCopy", BasicDynaBean.class, rsdc.getDynaProperties());
            Iterator<Object> rows = rsdc.iterator();
            while (rows.hasNext()) {
                DynaBean oldRow = (DynaBean) rows.next();
                DynaBean newRow = bdc.newInstance();
                PropertyUtils.copyProperties(newRow, oldRow);
                results.add(newRow);
            }
            ps.close();
            this.logger.trace("query returned " + results.size() + " results");
            return results.iterator();
        } catch (Exception ex) {
            this.logger.error(ex.getMessage(), ex);
            throw new RuntimeException("Error in getData(): " + ex.getMessage(), ex);
        }
    }

    private PreparedStatement getPreparedStatement(String sql, Object[] args, int type) {
        checkConnection();
        traceArgs(sql, args, null, type);
        try {
            PreparedStatement ps = this.connection.prepareStatement(sql);
            if ((args != null) && (args.length > 0)) {
                for (int i = 1; i <= args.length; i++) {
                    Object argVal = args[(i - 1)];
                    if ((type == -5) || (type == 4)) {
                        this.logger.trace("Converting " + argVal + " to int");
                        ps.setInt(i, ((Integer) ConvertUtils.convert(argVal, Integer.TYPE)).intValue());
                    } else if (type == 93) {
                        this.logger.trace("Converting " + argVal + " to Timestamp");
                        ps.setTimestamp(i, new Timestamp(makeSqlDate(argVal).getTime()));
                    } else if (type == 91) {
                        this.logger.trace("Converting " + argVal + " to Sql Date");
                        ps.setDate(i, makeSqlDate(argVal));
                    } else {
                        ps.setObject(i, argVal);
                    }
                }
            }
            return ps;
        } catch (Exception ex) {
            this.logger.error(ex.getMessage(), ex);
            throw new RuntimeException("Error preparing statement : " + ex.getMessage(), ex);
        }
    }

    private void traceArgs(String sql, Object[] args, String propertyName, int type) {
        if (StringUtils.isNotBlank(sql)) {
            this.logger.trace("sql = " + sql);
        }
        if ((null != args) && (args.length > 0)) {
            this.logger.trace("args.length = " + args.length);
            for (int i = 0; i < args.length; i++) {
                this.logger.trace("args[" + i + "] = " + args[i]);
            }
        }
        if (StringUtils.isNotBlank(propertyName)) {
            this.logger.trace("propertyName = " + propertyName);
        }
        this.logger.trace("type = " + type);
    }

    private void checkConnection() {
        if (null == this.connection) {
            throw new RuntimeException("Connection is null");
        }
        try {
            if (this.connection.isClosed()) {
                throw new RuntimeException("Connection is closed");
            }
        } catch (SQLException e) {
            throw new RuntimeException("Problem checking connection status: " + e);
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
}
