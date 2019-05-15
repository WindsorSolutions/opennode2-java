package com.windsor.node.plugin.common;

import com.windsor.node.common.domain.ProcessContentResult;
import javax.sql.DataSource;

public interface DocumentBuilder {
   void buildDocument(DataSource var1, String var2, ProcessContentResult var3);

   void buildDocument(DataSource var1, String var2, ProcessContentResult var3, int var4);
}
