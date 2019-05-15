package com.windsor.node.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.windsor.node.domain.entity.Exchange;
import com.windsor.node.domain.search.ExchangeSearchCriteria;
import com.windsor.node.domain.search.ExchangeSort;
import com.windsor.node.repo.ExchangeRepository;
import com.windsor.stack.domain.repo.ICrudRepository;
import com.windsor.stack.domain.service.AbstractCrudService;

/**
 * Provides an implementation of the Exchange Service.
 */
@Service
@Transactional(readOnly = true)
public class ExchangeServiceImpl extends AbstractCrudService<Exchange, String, ExchangeSearchCriteria, ExchangeSort>
        implements ExchangeService {

    private static final Logger LOGGER = LoggerFactory.getLogger(ExchangeServiceImpl.class);

    @Autowired
    private ExchangeRepository repository;

    @Override
    protected ICrudRepository<Exchange, String, ExchangeSearchCriteria, ExchangeSort> getRepo() {
        return repository;
    }

    @Override
    public boolean isNameUnique(String name, String excludedId) {
        Exchange exchange = repository.findByName(name);
        return exchange == null || exchange.getId().equals(excludedId);
    }

    @Transactional(readOnly = false)
    @Override
    public void cleanupDocumentFiles() {
        LOGGER.info("Running document file cleanup task...");
        repository.cleanupDocumentFiles();
        LOGGER.info("Document file cleanup task complete.");
    }
}
