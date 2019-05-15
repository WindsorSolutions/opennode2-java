package com.windsor.node.plugin.common.domain;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;

@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(
   name = "TransformsType",
   propOrder = {"transform"}
)
public class TransformsType {
   @XmlElement(
      name = "Transform",
      required = true
   )
   protected List transform;

   public List getTransform() {
      if(this.transform == null) {
         this.transform = new ArrayList();
      }

      return this.transform;
   }
}
