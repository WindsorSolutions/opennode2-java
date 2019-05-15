package com.windsor.node.plugin.common.persistence;

import com.windsor.node.plugin.common.persistence.HibernatePersistenceUnitInfo;
import com.windsor.node.plugin.common.persistence.PluginPersistenceConfig;
import java.util.Properties;
import javax.persistence.EntityManagerFactory;
import javax.persistence.spi.PersistenceProvider;
import javax.sql.DataSource;
import org.apache.commons.lang3.StringUtils;
import org.hibernate.ejb.HibernatePersistence;

public class HibernatePersistenceProvider {
   private final PersistenceProvider provider = new HibernatePersistence();

   public EntityManagerFactory createEntityManagerFactory(DataSource dataSource, PluginPersistenceConfig config) {
      Properties jpaProperties = new Properties();
      jpaProperties.put("hibernate.connection.datasource", dataSource);
      if(config.isDebugSql()) {
         jpaProperties.put("hibernate.show_sql", Boolean.TRUE);
         jpaProperties.put("hibernate.format_sql", Boolean.TRUE);
      }

      if(config.getBatchFetchSize() != null) {
         jpaProperties.put("hibernate.default_batch_fetch_size", config.getBatchFetchSize());
      }

      if(StringUtils.isNotBlank(config.getHibernateDialect())) {
         jpaProperties.put("hibernate.dialect", config.getHibernateDialect());
      }

      return this.provider.createContainerEntityManagerFactory(new HibernatePersistenceUnitInfo(jpaProperties, config), jpaProperties);
   }
}
