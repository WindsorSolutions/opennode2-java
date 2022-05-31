package com.windsor.node.repo;

import org.springframework.data.jpa.repository.JpaRepository;

import com.windsor.node.domain.entity.Activity;
import com.windsor.node.domain.search.ActivitySearchCriteria;
import com.windsor.node.domain.search.ActivitySort;

/**
 * Provides a repository for managing Activity instances.
 */
public interface ActivityRepository extends ICrudRepository<Activity, String, ActivitySearchCriteria, ActivitySort>,
        ActivityRepositoryCustom {
	
}
