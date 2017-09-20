package com.windsor.node.plugin.common;

import org.apache.commons.collections.Transformer;

public interface ITransformer<IN, OUT> extends Transformer {
   OUT typedTransform(IN var1);
}
