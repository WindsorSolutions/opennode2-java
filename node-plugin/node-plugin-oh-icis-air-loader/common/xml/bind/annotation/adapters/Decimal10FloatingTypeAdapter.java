package com.windsor.node.plugin.common.xml.bind.annotation.adapters;

import com.windsor.node.plugin.common.xml.bind.annotation.adapters.AbstractBigDecimalLengthAdapter;

public class Decimal10FloatingTypeAdapter extends AbstractBigDecimalLengthAdapter {
   protected int totalNumberOfCharacters() {
      return 10;
   }
}