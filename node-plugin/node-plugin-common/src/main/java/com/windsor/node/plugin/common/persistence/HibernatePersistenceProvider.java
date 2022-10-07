package com.windsor.node.plugin.common.persistence;

import java.util.Properties;

import javax.persistence.EntityManagerFactory;
import javax.persistence.spi.PersistenceProvider;
import javax.sql.DataSource;

import org.apache.commons.lang3.StringUtils;
import org.hibernate.cfg.Environment;

public class HibernatePersistenceProvider {

    private final PersistenceProvider provider = new org.hibernate.jpa.HibernatePersistenceProvider();

    public EntityManagerFactory createEntityManagerFactory(DataSource dataSource, PluginPersistenceConfig config) {

        Properties jpaProperties = new Properties();

        jpaProperties.put(Environment.DATASOURCE, dataSource);

        if (config.isDebugSql()) {
            jpaProperties.put(Environment.SHOW_SQL, Boolean.TRUE);
            jpaProperties.put(Environment.FORMAT_SQL, Boolean.TRUE);
        }

        if (config.getBatchFetchSize() != null) {
            jpaProperties.put(Environment.DEFAULT_BATCH_FETCH_SIZE, config.getBatchFetchSize());
        }

        if (StringUtils.isNotBlank(config.getHibernateDialect())) {
            jpaProperties.put(Environment.DIALECT, config.getHibernateDialect());
        }

        return provider.createContainerEntityManagerFactory(
                new Hibernate5PersistenceUnitInfo(jpaProperties, config),
                jpaProperties);
    }
}
