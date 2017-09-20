package com.windsor.node.plugin.common;

import java.io.BufferedOutputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;

import javax.sql.DataSource;

import org.apache.commons.lang.time.StopWatch;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.windsor.node.common.domain.ActivityEntry;
import com.windsor.node.common.domain.ProcessContentResult;

public abstract class BaseDocumentBuilder implements DocumentBuilder {
    protected StopWatch stopWatch;
    protected Logger logger = LoggerFactory.getLogger(getClass());

    protected BaseDocumentBuilder() {
        this.stopWatch = new StopWatch();
    }

    @Override
    public abstract void buildDocument(DataSource paramDataSource, String paramString,
            ProcessContentResult paramProcessContentResult);

    @Override
    public abstract void buildDocument(DataSource paramDataSource, String paramString,
            ProcessContentResult paramProcessContentResult, int paramInt);

    protected void makeEntry(ProcessContentResult result, String message) {
        this.logger.debug(message);
        result.getAuditEntries().add(new ActivityEntry(message));
    }

    protected void makeErrorEntry(ProcessContentResult result, String message) {
        this.logger.error(message);
        result.getAuditEntries().add(new ActivityEntry(message));
    }

    protected OutputStreamWriter getWriter(String targetFilePath)
            throws UnsupportedEncodingException, FileNotFoundException {
        OutputStreamWriter out = new OutputStreamWriter(
                new BufferedOutputStream(new FileOutputStream(targetFilePath), 24576), "UTF-8");
        return out;
    }

    protected StopWatch getStopWatch() {
        return this.stopWatch;
    }

    protected void setStopWatch(StopWatch stopWatch) {
        this.stopWatch = stopWatch;
    }
}
