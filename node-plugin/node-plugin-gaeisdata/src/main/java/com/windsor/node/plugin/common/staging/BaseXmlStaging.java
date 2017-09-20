package com.windsor.node.plugin.common.staging;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.windsor.node.plugin.common.dao.TextLoader;


public abstract class BaseXmlStaging implements XmlStaging {
    protected Logger logger = LoggerFactory.getLogger(getClass());
    protected TextLoader loader;
    protected StringBuffer xmlBuffer = null;

    @Override
    public void execute(StringBuffer xml, boolean isFinal) {
        this.logger.trace("execute xml: " + xml);
        if (null == this.loader) {
            throw new RuntimeException("TextLoader not set");
        }
        if (this.xmlBuffer == null) {
            this.logger.debug("Starting new document buffer");
            this.xmlBuffer = new StringBuffer();
            this.logger.debug("Buffering " + getDocumentOpen());
            this.xmlBuffer.append(getDocumentOpen());
        }
        if (null != xml) {
            this.logger.debug("Appending to document buffer");
            this.xmlBuffer.append(xml);
        }
        if (isFinal) {
            this.logger.debug("Buffering " + getDocumentClose());
            this.xmlBuffer.append(getDocumentClose());
            this.logger.debug("Closing document buffer");
            try {
                this.loader.loadText(this.xmlBuffer.toString());
            } catch (Exception e) {
                throw new RuntimeException(e.getMessage(), e);
            } finally {
                this.xmlBuffer = null;
            }
        }
    }

    @Override
    public String getStartTag(String tagname) {
        return "<" + tagname + ">";
    }

    @Override
    public String getEndTag(String tagname) {
        return "</" + tagname + ">";
    }

    @Override
    public TextLoader getTextLoader() {
        return this.loader;
    }

    @Override
    public void setTextLoader(TextLoader loader) {
        this.loader = loader;
    }

    @Override
    public abstract String getDocumentClose();

    @Override
    public abstract String getDocumentOpen();

    @Override
    public abstract Map getListElementMap();

    @Override
    public abstract List getListNames();

    @Override
    public abstract void setBatchSize(int paramInt);

    @Override
    public abstract int getBatchSize();
}
