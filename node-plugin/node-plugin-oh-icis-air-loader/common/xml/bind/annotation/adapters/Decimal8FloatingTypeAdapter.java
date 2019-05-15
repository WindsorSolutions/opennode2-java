package com.windsor.node.plugin.common.xml.bind.annotation.adapters;

import com.windsor.node.plugin.common.xml.bind.annotation.adapters.AbstractBigDecimalLengthAdapter;

public class Decimal8FloatingTypeAdapter extends AbstractBigDecimalLengthAdapter {
   protected int totalNumberOfCharacters() {
      return 8;
   }
}
