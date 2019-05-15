package com.windsor.node.plugin.common.velocity;

import com.windsor.node.plugin.common.velocity.VelocityHelper;
import java.io.File;
import javax.naming.ConfigurationException;
import javax.sql.DataSource;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class ConsoleVelocityHelper implements InitializingBean {
   protected static Logger logger = LoggerFactory.getLogger(ConsoleVelocityHelper.class.getClass());
   private VelocityHelper velocityHelper;
   private DataSource dataSource;
   private String helperArgs;
   private String outputFile;
   private String templatePath;

   public void afterPropertiesSet() throws Exception {
      if(this.velocityHelper == null) {
         throw new ConfigurationException("null velocityHelper");
      } else if(this.dataSource == null) {
         throw new ConfigurationException("null dataSource");
      } else if(this.outputFile == null) {
         throw new ConfigurationException("null outputFile");
      } else if(StringUtils.isBlank(this.templatePath)) {
         throw new ConfigurationException("null templatePath");
      } else {
         File templateFile = new File(this.templatePath);
         if(!templateFile.exists()) {
            throw new ConfigurationException("templatePath does not exist:" + templateFile);
         } else if(StringUtils.isBlank(this.helperArgs)) {
            throw new ConfigurationException("null helperArgs");
         }
      }
   }

   public void run() {
      try {
         logger.info("Configuring...");
         this.velocityHelper.configure(this.dataSource, FilenameUtils.getFullPath(this.templatePath));
         this.velocityHelper.setTemplateArgs(this.velocityHelper.splitTemplateArgs(this.helperArgs));
         logger.info("Template: " + FilenameUtils.getName(this.templatePath));
         logger.info("Output: " + this.outputFile);
         int ex = this.velocityHelper.merge(this.templatePath, this.outputFile);
         logger.info("Merged records: " + ex);
      } catch (Exception var2) {
         logger.error(var2.getMessage(), var2);
      }

   }

   public void setVelocityHelper(VelocityHelper velocityHelper) {
      this.velocityHelper = velocityHelper;
   }

   public void setDataSource(DataSource dataSource) {
      this.dataSource = dataSource;
   }

   public void setConsoleArgs(String consoleArgs) {
      this.helperArgs = consoleArgs;
   }

   public void setOutputFile(String outputFile) {
      this.outputFile = outputFile;
   }

   public void setTemplatePath(String templatePath) {
      this.templatePath = templatePath;
   }

   public static void main(String[] args) {
      try {
         logger.debug("Initializing application context...");
         ClassPathXmlApplicationContext ex = new ClassPathXmlApplicationContext(args);
         if(!ex.containsBean("console")) {
            throw new ConfigurationException("null console");
         }

         ConsoleVelocityHelper helper = (ConsoleVelocityHelper)ex.getBean("console");
         helper.run();
      } catch (Exception var6) {
         logger.error(var6.getMessage(), var6);
      } finally {
         logger.debug("Done");
      }

   }

   public void setHelperArgs(String helperArgs) {
      this.helperArgs = helperArgs;
   }
}
