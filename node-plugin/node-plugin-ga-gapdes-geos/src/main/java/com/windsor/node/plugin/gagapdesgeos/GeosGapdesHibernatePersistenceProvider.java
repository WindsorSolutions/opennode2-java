package com.windsor.node.plugin.gagapdesgeos;

import java.util.Properties;

import javax.persistence.EntityManagerFactory;
import javax.sql.DataSource;

import com.windsor.node.plugin.common.persistence.HibernatePersistenceUnitInfo;
import com.windsor.node.plugin.common.persistence.PluginPersistenceConfig;
import org.apache.commons.lang3.StringUtils;
import org.hibernate.cfg.Environment;
import org.hibernate.jpa.HibernatePersistenceProvider;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * Provides the hibernate persistence provider for the plugin.
 */
public class GeosGapdesHibernatePersistenceProvider {
    protected Logger logger = LoggerFactory.getLogger(getClass());
    private final HibernatePersistenceProvider provider = new HibernatePersistenceProvider();

    public EntityManagerFactory createEntityManagerFactory(DataSource dataSource, PluginPersistenceConfig config) {

        Properties jpaProperties = new Properties();

        jpaProperties.put(Environment.DATASOURCE, dataSource);

        if (config.isDebugSql()) {
            jpaProperties.put(Environment.SHOW_SQL, Boolean.TRUE);
            jpaProperties.put(Environment.FORMAT_SQL, Boolean.TRUE);
            jpaProperties.put(Environment.USE_SQL_COMMENTS, Boolean.TRUE);
            jpaProperties.put(Environment.USE_NEW_ID_GENERATOR_MAPPINGS, Boolean.FALSE);
        }

        if (config.getBatchFetchSize() != null) {
            jpaProperties.put(Environment.DEFAULT_BATCH_FETCH_SIZE, config.getBatchFetchSize());
        }

        if (StringUtils.isNotBlank(config.getHibernateDialect())) {
            jpaProperties.put(Environment.DIALECT, config.getHibernateDialect());
        }

        return provider.createContainerEntityManagerFactory(
                new HibernatePersistenceUnitInfo(jpaProperties, config),
                jpaProperties);
    }
}
