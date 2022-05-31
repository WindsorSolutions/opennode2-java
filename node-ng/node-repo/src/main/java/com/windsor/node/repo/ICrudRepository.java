package com.windsor.node.repo;

import com.windsor.stack.domain.repo.IFinderRepository;
import com.windsor.stack.domain.search.IEntityRelated;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.NoRepositoryBean;

import java.io.Serializable;

@NoRepositoryBean
public interface ICrudRepository<T, ID extends Serializable, C, S extends IEntityRelated> extends JpaRepository<T, ID>, IFinderRepository<T, C, S> {
}
