package com.windsor.node.plugin.common.xml.document;

import com.windsor.node.plugin.common.xml.stream.ElementWriter;

public interface ElementWriteHandler<T> {
   void handle(ElementWriter var1, T var2);
}
