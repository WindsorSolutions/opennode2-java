package com.windsor.node.repo;

import org.springframework.data.jpa.repository.JpaRepository;

import com.windsor.node.domain.entity.ScheduleArgument;
import com.windsor.node.domain.search.ScheduleArgumentSearchCriteria;
import com.windsor.node.domain.search.ScheduleArgumentSort;

/**
 * Provides a repository for managing ScheduleArgument instances.
 */
public interface ScheduleArgumentRepository extends JpaRepository<ScheduleArgument, String>,
        ICrudRepository<ScheduleArgument, String, ScheduleArgumentSearchCriteria, ScheduleArgumentSort> {
}
