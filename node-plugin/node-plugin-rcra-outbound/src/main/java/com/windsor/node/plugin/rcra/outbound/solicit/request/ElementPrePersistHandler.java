package com.windsor.node.plugin.rcra.outbound.solicit.request;

public interface ElementPrePersistHandler {
    Object prePersist(Object element, Object parent);
}
