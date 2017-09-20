package com.windsor.node.plugin.gaeisdata.dao;

import java.sql.Types;
import java.util.HashMap;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.commons.lang.StringUtils;
import org.springframework.jdbc.core.SqlOutParameter;
import org.springframework.jdbc.core.SqlParameter;
import org.springframework.jdbc.core.support.JdbcDaoSupport;
import org.springframework.jdbc.object.StoredProcedure;

import com.windsor.node.common.exception.WinNodeException;


public class EisDataSourceDao extends JdbcDaoSupport {
    public void executeFacilityDataLoad(Integer year, String id) {
        EisDataLoadStoredProcedure proc = new EisDataLoadStoredProcedure(getDataSource(), "EIS_FI_LOAD_STAGING_P");
        proc.execute(year, id);
    }

    public void executePointDataLoad(Integer year, String id) {
        EisDataLoadStoredProcedure proc = new EisDataLoadStoredProcedure(getDataSource(), "EIS_PSE_LOAD_STAGING_P");
        proc.execute(year, id);
    }

    private class EisDataLoadStoredProcedure extends StoredProcedure {
        public EisDataLoadStoredProcedure(DataSource dataSource, String procName) {
            super(dataSource, procName);
            declareParameter(new SqlParameter("p_inventory_year", Types.INTEGER));
            declareParameter(new SqlParameter("p_facility_id", Types.VARCHAR));
            declareParameter(new SqlOutParameter("p_success_ind", Types.INTEGER));
            compile();
        }

        public void execute(Integer year, String id) {
            Map<String, Object> params = new HashMap();
            params.put("p_inventory_year", year);
            if (StringUtils.isNotBlank(id)) {
                params.put("p_facility_id", id);
            } else {
                params.put("p_facility_id", null);
            }
            Map<String, Object> results = super.execute(params);
            Integer success = (Integer) results.get("p_success_ind");
            if ((success == null) || (success.intValue() != 1)) {
                throw new WinNodeException("Stored procedure " + getSql() + " failed to return a success code: success = " + success);
            }
        }
    }
}
