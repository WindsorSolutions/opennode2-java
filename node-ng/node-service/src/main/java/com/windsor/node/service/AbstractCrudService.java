package com.windsor.node.service;

import com.windsor.stack.domain.IEntity;
import com.windsor.node.repo.ICrudRepository;
import com.windsor.stack.domain.search.IEntityRelated;
import com.windsor.stack.domain.search.ISortGroup;
import com.windsor.stack.domain.service.ICrudService;
import com.windsor.stack.domain.util.PagedIterator;

import java.io.Serializable;
import java.util.Iterator;
import java.util.Spliterators;
import java.util.stream.Stream;
import java.util.stream.StreamSupport;

public abstract class AbstractCrudService<T extends IEntity<ID>, ID extends Serializable, C, S extends IEntityRelated> implements ICrudService<T, ID, C, S> {
    public AbstractCrudService() {
    }

    protected abstract ICrudRepository<T, ID, C, S> getRepo();

    public T load(ID id) {
        return this.getRepo().findById(id).orElse(null);
    }

    public Stream<T> load(Stream<ID> ids) {
        return ids.map(this::load);
    }

    public Stream<T> find(C criteria, ISortGroup<S> sortInfo, long offset, long limit) {
        return this.getRepo().find(criteria, sortInfo, offset, limit);
    }

    public Stream<T> find(C criteria, ISortGroup<S> sortInfo, long offset, long limit, long pageSize) {
        Iterator<T> it = new PagedIterator((off, lim) -> {
            return this.getRepo().find(criteria, sortInfo, off, lim > limit ? limit : lim);
        }, pageSize, offset);
        return StreamSupport.stream(Spliterators.spliterator(it, this.getRepo().count(criteria), 1024), false);
    }

    public Stream<T> find(C criteria, ISortGroup<S> sortInfo) {
        return this.getRepo().find(criteria, sortInfo);
    }

    public Stream<T> find(C criteria, ISortGroup<S> sortInfo, long pageSize) {
        Iterator<T> it = new PagedIterator((off, lim) -> {
            return this.getRepo().find(criteria, sortInfo, off, lim);
        }, pageSize);
        return StreamSupport.stream(Spliterators.spliterator(it, this.getRepo().count(criteria), 1024), false);
    }

    public long count(C criteria) {
        return this.getRepo().count(criteria);
    }

    public T save(T t) {
        return this.getRepo().save(t);
    }

    public void delete(T t) {
        this.getRepo().delete(t);
    }

    public void delete(ID id) {
        this.getRepo().deleteById(id);
    }
}

