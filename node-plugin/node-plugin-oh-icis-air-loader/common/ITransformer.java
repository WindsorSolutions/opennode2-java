package com.windsor.node.plugin.common;

import org.apache.commons.collections.Transformer;

public interface ITransformer extends Transformer {
   Object typedTransform(Object var1);
}
