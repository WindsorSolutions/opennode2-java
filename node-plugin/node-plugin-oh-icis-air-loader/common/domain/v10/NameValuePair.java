package com.windsor.node.plugin.common.domain.v10;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;

@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(
   name = "NameValuePair",
   propOrder = {"name", "value"}
)
public class NameValuePair {
   @XmlElement(
      required = true
   )
   protected String name;
   @XmlElement(
      required = true
   )
   protected String value;

   public String getName() {
      return this.name;
   }

   public void setName(String value) {
      this.name = value;
   }

   public String getValue() {
      return this.value;
   }

   public void setValue(String value) {
      this.value = value;
   }
}
