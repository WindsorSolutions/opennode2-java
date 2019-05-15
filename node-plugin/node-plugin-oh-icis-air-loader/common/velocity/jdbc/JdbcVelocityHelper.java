package com.windsor.node.plugin.common.velocity.jdbc;

import com.windsor.node.plugin.common.velocity.VelocityHelperImpl;
import com.windsor.node.plugin.common.velocity.jdbc.JdbcTemplateHelper;
import java.io.Writer;
import javax.sql.DataSource;
import org.apache.commons.io.FilenameUtils;
import org.apache.velocity.Template;

public class JdbcVelocityHelper extends VelocityHelperImpl {
   public void configure(DataSource dataSource, String templateDirectory) {
      this.configure(templateDirectory);
      if(dataSource == null) {
         throw new NullPointerException("Null dataSource");
      } else {
         this.templateHelper = new JdbcTemplateHelper(dataSource);
         this.context.put("helper", this.templateHelper);
      }
   }

   public int merge(String template, String targetFilePath) {
      return super.merge(template, targetFilePath);
   }

   public int merge(String template, Writer writer) {
      if(this.velocityEngine != null && this.templateHelper != null) {
         try {
            Template e = this.velocityEngine.getTemplate(FilenameUtils.getName(template));
            this.logger.info("Template: " + e.getName());
            this.logger.debug("Merging template...");
            e.merge(this.context, writer);
            return ((JdbcTemplateHelper)this.templateHelper).getResultingRecordCount();
         } catch (Exception var4) {
            this.logger.error("Exception: " + var4.getMessage(), var4);
            throw new RuntimeException("Template error: " + var4.getMessage(), var4);
         }
      } else {
         throw new RuntimeException("Helper not configured. configure(DataSource dataSource, String templateDirectory) first!");
      }
   }
}
