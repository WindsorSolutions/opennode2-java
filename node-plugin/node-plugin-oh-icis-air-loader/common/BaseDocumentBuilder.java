package com.windsor.node.plugin.common;

import com.windsor.node.common.domain.ActivityEntry;
import com.windsor.node.common.domain.ProcessContentResult;
import com.windsor.node.plugin.common.DocumentBuilder;
import java.io.BufferedOutputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import javax.sql.DataSource;
import org.apache.commons.lang3.time.StopWatch;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public abstract class BaseDocumentBuilder implements DocumentBuilder {
   protected StopWatch stopWatch = new StopWatch();
   protected Logger logger = LoggerFactory.getLogger(this.getClass());

   public abstract void buildDocument(DataSource var1, String var2, ProcessContentResult var3);

   public abstract void buildDocument(DataSource var1, String var2, ProcessContentResult var3, int var4);

   protected void makeEntry(ProcessContentResult result, String message) {
      this.logger.debug(message);
      result.getAuditEntries().add(new ActivityEntry(message));
   }

   protected void makeErrorEntry(ProcessContentResult result, String message) {
      this.logger.error(message);
      result.getAuditEntries().add(new ActivityEntry(message));
   }

   protected OutputStreamWriter getWriter(String targetFilePath) throws UnsupportedEncodingException, FileNotFoundException {
      OutputStreamWriter out = new OutputStreamWriter(new BufferedOutputStream(new FileOutputStream(targetFilePath), 24576), "UTF-8");
      return out;
   }

   protected StopWatch getStopWatch() {
      return this.stopWatch;
   }

   protected void setStopWatch(StopWatch stopWatch) {
      this.stopWatch = stopWatch;
   }
}
