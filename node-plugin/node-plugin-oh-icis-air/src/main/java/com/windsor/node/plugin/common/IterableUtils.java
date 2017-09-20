package com.windsor.node.plugin.common;

import com.windsor.node.plugin.common.ITransformer;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import org.apache.commons.collections.IteratorUtils;

public class IterableUtils {
   public static <IN, OUT> Iterable<OUT> transform(final Iterable<IN> it, final ITransformer<IN, OUT> transformer) {
      return new Iterable() {
         public Iterator<OUT> iterator() {
            return IteratorUtils.transformedIterator(it.iterator(), transformer);
         }
      };
   }

   public static <T> Collection<T> toCollection(Iterable<T> it) {
      ArrayList col = new ArrayList();
      Iterator i$ = it.iterator();

      while(i$.hasNext()) {
         Object t = i$.next();
         col.add(t);
      }

      return col;
   }

   public static <T> Iterable<T> toIterable(T t) {
      ArrayList col = new ArrayList();
      col.add(t);
      return col;
   }
}
