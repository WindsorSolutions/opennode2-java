package com.windsor.node.plugin.common.domain;

import com.windsor.node.plugin.common.domain.DocumentHeaderType;
import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlID;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlSchemaType;
import javax.xml.bind.annotation.XmlType;
import javax.xml.bind.annotation.adapters.CollapsedStringAdapter;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;

@XmlRootElement(
   name = "Document"
)
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(
   name = "ExchangeNetworkDocumentType",
   namespace = "http://www.exchangenetwork.net/schema/header/2",
   propOrder = {"header", "payload"}
)
public class ExchangeNetworkDocumentType {
   @XmlElement(
      name = "Header",
      required = true
   )
   protected DocumentHeaderType header;
   @XmlElement(
      name = "Payload",
      required = true
   )
   protected List payload;
   @XmlAttribute(
      required = true
   )
   @XmlJavaTypeAdapter(CollapsedStringAdapter.class)
   @XmlID
   @XmlSchemaType(
      name = "ID"
   )
   protected String id;

   public DocumentHeaderType getHeader() {
      return this.header;
   }

   public void setHeader(DocumentHeaderType value) {
      this.header = value;
   }

   public List getPayload() {
      if(this.payload == null) {
         this.payload = new ArrayList();
      }

      return this.payload;
   }

   public String getId() {
      return this.id;
   }

   public void setId(String value) {
      this.id = value;
   }
}
