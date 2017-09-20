package com.windsor.node.plugin.common.persistence;

import com.windsor.node.plugin.common.persistence.JpaPagedList;
import java.io.Serializable;
import javax.persistence.EntityManager;

public class ClearingJpaPagedList<T extends Serializable> extends JpaPagedList<T> {
   public ClearingJpaPagedList(Class<T> entityClass, EntityManager em, String dataQuery, String countQuery, int cacheSize) {
      super(entityClass, em, dataQuery, countQuery, cacheSize);
   }

   protected void beforePageLoaded() {
      this.getEm().clear();
   }
}
