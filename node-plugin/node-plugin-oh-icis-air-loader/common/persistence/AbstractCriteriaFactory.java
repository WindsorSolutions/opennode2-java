package com.windsor.node.plugin.common.persistence;

import com.windsor.node.plugin.common.persistence.CriteriaFactory;

public abstract class AbstractCriteriaFactory implements CriteriaFactory {
   private Object data;

   public void setUntypedData(Object data) {
      this.data = data;
   }

   public void setData(Object data) {
      this.data = data;
   }

   protected Object getData() {
      return this.data;
   }
}
