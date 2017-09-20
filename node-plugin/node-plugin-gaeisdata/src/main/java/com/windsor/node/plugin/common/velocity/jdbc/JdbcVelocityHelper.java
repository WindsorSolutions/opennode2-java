package com.windsor.node.plugin.common.velocity.jdbc;

import java.io.Writer;

import javax.sql.DataSource;

import org.apache.commons.io.FilenameUtils;
import org.apache.velocity.Template;

import com.windsor.node.plugin.common.velocity.VelocityHelperImpl;

public class JdbcVelocityHelper extends VelocityHelperImpl {
    @Override
    public void configure(DataSource dataSource, String templateDirectory) {
        configure(templateDirectory);
        if (dataSource == null) {
            throw new NullPointerException("Null dataSource");
        }
        this.templateHelper = new JdbcTemplateHelper(dataSource);
        this.context.put("helper", this.templateHelper);
    }

    @Override
    public int merge(String template, String targetFilePath) {
        return super.merge(template, targetFilePath);
    }

    @Override
    public int merge(String template, Writer writer) {
        if ((this.velocityEngine == null) || (this.templateHelper == null)) {
            throw new RuntimeException(
                    "Helper not configured. configure(DataSource dataSource, String templateDirectory) first!");
        }
        try {
            Template tmpl = this.velocityEngine.getTemplate(FilenameUtils.getName(template));
            this.logger.info("Template: " + tmpl.getName());
            this.logger.debug("Merging template...");
            tmpl.merge(this.context, writer);
            return ((JdbcTemplateHelper) this.templateHelper).getResultingRecordCount();
        } catch (Exception e) {
            this.logger.error("Exception: " + e.getMessage(), e);
            throw new RuntimeException("Template error: " + e.getMessage(), e);
        }
    }
}
