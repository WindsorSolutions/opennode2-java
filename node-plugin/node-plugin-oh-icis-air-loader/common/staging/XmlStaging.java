package com.windsor.node.plugin.common.staging;

import com.windsor.node.plugin.common.dao.TextLoader;
import java.util.List;
import java.util.Map;

public interface XmlStaging {
   void execute(StringBuffer var1, boolean var2);

   int getBatchSize();

   void setBatchSize(int var1);

   List getListNames();

   Map getListElementMap();

   String getDocumentOpen();

   String getDocumentClose();

   String getStartTag(String var1);

   String getEndTag(String var1);

   void setTextLoader(TextLoader var1);

   TextLoader getTextLoader();
}
