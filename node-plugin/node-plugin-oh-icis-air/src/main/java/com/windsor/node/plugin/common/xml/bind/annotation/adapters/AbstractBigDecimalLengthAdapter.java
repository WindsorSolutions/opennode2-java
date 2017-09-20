package com.windsor.node.plugin.common.xml.bind.annotation.adapters;

import java.math.BigDecimal;
import java.math.MathContext;
import javax.xml.bind.annotation.adapters.XmlAdapter;

public abstract class AbstractBigDecimalLengthAdapter extends XmlAdapter<String, BigDecimal> {
   protected abstract int totalNumberOfCharacters();

   protected int maxPrecision() {
      return this.totalNumberOfCharacters() - 1;
   }

   public BigDecimal unmarshal(String s) throws Exception {
      return new BigDecimal(s);
   }

   public String marshal(BigDecimal value) throws Exception {
      return value == null?null:this.toString(value);
   }

   protected String toString(BigDecimal value) {
      int amtOfPrecision = this.totalNumberOfCharacters() - value.toBigInteger().toString().length();
      BigDecimal bd = (new BigDecimal(value.toString(), new MathContext(amtOfPrecision > this.maxPrecision()?this.maxPrecision():amtOfPrecision))).stripTrailingZeros();
      return bd.toPlainString();
   }
}
