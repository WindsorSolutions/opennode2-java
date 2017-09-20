package com.windsor.node.plugin.common.domain;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAnyElement;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlID;
import javax.xml.bind.annotation.XmlSchemaType;
import javax.xml.bind.annotation.XmlType;
import javax.xml.bind.annotation.adapters.CollapsedStringAdapter;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;

@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(
   name = "DocumentPayloadType",
   namespace = "http://www.exchangenetwork.net/schema/header/2",
   propOrder = {"any"}
)
public class DocumentPayloadType {
   @XmlAnyElement(
      lax = true
   )
   protected Object any;
   @XmlAttribute
   @XmlJavaTypeAdapter(CollapsedStringAdapter.class)
   @XmlID
   @XmlSchemaType(
      name = "ID"
   )
   protected String id;
   @XmlAttribute
   protected String operation;

   public Object getAny() {
      return this.any;
   }

   public void setAny(Object value) {
      this.any = value;
   }

   public String getId() {
      return this.id;
   }

   public void setId(String value) {
      this.id = value;
   }

   public String getOperation() {
      return this.operation;
   }

   public void setOperation(String value) {
      this.operation = value;
   }
}
