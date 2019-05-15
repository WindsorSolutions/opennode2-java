package com.windsor.node.plugin.common.velocity;

import java.io.Writer;
import java.util.Map;
import javax.sql.DataSource;

public interface VelocityHelper {
   String VELOCITY_HELPER_CTX_KEY = "velocityHelper";
   String DATASOURCE_CTX_KEY = "dataSource";
   String OUTPUT_FILENAME_CTX_KEY = "outputFilename";
   String OUTPUT_FILENAME_PROPS_KEY = "helper.output";
   String TEMPLATE_CTX_KEY = "templateFilename";
   String TEMPLATE_PROPS_KEY = "helper.template";
   String HELPER_ARGS_CTX_KEY = "helperArgs";
   String HELPER_ARGS_PROPS_KEY = "helper.args";
   String HELPER_ARGS_DELIM = "|";
   String HELPER_NAME_VAL_DELIM = "^";

   void configure(String var1);

   void configure(DataSource var1, String var2);

   Map splitTemplateArgs(String var1);

   void setTemplateArg(String var1, Object var2);

   void setTemplateArgs(Map var1);

   int merge(String var1, Writer var2);

   int merge(String var1, String var2);

   int merge(String var1, String var2, boolean var3);

   int getResultingRecordCount();

   void setResultingRecordCount(int var1);
}
