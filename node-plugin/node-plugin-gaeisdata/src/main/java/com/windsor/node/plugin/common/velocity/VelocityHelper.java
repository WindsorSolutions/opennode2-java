package com.windsor.node.plugin.common.velocity;

import java.io.Writer;
import java.util.Map;

import javax.sql.DataSource;

public abstract interface VelocityHelper {
    public static final String VELOCITY_HELPER_CTX_KEY = "velocityHelper";
    public static final String DATASOURCE_CTX_KEY = "dataSource";
    public static final String OUTPUT_FILENAME_CTX_KEY = "outputFilename";
    public static final String OUTPUT_FILENAME_PROPS_KEY = "helper.output";
    public static final String TEMPLATE_CTX_KEY = "templateFilename";
    public static final String TEMPLATE_PROPS_KEY = "helper.template";
    public static final String HELPER_ARGS_CTX_KEY = "helperArgs";
    public static final String HELPER_ARGS_PROPS_KEY = "helper.args";
    public static final String HELPER_ARGS_DELIM = "|";
    public static final String HELPER_NAME_VAL_DELIM = "^";

    public abstract void configure(String paramString);

    public abstract void configure(DataSource paramDataSource, String paramString);

    public abstract Map<String, Object> splitTemplateArgs(String paramString);

    public abstract void setTemplateArg(String paramString, Object paramObject);

    public abstract void setTemplateArgs(Map<String, Object> paramMap);

    public abstract int merge(String paramString, Writer paramWriter);

    public abstract int merge(String paramString1, String paramString2);

    public abstract int getResultingRecordCount();

    public abstract void setResultingRecordCount(int paramInt);
}
