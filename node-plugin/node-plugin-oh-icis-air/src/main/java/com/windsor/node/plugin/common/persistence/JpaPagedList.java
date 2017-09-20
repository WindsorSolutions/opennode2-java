package com.windsor.node.plugin.common.persistence;

import java.io.Serializable;
import java.util.AbstractList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import javax.persistence.EntityManager;
import javax.persistence.Query;
import javax.persistence.TypedQuery;

public class JpaPagedList<T extends Serializable> extends AbstractList<T> {
   private final EntityManager em;
   private String dataQuery;
   private String countQuery;
   private List<T> cache;
   private int cacheStart;
   private final int cacheSize;
   private Integer size;
   private final Class<T> entityClass;
   private final Map<String, Object> namedParameters = new HashMap();

   public JpaPagedList(Class<T> entityClass, EntityManager em, String dataQuery, String countQuery, int cacheSize) {
      this.entityClass = entityClass;
      this.em = em;
      this.dataQuery = dataQuery;
      this.countQuery = countQuery;
      this.cacheSize = cacheSize;
   }

   public JpaPagedList(Class<T> entityClass, EntityManager em, int cacheSize) {
      this.entityClass = entityClass;
      this.em = em;
      this.cacheSize = cacheSize;
   }

   public final T get(int index) {
      if(index > this.size()) {
         throw new IndexOutOfBoundsException();
      } else {
         if(this.cache == null || index < this.cacheStart || index >= this.cacheStart + this.cache.size()) {
            this.cacheStart = index / this.cacheSize * this.cacheSize;
            Query q = this.em.createQuery(this.getDataQuery()).setFirstResult(this.cacheStart).setMaxResults(this.cacheSize);
            this.setNamedParameters(q);
            this.cache = q.getResultList();
         }

         return this.cache.get(index - this.cacheStart);
      }
   }

   public final int size() {
      if(this.size == null) {
         TypedQuery q = this.em.createQuery(this.getCountQuery(), Long.class);
         this.setNamedParameters(q);
         this.size = Integer.valueOf(((Long)q.getSingleResult()).intValue());
      }

      return this.size.intValue();
   }

   private final Query setNamedParameters(Query q) {
      if(!this.getNamedParameters().isEmpty()) {
         Iterator i$ = this.getNamedParameters().keySet().iterator();

         while(i$.hasNext()) {
            String key = (String)i$.next();
            q.setParameter(key, this.getNamedParameters().get(key));
         }
      }

      return q;
   }

   protected String getDataQuery() {
      return this.dataQuery;
   }

   protected String getCountQuery() {
      return this.countQuery;
   }

   protected final void addNamedParameter(String name, Object value) {
      this.namedParameters.put(name, value);
   }

   private Map<String, Object> getNamedParameters() {
      return this.namedParameters;
   }

   protected final Class<T> getEntityClass() {
      return this.entityClass;
   }

   protected void beforePageLoaded() {
   }

   protected EntityManager getEm() {
      return this.em;
   }
}
