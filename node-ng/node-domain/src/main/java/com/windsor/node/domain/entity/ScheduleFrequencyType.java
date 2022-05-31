package com.windsor.node.domain.entity;

import java.util.stream.Stream;

/**
 * Provides an enumeration of schedule frequency types.
 */
public enum ScheduleFrequencyType {

    Never, Once, Minutes, Hours, Days, Weekdays, Weeks, Months;

    public static Stream<ScheduleFrequencyType> getMatches(String term) {
        Stream<ScheduleFrequencyType> s = Stream.of(values());
        return term == null ? s : s
                .filter(dsp -> dsp.toString().toLowerCase().contains(term.toLowerCase()));
    }
}
