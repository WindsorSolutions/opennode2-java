package com.windsor.node.plugin.common.domain;

import javax.xml.bind.annotation.XmlEnum;
import javax.xml.bind.annotation.XmlEnumValue;
import javax.xml.bind.annotation.XmlType;

@XmlType(
   name = "OperationCodeType",
   namespace = "http://www.exchangenetwork.net/schema/header/2"
)
@XmlEnum
public enum OperationCodeType {
   @XmlEnumValue("None")
   NONE("None"),
   @XmlEnumValue("Refresh")
   REFRESH("Refresh"),
   @XmlEnumValue("Insert")
   INSERT("Insert"),
   @XmlEnumValue("Update")
   UPDATE("Update"),
   @XmlEnumValue("Delete")
   DELETE("Delete"),
   @XmlEnumValue("Merge")
   MERGE("Merge");

   private final String value;

   private OperationCodeType(String v) {
      this.value = v;
   }

   public String value() {
      return this.value;
   }

   public static OperationCodeType fromValue(String v) {
      OperationCodeType[] arr$ = values();
      int len$ = arr$.length;

      for(int i$ = 0; i$ < len$; ++i$) {
         OperationCodeType c = arr$[i$];
         if(c.value.equals(v)) {
            return c;
         }
      }

      throw new IllegalArgumentException(v);
   }
}
