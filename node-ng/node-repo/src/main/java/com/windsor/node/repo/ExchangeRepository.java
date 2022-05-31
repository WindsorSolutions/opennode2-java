package com.windsor.node.repo;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.windsor.node.domain.entity.Exchange;
import com.windsor.node.domain.search.ExchangeSearchCriteria;
import com.windsor.node.domain.search.ExchangeSort;

/**
 * Provides a repository for managing Exchange instances.
 */
public interface ExchangeRepository extends ICrudRepository<Exchange, String, ExchangeSearchCriteria, ExchangeSort>, ExchangeRepositoryCustom {

    @Query("select e from Exchange e where e.name = ?1")
    Exchange findByName(String name);
}
