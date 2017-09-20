package com.windsor.node.plugin.common.domain;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;

@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(
   name = "NameValuePair",
   namespace = "http://www.exchangenetwork.net/schema/header/2",
   propOrder = {"propertyName", "propertyValue"}
)
public class NameValuePair {
   @XmlElement(
      name = "PropertyName",
      required = true
   )
   protected String propertyName;
   @XmlElement(
      name = "PropertyValue",
      required = true
   )
   protected Object propertyValue;

   public String getPropertyName() {
      return this.propertyName;
   }

   public void setPropertyName(String value) {
      this.propertyName = value;
   }

   public Object getPropertyValue() {
      return this.propertyValue;
   }

   public void setPropertyValue(Object value) {
      this.propertyValue = value;
   }
}
