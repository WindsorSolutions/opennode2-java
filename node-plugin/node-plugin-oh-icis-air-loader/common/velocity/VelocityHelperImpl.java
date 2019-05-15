package com.windsor.node.plugin.common.velocity;

import com.windsor.node.plugin.common.velocity.TemplateHelper;
import com.windsor.node.plugin.common.velocity.VelocityHelper;
import java.io.BufferedOutputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.io.Writer;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Properties;
import java.util.Map.Entry;
import javax.sql.DataSource;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.velocity.Template;
import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.VelocityEngine;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class VelocityHelperImpl implements VelocityHelper {
   public static final String TEXT_ENCODING = "UTF-8";
   public static final int BUFFER_SIZE = 24576;
   protected Logger logger = LoggerFactory.getLogger(this.getClass());
   protected VelocityContext context;
   protected VelocityEngine velocityEngine;
   protected TemplateHelper templateHelper;
   private int resultingRecordCount;

   public void configure(DataSource dataSource, String templateDirectory) {
      this.configure(templateDirectory);
   }

   public void configure(String templateDirectory) {
      this.logger.info("Template directory: " + templateDirectory);
      Properties props = new Properties();
      props.setProperty("resource.loader", "file");
      props.setProperty("file.resource.loader.description", "Velocity File Resource Loader");
      props.setProperty("file.resource.loader.class", "org.apache.velocity.runtime.resource.loader.FileResourceLoader");
      props.setProperty("file.resource.loader.path", templateDirectory);
      props.setProperty("file.resource.loader.cache", "false");
      props.setProperty("file.resource.loader.modificationCheckInterval", "0");
      props.setProperty("input.encoding", "UTF-8");
      props.setProperty("output.encoding", "UTF-8");
      props.setProperty("runtime.log.logsystem.class", "org.apache.velocity.runtime.log.Log4JLogChute");
      props.setProperty("runtime.log.logsystem.log4j.logger", "org.apache.velocity");
      props.setProperty("eventhandler.referenceinsertion.class", "org.apache.velocity.app.event.implement.EscapeXmlReference");
      props.setProperty("eventhandler.escape.html.match", "/.*/");
      props.setProperty("directive.foreach.counter.name", "velocityCount");
      props.setProperty("directive.foreach.counter.initial.value", "1");

      try {
         this.velocityEngine = new VelocityEngine(props);
      } catch (Exception var4) {
         throw new RuntimeException("Error while creating VelocityEngine:" + var4.getMessage(), var4);
      }

      this.templateHelper = new TemplateHelper();
      this.context = new VelocityContext();
   }

   public void setTemplateArg(String key, Object arg) {
      this.context.put(key, arg);
   }

   public void setTemplateArgs(Map args) {
      Iterator it = args.entrySet().iterator();

      while(it.hasNext()) {
         Entry pairs = (Entry)it.next();
         this.context.put(((String)pairs.getKey()).toString(), pairs.getValue());
      }

   }

   public Map splitTemplateArgs(String helperArgs) {
      HashMap map = new HashMap();
      String[] argPairs = StringUtils.split(helperArgs, "|");

      for(int i = 0; i < argPairs.length; ++i) {
         this.logger.info(argPairs[i]);
         String[] argPair = StringUtils.split(argPairs[i], "^");
         if(argPair.length != 2) {
            throw new IllegalArgumentException("Invalid argument, expected key value pair delimited by \'^\' char");
         }

         map.put(argPair[0].trim(), argPair[1].trim());
      }

      return map;
   }

   public int merge(String template, String targetFilePath) {
      return this.merge(template, targetFilePath, false);
   }

   public int merge(String template, String targetFilePath, boolean append) {
      OutputStreamWriter out = null;

      int e;
      try {
         out = new OutputStreamWriter(new BufferedOutputStream(new FileOutputStream(targetFilePath, append), 24576), "UTF-8");
         e = this.merge(template, (Writer)out);
      } catch (FileNotFoundException var15) {
         throw new RuntimeException("Error while merging: file not found." + var15.getMessage(), var15);
      } catch (UnsupportedEncodingException var16) {
         throw new RuntimeException("Error while merging: unsupported encoding" + var16.getMessage(), var16);
      } finally {
         if(out != null) {
            try {
               out.flush();
               out.close();
            } catch (IOException var14) {
               this.logger.error(var14.getMessage(), var14);
            }
         }

      }

      return e;
   }

   public int merge(String template, Writer writer) {
      if(this.velocityEngine != null && this.templateHelper != null) {
         try {
            Template e = this.velocityEngine.getTemplate(FilenameUtils.getName(template));
            this.logger.info("Template: " + e.getName());
            this.logger.debug("Merging template...");
            e.merge(this.context, writer);
         } catch (Exception var4) {
            this.logger.error("Exception: " + var4.getMessage(), var4);
            throw new RuntimeException("Template error: " + var4.getMessage(), var4);
         }

         return this.getResultingRecordCount();
      } else {
         throw new RuntimeException("Engine not configured. Call configure(String templateDirectory) first!");
      }
   }

   public int getResultingRecordCount() {
      return this.resultingRecordCount;
   }

   public void setResultingRecordCount(int resultingRecordCount) {
      this.resultingRecordCount = resultingRecordCount;
   }
}
