package com.windsor.node.plugin.common.persistence;

import com.windsor.node.plugin.common.persistence.PluginPersistenceConfig;
import java.io.File;
import java.io.IOException;
import java.lang.annotation.Annotation;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;
import java.util.TreeSet;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import javax.persistence.Embeddable;
import javax.persistence.Entity;
import javax.persistence.MappedSuperclass;
import javax.persistence.SharedCacheMode;
import javax.persistence.ValidationMode;
import javax.persistence.spi.ClassTransformer;
import javax.persistence.spi.PersistenceUnitInfo;
import javax.persistence.spi.PersistenceUnitTransactionType;
import javax.sql.DataSource;

public class HibernatePersistenceUnitInfo implements PersistenceUnitInfo {
   private final Properties jpaProperties;
   private final String entityPackageName;
   private final ClassLoader classLoader;

   public HibernatePersistenceUnitInfo(Properties jpaProperties, PluginPersistenceConfig config) {
      this.jpaProperties = jpaProperties;
      this.entityPackageName = config.getRootEntityPackage();
      this.classLoader = config.getClassLoader();
   }

   public ValidationMode getValidationMode() {
      return ValidationMode.NONE;
   }

   public PersistenceUnitTransactionType getTransactionType() {
      return PersistenceUnitTransactionType.RESOURCE_LOCAL;
   }

   public SharedCacheMode getSharedCacheMode() {
      return SharedCacheMode.ENABLE_SELECTIVE;
   }

   public Properties getProperties() {
      return this.jpaProperties;
   }

   public String getPersistenceXMLSchemaVersion() {
      return null;
   }

   public URL getPersistenceUnitRootUrl() {
      return null;
   }

   public String getPersistenceUnitName() {
      return null;
   }

   public String getPersistenceProviderClassName() {
      return "org.hibernate.ejb.HibernatePersistence";
   }

   public DataSource getNonJtaDataSource() {
      return null;
   }

   public ClassLoader getNewTempClassLoader() {
      return null;
   }

   public List<String> getMappingFileNames() {
      return null;
   }

   public List<String> getManagedClassNames() {
      try {
         ArrayList e = new ArrayList();
         Iterator i$ = this.listEntitiesInPackage(this.entityPackageName).iterator();

         while(i$.hasNext()) {
            Class k = (Class)i$.next();
            e.add(k.getCanonicalName());
         }

         return e;
      } catch (Exception var4) {
         throw new RuntimeException("Unable to build list of Entity classes.", var4);
      }
   }

   private List<Class<?>> listEntitiesInPackage(String packageName) throws ClassNotFoundException, IOException {
      ClassLoader classLoader = this.classLoader;
      if(classLoader == null) {
         classLoader = Thread.currentThread().getContextClassLoader();
      }

      assert classLoader != null;

      String path = packageName.replace('.', '/');
      Enumeration resources = classLoader.getResources(path);
      ArrayList dirs = new ArrayList();

      while(resources.hasMoreElements()) {
         URL classes = (URL)resources.nextElement();
         dirs.add(URLDecoder.decode(classes.getFile(), "UTF-8"));
      }

      TreeSet var15 = new TreeSet();
      Iterator classList = dirs.iterator();

      while(classList.hasNext()) {
         String i$ = (String)classList.next();
         var15.addAll(this.findClasses(i$, packageName));
      }

      ArrayList var16 = new ArrayList();
      Iterator var17 = var15.iterator();

      while(var17.hasNext()) {
         String clazz = (String)var17.next();
         Class k = Class.forName(clazz);
         Annotation[] arr$ = k.getAnnotations();
         int len$ = arr$.length;

         for(int i$1 = 0; i$1 < len$; ++i$1) {
            Annotation a = arr$[i$1];
            if(a.annotationType().equals(Entity.class) || a.annotationType().equals(Embeddable.class) || a.annotationType().equals(MappedSuperclass.class)) {
               var16.add(k);
            }
         }
      }

      return var16;
   }

   private TreeSet<String> findClasses(String path, String packageName) throws MalformedURLException, IOException {
      TreeSet classes = new TreeSet();
      if(path.startsWith("file:") && path.contains("!")) {
         String[] dir = path.split("!");
         URL files = new URL(dir[0]);
         ZipInputStream arr$ = new ZipInputStream(files.openStream());

         ZipEntry len$;
         while((len$ = arr$.getNextEntry()) != null) {
            if(len$.getName().endsWith(".class")) {
               String i$ = len$.getName().replaceAll("[$].*", "").replaceAll("[.]class", "").replace('/', '.');
               if(i$.startsWith(packageName)) {
                  classes.add(i$);
               }
            }
         }
      }

      File var11 = new File(path);
      if(!var11.exists()) {
         return classes;
      } else {
         File[] var12 = var11.listFiles();
         File[] var13 = var12;
         int var14 = var12.length;

         for(int var15 = 0; var15 < var14; ++var15) {
            File file = var13[var15];
            if(file.isDirectory()) {
               assert !file.getName().contains(".");

               classes.addAll(this.findClasses(file.getAbsolutePath(), packageName + "." + file.getName()));
            } else if(file.getName().endsWith(".class")) {
               String className = packageName + '.' + file.getName().substring(0, file.getName().length() - 6);
               classes.add(className);
            }
         }

         return classes;
      }
   }

   public DataSource getJtaDataSource() {
      return null;
   }

   public List<URL> getJarFileUrls() {
      ArrayList jars = new ArrayList();
      return jars;
   }

   public ClassLoader getClassLoader() {
      return this.getClass().getClassLoader();
   }

   public boolean excludeUnlistedClasses() {
      return false;
   }

   public void addTransformer(ClassTransformer transformer) {
   }
}
