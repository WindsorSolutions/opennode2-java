package com.windsor.node.domain.entity;

import java.util.stream.Stream;

/**
 * Provides an enumeration of valid Service Types.
 */
public enum ServiceType {

    Task,
    Query,
    Solicit,
    Submit,
    Notify,
    Execute,
    QueryOrSolicit,
    QueryOrExecute;

    public static Stream<ServiceType> getMatches(String term) {
        Stream<ServiceType> s = Stream.of(values());
        return term == null ? s : s
                .filter(t -> t.toString().toLowerCase().contains(term.toLowerCase()));
    }
}
