package com.windsor.node.plugin.common;

import com.windsor.node.plugin.common.ITransformer;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import org.apache.commons.collections.IteratorUtils;

public class IterableUtils {
   public static Iterable transform(final Iterable it, final ITransformer transformer) {
      return new Iterable() {
         public Iterator iterator() {
            return IteratorUtils.transformedIterator(it.iterator(), transformer);
         }
      };
   }

   public static Collection toCollection(Iterable it) {
      ArrayList col = new ArrayList();
      Iterator i$ = it.iterator();

      while(i$.hasNext()) {
         Object t = i$.next();
         col.add(t);
      }

      return col;
   }

   public static Iterable toIterable(Object t) {
      ArrayList col = new ArrayList();
      col.add(t);
      return col;
   }
}
