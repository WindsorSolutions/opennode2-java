package com.windsor.node.plugin.common;

import java.text.DecimalFormat;

import org.apache.commons.lang3.builder.ReflectionToStringBuilder;

import com.windsor.node.common.domain.DomainStringStyle;

public abstract class BaseDomainObject {
    protected static final String DECIMAL_FORMAT = "#.################";

    protected String getFormattedDouble(Double d) {
        DecimalFormat f = new DecimalFormat("#.################");
        return f.format(d);
    }

    @Override
    public String toString() {
        ReflectionToStringBuilder rtsb = new ReflectionToStringBuilder(this, new DomainStringStyle());
        rtsb.setAppendStatics(false);
        rtsb.setAppendTransients(false);
        return rtsb.toString();
    }
}
