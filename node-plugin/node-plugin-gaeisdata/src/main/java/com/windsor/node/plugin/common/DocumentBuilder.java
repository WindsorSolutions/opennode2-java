package com.windsor.node.plugin.common;

import javax.sql.DataSource;

import com.windsor.node.common.domain.ProcessContentResult;

public abstract interface DocumentBuilder {
    public abstract void buildDocument(DataSource paramDataSource, String paramString,
            ProcessContentResult paramProcessContentResult);

    public abstract void buildDocument(DataSource paramDataSource, String paramString,
            ProcessContentResult paramProcessContentResult, int paramInt);
}
