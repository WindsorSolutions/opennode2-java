package com.windsor.node.plugin.rcra58.outbound;

import com.windsor.node.plugin.common.persistence.HibernatePersistenceUnitInfo;
import com.windsor.node.plugin.common.persistence.PluginPersistenceConfig;
import org.apache.commons.lang3.StringUtils;
import org.hibernate.cfg.Environment;
import org.hibernate.jpa.HibernatePersistenceProvider;

import javax.persistence.EntityManagerFactory;
import javax.sql.DataSource;
import java.util.Properties;


public class RcraHibernatePersistenceProvider {

    private final HibernatePersistenceProvider provider = new HibernatePersistenceProvider();

    public EntityManagerFactory createEntityManagerFactory(DataSource dataSource, PluginPersistenceConfig config) {

        Properties jpaProperties = new Properties();

        jpaProperties.put(Environment.DATASOURCE, dataSource);
        //jpaProperties.put(Environment.HBM2DDL_AUTO, "create");

        if (config.isDebugSql()) {
            jpaProperties.put(Environment.SHOW_SQL, Boolean.TRUE);
            jpaProperties.put(Environment.FORMAT_SQL, Boolean.TRUE);
            jpaProperties.put(Environment.USE_SQL_COMMENTS, Boolean.TRUE);
            jpaProperties.put(Environment.USE_NEW_ID_GENERATOR_MAPPINGS, Boolean.FALSE);
        }

        if (config.getBatchFetchSize() != null) {
            jpaProperties.put(Environment.DEFAULT_BATCH_FETCH_SIZE, config.getBatchFetchSize());
        }

        if (config.getBatchSize() != null) {
            jpaProperties.put(Environment.STATEMENT_BATCH_SIZE, config.getBatchSize());
        }

        if (StringUtils.isNotBlank(config.getHibernateDialect())) {
            jpaProperties.put(Environment.DIALECT, config.getHibernateDialect());
        }

        return provider.createContainerEntityManagerFactory(
                new HibernatePersistenceUnitInfo(jpaProperties, config),
                jpaProperties);
    }
}
