package com.windsor.node.plugin.common.domain.v10;

import com.windsor.node.plugin.common.domain.v10.DocHeader;
import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlID;
import javax.xml.bind.annotation.XmlSchemaType;
import javax.xml.bind.annotation.XmlType;
import javax.xml.bind.annotation.adapters.CollapsedStringAdapter;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;

@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(
   name = "ExchangeNetworkDocument",
   propOrder = {"header", "payload"}
)
public class ExchangeNetworkDocument {
   @XmlElement(
      name = "Header",
      required = true
   )
   protected DocHeader header;
   @XmlElement(
      name = "Payload",
      required = true
   )
   protected List payload;
   @XmlAttribute(
      name = "Id",
      required = true
   )
   @XmlJavaTypeAdapter(CollapsedStringAdapter.class)
   @XmlID
   @XmlSchemaType(
      name = "ID"
   )
   protected String id;

   public DocHeader getHeader() {
      return this.header;
   }

   public void setHeader(DocHeader value) {
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
