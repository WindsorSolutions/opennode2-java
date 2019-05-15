package com.windsor.node.plugin.common.staging;

import com.windsor.node.plugin.common.dao.TextLoader;
import com.windsor.node.plugin.common.staging.XmlStaging;
import java.util.List;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public abstract class BaseXmlStaging implements XmlStaging {
   protected Logger logger = LoggerFactory.getLogger(this.getClass());
   protected TextLoader loader;
   protected StringBuffer xmlBuffer = null;

   public void execute(StringBuffer xml, boolean isFinal) {
      this.logger.trace("execute xml: " + xml);
      if(null == this.loader) {
         throw new RuntimeException("TextLoader not set");
      } else {
         if(this.xmlBuffer == null) {
            this.logger.debug("Starting new document buffer");
            this.xmlBuffer = new StringBuffer();
            this.logger.debug("Buffering " + this.getDocumentOpen());
            this.xmlBuffer.append(this.getDocumentOpen());
         }

         if(null != xml) {
            this.logger.debug("Appending to document buffer");
            this.xmlBuffer.append(xml);
         }

         if(isFinal) {
            this.logger.debug("Buffering " + this.getDocumentClose());
            this.xmlBuffer.append(this.getDocumentClose());
            this.logger.debug("Closing document buffer");

            try {
               this.loader.loadText(this.xmlBuffer.toString());
            } catch (Exception var7) {
               throw new RuntimeException(var7.getMessage(), var7);
            } finally {
               this.xmlBuffer = null;
            }
         }

      }
   }

   public String getStartTag(String tagname) {
      return "<" + tagname + ">";
   }

   public String getEndTag(String tagname) {
      return "</" + tagname + ">";
   }

   public TextLoader getTextLoader() {
      return this.loader;
   }

   public void setTextLoader(TextLoader loader) {
      this.loader = loader;
   }

   public abstract String getDocumentClose();

   public abstract String getDocumentOpen();

   public abstract Map getListElementMap();

   public abstract List getListNames();

   public abstract void setBatchSize(int var1);

   public abstract int getBatchSize();
}
