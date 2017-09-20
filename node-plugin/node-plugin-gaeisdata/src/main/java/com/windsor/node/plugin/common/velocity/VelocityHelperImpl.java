package com.windsor.node.plugin.common.velocity;

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

import javax.sql.DataSource;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.velocity.Template;
import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.VelocityEngine;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


public class VelocityHelperImpl implements VelocityHelper {
    public static final String TEXT_ENCODING = "UTF-8";
    public static final int BUFFER_SIZE = 24576;
    protected Logger logger = LoggerFactory.getLogger(getClass());
    protected VelocityContext context;
    protected VelocityEngine velocityEngine;
    protected TemplateHelper templateHelper;
    private int resultingRecordCount;

    @Override
    public void configure(DataSource dataSource, String templateDirectory) {
        configure(templateDirectory);
    }

    @Override
    public void configure(String templateDirectory) {
        this.logger.info("Template directory: " + templateDirectory);
        Properties props = new Properties();
        props.setProperty("resource.loader", "file");
        props.setProperty("file.resource.loader.description", "Velocity File Resource Loader");
        props.setProperty("file.resource.loader.class",
                "org.apache.velocity.runtime.resource.loader.FileResourceLoader");
        props.setProperty("file.resource.loader.path", templateDirectory);
        props.setProperty("file.resource.loader.cache", "false");
        props.setProperty("file.resource.loader.modificationCheckInterval", "0");
        props.setProperty("input.encoding", "UTF-8");
        props.setProperty("output.encoding", "UTF-8");
        props.setProperty("runtime.log.logsystem.class", "org.apache.velocity.runtime.log.Log4JLogChute");
        props.setProperty("runtime.log.logsystem.log4j.logger", "org.apache.velocity");
        props.setProperty("eventhandler.referenceinsertion.class",
                "org.apache.velocity.app.event.implement.EscapeXmlReference");
        props.setProperty("eventhandler.escape.html.match", "/.*/");
        props.setProperty("directive.foreach.counter.name", "velocityCount");
        props.setProperty("directive.foreach.counter.initial.value", "1");
        try {
            this.velocityEngine = new VelocityEngine(props);
        } catch (Exception e) {
            throw new RuntimeException("Error while creating VelocityEngine:" + e.getMessage(), e);
        }
        this.templateHelper = new TemplateHelper();
        this.context = new VelocityContext();
    }

    @Override
    public void setTemplateArg(String key, Object arg) {
        this.context.put(key, arg);
    }

    @Override
    public void setTemplateArgs(Map<String, Object> args) {
        Iterator<Map.Entry<String, Object>> it = args.entrySet().iterator();
        while (it.hasNext()) {
            Map.Entry<String, Object> pairs = it.next();
            this.context.put(pairs.getKey().toString(), pairs.getValue());
        }
    }

    @Override
    public Map<String, Object> splitTemplateArgs(String helperArgs) {
        Map<String, Object> map = new HashMap();
        String[] argPairs = StringUtils.split(helperArgs, "|");
        for (int i = 0; i < argPairs.length; i++) {
            this.logger.info(argPairs[i]);
            String[] argPair = StringUtils.split(argPairs[i], "^");
            if (argPair.length != 2) {
                throw new IllegalArgumentException("Invalid argument, expected key value pair delimited by '^' char");
            }
            map.put(argPair[0].trim(), argPair[1].trim());
        }
        return map;
    }

    @Override
    public int merge(String template, String targetFilePath) {
        OutputStreamWriter out = null;
        try {
            out = new OutputStreamWriter(new BufferedOutputStream(new FileOutputStream(targetFilePath), 24576),
                    "UTF-8");
            return merge(template, out);
        } catch (FileNotFoundException ex) {
            throw new RuntimeException("Error while merging: file not found." + ex.getMessage(), ex);
        } catch (UnsupportedEncodingException e) {
            throw new RuntimeException("Error while merging: unsupported encoding" + e.getMessage(), e);
        } finally {
            if (out != null) {
                try {
                    out.flush();
                    out.close();
                } catch (IOException e) {
                    this.logger.error(e.getMessage(), e);
                }
            }
        }
    }

    @Override
    public int merge(String template, Writer writer) {
        if ((this.velocityEngine == null) || (this.templateHelper == null)) {
            throw new RuntimeException("Engine not configured. Call configure(String templateDirectory) first!");
        }
        try {
            Template tmpl = this.velocityEngine.getTemplate(FilenameUtils.getName(template));
            this.logger.info("Template: " + tmpl.getName());
            this.logger.debug("Merging template...");
            tmpl.merge(this.context, writer);
        } catch (Exception e) {
            this.logger.error("Exception: " + e.getMessage(), e);
            throw new RuntimeException("Template error: " + e.getMessage(), e);
        }
        return getResultingRecordCount();
    }

    @Override
    public int getResultingRecordCount() {
        return this.resultingRecordCount;
    }

    @Override
    public void setResultingRecordCount(int resultingRecordCount) {
        this.resultingRecordCount = resultingRecordCount;
    }
}
