package com.windsor.node.plugin.common.domain.v10;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAnyElement;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlType;

@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(
   name = "Payload",
   propOrder = {"any"}
)
public class Payload {
   @XmlAnyElement(
      lax = true
   )
   protected Object any;
   @XmlAttribute(
      name = "Operation",
      required = true
   )
   protected String operation;

   public Object getAny() {
      return this.any;
   }

   public void setAny(Object value) {
      this.any = value;
   }

   public String getOperation() {
      return this.operation;
   }

   public void setOperation(String value) {
      this.operation = value;
   }
}
