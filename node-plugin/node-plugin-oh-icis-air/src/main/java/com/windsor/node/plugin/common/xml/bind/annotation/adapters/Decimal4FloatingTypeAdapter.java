package com.windsor.node.plugin.common.xml.bind.annotation.adapters;

import com.windsor.node.plugin.common.xml.bind.annotation.adapters.AbstractBigDecimalLengthAdapter;

public class Decimal4FloatingTypeAdapter extends AbstractBigDecimalLengthAdapter {
   protected int totalNumberOfCharacters() {
      return 4;
   }

   protected int maxPrecision() {
      return 2;
   }
}
