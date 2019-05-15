package com.windsor.node.plugin.common;

import com.windsor.node.plugin.common.ITransformer;

public abstract class AbstractTransformer implements ITransformer {
   public static final AbstractTransformer.UpperCaseTransformer UPPER_CASE_TRANSFORMER = new AbstractTransformer.UpperCaseTransformer();

   public Object transform(Object input) {
      return this.typedTransform(input);
   }

   public static class SuffixAppenderTransformer extends AbstractTransformer {
      private final String suffix;

      public SuffixAppenderTransformer(String suffix) {
         this.suffix = suffix;
      }

//      public String typedTransform(String in) {
//         return in == null?null:in + this.suffix;
//      }

      @Override
      public Object typedTransform(Object in) {
         return in == null?null:in + this.suffix;
      }
   }

   public static class LengthTransformer extends AbstractTransformer {
      private final int maxLength;

      public LengthTransformer(int maxLength) {
         this.maxLength = maxLength;
      }

//      public String typedTransform(String in) {
//         return in == null?null:(in.length() > this.maxLength?in.substring(0, this.maxLength):in);
//      }

      @Override
      public Object typedTransform(Object var1) {
         String in = var1.toString();
         return in == null?null:(in.length() > this.maxLength?in.substring(0, this.maxLength):in);
      }
   }

   static class UpperCaseTransformer extends AbstractTransformer {
//      public String typedTransform(String in) {
//         return in == null?null:in.toUpperCase();
//      }

      @Override
      public Object typedTransform(Object var1) {
         String in = var1.toString();
         return in == null?null:in.toUpperCase();
      }
   }
}
