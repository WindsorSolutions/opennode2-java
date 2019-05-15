package com.windsor.node.plugin.common.persistence;

import com.windsor.node.plugin.common.AbstractTransformer;
import com.windsor.node.plugin.common.IterableUtils;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.Expression;
import javax.persistence.criteria.Predicate;

public class QueryUtils {
   private static final AbstractTransformer.SuffixAppenderTransformer LIKE_TRANSFORMER = new AbstractTransformer.SuffixAppenderTransformer("%");

   public static Predicate createLike(Iterable values, CriteriaBuilder cb, Iterable paths) {
      ArrayList disjunctions = new ArrayList();
      Iterator i$ = values.iterator();

      while(true) {
         String s;
         do {
            if(!i$.hasNext()) {
               return cb.or((Predicate[])disjunctions.toArray(new Predicate[disjunctions.size()]));
            }

            s = (String)i$.next();
         } while(s == null);

         Iterator i$1 = paths.iterator();

         while(i$1.hasNext()) {
            Expression path = (Expression)i$1.next();
            disjunctions.add(cb.like(path, s));
         }
      }
   }

   public static Predicate startsWithIgnoreCase(Iterable values, CriteriaBuilder cb, Iterable paths) {
      QueryUtils.UpperCaseExpressionTransformer uct = new QueryUtils.UpperCaseExpressionTransformer(cb);
      Iterable it = IterableUtils.transform(paths, uct);
      return createLike(IterableUtils.transform(IterableUtils.transform(values, AbstractTransformer.UPPER_CASE_TRANSFORMER), LIKE_TRANSFORMER), cb, it);
   }

   public static Predicate startsWithIgnoreCase(Iterable values, CriteriaBuilder cb, Expression path) {
      return startsWithIgnoreCase(values, cb, IterableUtils.toIterable(path));
   }

   public static Predicate startsWithIgnoreCase(String value, CriteriaBuilder cb, Expression path) {
      return startsWithIgnoreCase(IterableUtils.toIterable(value), cb, IterableUtils.toIterable(path));
   }

   public static Predicate in(Iterable col, CriteriaBuilder cb, Iterable paths) {
      ArrayList predicates = new ArrayList();
      Iterator i$ = paths.iterator();

      while(i$.hasNext()) {
         Expression exp = (Expression)i$.next();
         predicates.add(in(col, cb, exp));
      }

      return cb.or((Predicate[])predicates.toArray(new Predicate[predicates.size()]));
   }

   public static Predicate in(Iterable col, CriteriaBuilder cb, Expression path) {
      Collection col2 = IterableUtils.toCollection(col);
      return path.in((Object[])col2.toArray(new String[col2.size()]));
   }

   public static Predicate inIgnoreCase(Collection values, CriteriaBuilder cb, Expression path) {
      return in(IterableUtils.transform(values, AbstractTransformer.UPPER_CASE_TRANSFORMER), cb, IterableUtils.transform(IterableUtils.toIterable(path), new QueryUtils.UpperCaseExpressionTransformer(cb)));
   }

   static class UpperCaseExpressionTransformer extends AbstractTransformer {
      private final CriteriaBuilder criteriaBuilder;

      public UpperCaseExpressionTransformer(CriteriaBuilder criteriaBuilder) {
         this.criteriaBuilder = criteriaBuilder;
      }

      public CriteriaBuilder getCriteriaBuilder() {
         return this.criteriaBuilder;
      }

//      public Expression typedTransform(Expression in) {
//         return this.getCriteriaBuilder().upper(in);
//      }

      @Override
      public Object typedTransform(Object var1) {
         Expression in = (Expression) var1;
         return this.getCriteriaBuilder().upper(in);
      }
   }
}