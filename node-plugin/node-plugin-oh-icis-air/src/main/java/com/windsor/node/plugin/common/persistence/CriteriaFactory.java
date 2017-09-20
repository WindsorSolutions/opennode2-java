package com.windsor.node.plugin.common.persistence;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

public interface CriteriaFactory<DATA, ROOT> {
   Predicate create(Root<? extends ROOT> var1, CriteriaQuery<?> var2, CriteriaBuilder var3);

   void setData(DATA var1);

   void setUntypedData(Object var1);
}
