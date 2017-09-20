package com.windsor.node.plugin.common;

import com.windsor.node.plugin.common.ITransformer;

public abstract class AbstractTransformer<IN, OUT> implements ITransformer<IN, OUT> {
   public static final AbstractTransformer.UpperCaseTransformer UPPER_CASE_TRANSFORMER = new AbstractTransformer.UpperCaseTransformer();

   public Object transform(Object input) {
      return this.typedTransform((IN) input);
   }

   public static class SuffixAppenderTransformer extends AbstractTransformer<String, String> {
      private final String suffix;

      public SuffixAppenderTransformer(String suffix) {
         this.suffix = suffix;
      }

      public String typedTransform(String in) {
         return in == null?null:in + this.suffix;
      }
   }

   public static class LengthTransformer extends AbstractTransformer<String, String> {
      private final int maxLength;

      public LengthTransformer(int maxLength) {
         this.maxLength = maxLength;
      }

      public String typedTransform(String in) {
         return in == null?null:(in.length() > this.maxLength?in.substring(0, this.maxLength):in);
      }
   }

   static class UpperCaseTransformer extends AbstractTransformer<String, String> {
      public String typedTransform(String in) {
         return in == null?null:in.toUpperCase();
      }
   }
}
