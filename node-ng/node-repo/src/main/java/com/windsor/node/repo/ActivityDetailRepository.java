package com.windsor.node.repo;

import org.springframework.data.jpa.repository.JpaRepository;

import com.windsor.node.domain.entity.ActivityDetail;
import com.windsor.node.domain.search.ActivityDetailSearchCriteria;
import com.windsor.node.domain.search.ActivityDetailSort;

/**
 * Provides a repository for managing Activity Detail instances.
 */
public interface ActivityDetailRepository extends JpaRepository<ActivityDetail, String>,
        ICrudRepository<ActivityDetail, String, ActivityDetailSearchCriteria, ActivityDetailSort> {

}
