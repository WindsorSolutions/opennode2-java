package com.windsor.node.plugin.common.xml.stream;

import com.windsor.node.plugin.common.xml.stream.ElementWriterException;
import java.io.OutputStream;
import javax.xml.bind.JAXBElement;

public interface ElementWriter {
   void open(OutputStream var1) throws ElementWriterException;

   void write(JAXBElement<?> var1) throws ElementWriterException;

   void close() throws ElementWriterException;
}
