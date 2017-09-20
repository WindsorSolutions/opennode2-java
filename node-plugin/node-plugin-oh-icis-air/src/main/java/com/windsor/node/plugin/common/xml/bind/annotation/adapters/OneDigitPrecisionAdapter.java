package com.windsor.node.plugin.common.xml.bind.annotation.adapters;

import com.windsor.node.plugin.common.xml.bind.annotation.adapters.AbstractBigDecimalFormatAdapter;

public class OneDigitPrecisionAdapter extends AbstractBigDecimalFormatAdapter {
   private static final String NUMBER_FORMAT = "0.0";

   protected String getNumberFormatString() {
      return "0.0";
   }
}
