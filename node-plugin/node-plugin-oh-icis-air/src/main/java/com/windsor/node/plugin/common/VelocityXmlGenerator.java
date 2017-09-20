package com.windsor.node.plugin.common;

import java.io.StringWriter;
import java.util.List;
import java.util.Properties;
import org.apache.velocity.Template;
import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.VelocityEngine;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public abstract class VelocityXmlGenerator {
   public static final String XML_DECLARATION = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
   public static final String LINE_SEP = System.getProperty("line.separator");
   public static final String FILE_SEP = System.getProperty("line.separator");
   public static final String TAB = "    ";
   protected Logger logger = LoggerFactory.getLogger(this.getClass());
   protected VelocityEngine ve;

   public VelocityXmlGenerator(String templatePath) {
      this.logger.debug("creating VelocityXmlGenerator, loading templates from the filesystem location: " + templatePath);
      Properties props = new Properties();
      props.setProperty("resource.loader", "file");
      props.setProperty("file.resource.loader.path", templatePath);
      props.setProperty("file.resource.loader.cache", "true");
      props.setProperty("file.resource.loader.class", "org.apache.velocity.runtime.resource.loader.FileResourceLoader");
      props.setProperty("runtime.log.logsystem.class", "org.apache.velocity.runtime.log.Log4JLogChute");
      props.setProperty("runtime.log.logsystem.log4j.logger", "org.apache.velocity");

      try {
         this.ve = new VelocityEngine(props);
      } catch (Exception var4) {
         throw new RuntimeException("Problem initializing VelocityEngine", var4);
      }
   }

   protected StringWriter genList(String contextKey, String templateName, List templateData) {
      VelocityContext context = new VelocityContext();
      context.put(contextKey, templateData.toArray());
      return this.merge(templateName, context);
   }

   protected StringWriter genItem(String contextKey, String templateName, Object templateData) {
      VelocityContext context = new VelocityContext();
      context.put(contextKey, templateData);
      return this.merge(templateName, context);
   }

   private StringWriter merge(String templateName, VelocityContext context) {
      Template t = this.getTemplate(templateName);
      StringWriter sw = new StringWriter();

      try {
         t.merge(context, sw);
      } catch (Exception var6) {
         this.logger.error("Problem merging template " + templateName + ": " + var6.getMessage());
         throw new RuntimeException("Problem merging template " + templateName, var6);
      }

      this.logger.trace("Output from merging " + templateName + ":\n" + sw.toString());
      return sw;
   }

   protected Template getTemplate(String templateName) {
      Template t = null;

      try {
         t = this.ve.getTemplate(templateName);
         return t;
      } catch (Exception var5) {
         String msg = "Problem getting Template named " + templateName + ": " + var5.getMessage();
         this.logger.error(msg);
         throw new RuntimeException(msg, var5);
      }
   }
}
