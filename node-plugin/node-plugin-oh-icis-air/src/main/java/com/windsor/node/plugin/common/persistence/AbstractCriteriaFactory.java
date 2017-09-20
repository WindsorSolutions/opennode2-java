package com.windsor.node.plugin.common.persistence;

import com.windsor.node.plugin.common.persistence.CriteriaFactory;

public abstract class AbstractCriteriaFactory<DATA, ROOT> implements CriteriaFactory<DATA, ROOT> {
   private DATA data;

   public void setUntypedData(Object data) {
      this.data = (DATA) data;
   }

   public void setData(DATA data) {
      this.data = data;
   }

   protected DATA getData() {
      return this.data;
   }
}
