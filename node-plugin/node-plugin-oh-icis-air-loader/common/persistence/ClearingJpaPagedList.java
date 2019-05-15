package com.windsor.node.plugin.common.persistence;

import com.windsor.node.plugin.common.persistence.JpaPagedList;
import javax.persistence.EntityManager;

public class ClearingJpaPagedList extends JpaPagedList {
   public ClearingJpaPagedList(Class entityClass, EntityManager em, String dataQuery, String countQuery, int cacheSize) {
      super(entityClass, em, dataQuery, countQuery, cacheSize);
   }

   protected void beforePageLoaded() {
      this.getEm().clear();
   }
}
