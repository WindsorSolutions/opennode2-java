package com.windsor.node.plugin.common.staging;

import java.util.List;
import java.util.Map;

import com.windsor.node.plugin.common.dao.TextLoader;

public abstract interface XmlStaging
{
  public abstract void execute(StringBuffer paramStringBuffer, boolean paramBoolean);

  public abstract int getBatchSize();

  public abstract void setBatchSize(int paramInt);

  public abstract List getListNames();

  public abstract Map getListElementMap();

  public abstract String getDocumentOpen();

  public abstract String getDocumentClose();

  public abstract String getStartTag(String paramString);

  public abstract String getEndTag(String paramString);

  public abstract void setTextLoader(TextLoader paramTextLoader);

  public abstract TextLoader getTextLoader();
}
