package com.windsor.node.plugin.common.persistence;

public class PluginPersistenceConfig {
   private String rootEntityPackage;
   private ClassLoader classLoader;
   private String hibernateDialect;
   private boolean debugSql;
   private Integer batchFetchSize;

   public PluginPersistenceConfig() {
      this.debugSql = Boolean.FALSE.booleanValue();
   }

   public Integer getBatchFetchSize() {
      return this.batchFetchSize;
   }

   public PluginPersistenceConfig setBatchFetchSize(Integer batchFetchSize) {
      this.batchFetchSize = batchFetchSize;
      return this;
   }

   public boolean isDebugSql() {
      return this.debugSql;
   }

   public String getRootEntityPackage() {
      return this.rootEntityPackage;
   }

   public PluginPersistenceConfig rootEntityPackage(String rootEntityPackage) {
      this.rootEntityPackage = rootEntityPackage;
      return this;
   }

   public PluginPersistenceConfig hibernateDialect(String hibernateDialect) {
      this.hibernateDialect = hibernateDialect;
      return this;
   }

   public PluginPersistenceConfig classLoader(ClassLoader classLoader) {
      this.classLoader = classLoader;
      return this;
   }

   public ClassLoader getClassLoader() {
      return this.classLoader;
   }

   public PluginPersistenceConfig debugSql(boolean debugSql) {
      this.debugSql = debugSql;
      return this;
   }

   public String getHibernateDialect() {
      return this.hibernateDialect;
   }
}
