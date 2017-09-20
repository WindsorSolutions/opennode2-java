package com.windsor.node.plugin.common.velocity;

import java.io.File;

import javax.naming.ConfigurationException;
import javax.sql.DataSource;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;


public class ConsoleVelocityHelper implements InitializingBean {
    protected static Logger logger = LoggerFactory.getLogger(ConsoleVelocityHelper.class.getClass());
    private VelocityHelper velocityHelper;
    private DataSource dataSource;
    private String helperArgs;
    private String outputFile;
    private String templatePath;

    @Override
    public void afterPropertiesSet() throws Exception {
        if (this.velocityHelper == null) {
            throw new ConfigurationException("null velocityHelper");
        }
        if (this.dataSource == null) {
            throw new ConfigurationException("null dataSource");
        }
        if (this.outputFile == null) {
            throw new ConfigurationException("null outputFile");
        }
        if (StringUtils.isBlank(this.templatePath)) {
            throw new ConfigurationException("null templatePath");
        }
        File templateFile = new File(this.templatePath);
        if (!templateFile.exists()) {
            throw new ConfigurationException("templatePath does not exist:" + templateFile);
        }
        if (StringUtils.isBlank(this.helperArgs)) {
            throw new ConfigurationException("null helperArgs");
        }
    }

    public void run() {
        try {
            logger.info("Configuring...");
            this.velocityHelper.configure(this.dataSource, FilenameUtils.getFullPath(this.templatePath));
            this.velocityHelper.setTemplateArgs(this.velocityHelper.splitTemplateArgs(this.helperArgs));
            logger.info("Template: " + FilenameUtils.getName(this.templatePath));
            logger.info("Output: " + this.outputFile);
            int recordCount = this.velocityHelper.merge(this.templatePath, this.outputFile);
            logger.info("Merged records: " + recordCount);
        } catch (Exception ex) {
            logger.error(ex.getMessage(), ex);
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
            ApplicationContext context = new ClassPathXmlApplicationContext(args);
            if (!context.containsBean("console")) {
                throw new ConfigurationException("null console");
            }
            ConsoleVelocityHelper helper = (ConsoleVelocityHelper) context.getBean("console");
            helper.run();
        } catch (Exception ex) {
            logger.error(ex.getMessage(), ex);
        } finally {
            logger.debug("Done");
        }
    }

    public void setHelperArgs(String helperArgs) {
        this.helperArgs = helperArgs;
    }
}
