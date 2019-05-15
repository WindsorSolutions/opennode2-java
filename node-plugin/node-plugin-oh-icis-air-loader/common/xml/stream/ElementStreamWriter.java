package com.windsor.node.plugin.common.xml.stream;

import com.windsor.node.plugin.common.xml.stream.ElementWriter;
import com.windsor.node.plugin.common.xml.stream.ElementWriterException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBElement;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import javax.xml.stream.FactoryConfigurationError;
import javax.xml.stream.XMLOutputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamWriter;
import org.apache.commons.lang3.StringUtils;

public class ElementStreamWriter implements ElementWriter {
   private XMLStreamWriter out;
   private Marshaller marshaller;

   public ElementStreamWriter(Class... classesToBeBound) throws ElementWriterException {
      try {
         JAXBContext e = JAXBContext.newInstance(this.makeContextPath(classesToBeBound), this.getClass().getClassLoader());
         this.marshaller = e.createMarshaller();
         this.marshaller.setProperty("jaxb.formatted.output", Boolean.valueOf(this.isFormattedOutput()));
      } catch (Exception var3) {
         throw new ElementWriterException(var3);
      }
   }

   private String makeContextPath(Class... classesToBeBound) {
      ArrayList packages = new ArrayList();
      Class[] arr$ = classesToBeBound;
      int len$ = classesToBeBound.length;

      for(int i$ = 0; i$ < len$; ++i$) {
         Class k = arr$[i$];
         packages.add(k.getPackage().getName());
      }

      return StringUtils.join(packages, ":");
   }

   protected boolean isFragment() {
      return Boolean.TRUE.booleanValue();
   }

   protected boolean isFormattedOutput() {
      return Boolean.TRUE.booleanValue();
   }

   public void open(OutputStream outputStream) throws ElementWriterException {
      try {
         this.onBeforeOpen();
         OutputStreamWriter e = new OutputStreamWriter(outputStream, "UTF-8");
         XMLOutputFactory outFactory = XMLOutputFactory.newFactory();
         outFactory.setProperty("javax.xml.stream.isRepairingNamespaces", Boolean.valueOf(true));
         this.out = outFactory.createXMLStreamWriter(e);
         this.out.writeStartDocument("UTF-8", "1.0");
         this.onAfterOpen(this.out);
      } catch (XMLStreamException var4) {
         throw new ElementWriterException("Unable to create XML stream writer from outputstream {" + outputStream + "}.", var4);
      } catch (FactoryConfigurationError var5) {
         throw new ElementWriterException("Unable to create XML stream writer from outputstream {" + outputStream + "}.", var5);
      } catch (UnsupportedEncodingException var6) {
         throw new ElementWriterException(var6);
      }
   }

   public void write(JAXBElement element) throws ElementWriterException {
      try {
         this.marshaller.marshal(element, this.out);
      } catch (JAXBException var3) {
         throw new ElementWriterException("Unable to marshal element {" + element + "} XML stream.", var3);
      }
   }

   public void close() throws ElementWriterException {
      try {
         this.onBeforeClose(this.out);
         this.out.close();
         this.onAfterClose();
      } catch (XMLStreamException var2) {
         throw new ElementWriterException("Unable to close XML stream writer {" + this.out + "}.", var2);
      }
   }

   protected void onBeforeOpen() throws ElementWriterException {
   }

   protected void onAfterOpen(XMLStreamWriter out) throws ElementWriterException {
   }

   protected void onBeforeClose(XMLStreamWriter out) throws ElementWriterException {
      try {
         out.writeEndDocument();
      } catch (XMLStreamException var3) {
         throw new ElementWriterException("Unable to write end of document {" + out + "}.", var3);
      }
   }

   protected void onAfterClose() {
   }
}
