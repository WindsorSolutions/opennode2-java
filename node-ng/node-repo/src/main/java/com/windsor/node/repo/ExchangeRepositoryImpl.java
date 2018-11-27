package com.windsor.node.repo;

import java.time.LocalDateTime;
import java.util.*;

import com.google.common.collect.ImmutableMap;
import com.mysema.query.types.EntityPath;
import com.mysema.query.types.Path;
import com.mysema.query.types.expr.BooleanExpression;
import com.windsor.node.domain.entity.Exchange;
import com.windsor.node.domain.search.EntityAlias;
import com.windsor.node.domain.search.ExchangeSearchCriteria;
import com.windsor.node.domain.search.ExchangeSort;
import com.windsor.node.domain.search.ExchangeSorts;
import com.windsor.stack.domain.repo.IFinderRepository;
import com.windsor.stack.domain.search.CriteriaHandler;
import com.windsor.stack.domain.search.IField;
import com.windsor.stack.repo.search.querydsl.AbstractQuerydslFinderRepository;
import com.windsor.stack.repo.search.querydsl.QuerydslFieldHandler;
import com.windsor.stack.repo.search.querydsl.QuerydslJoinInfo;
import com.windsor.stack.repo.search.querydsl.QuerydslUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Provides an implementation of the Exchange Repository.
 */
public class ExchangeRepositoryImpl extends AbstractQuerydslFinderRepository<Exchange, ExchangeSearchCriteria, ExchangeSort>
        implements IFinderRepository<Exchange, ExchangeSearchCriteria, ExchangeSort>, ExchangeRepositoryCustom {

    private static final Logger LOGGER = LoggerFactory.getLogger(ExchangeRepositoryImpl.class);

    private static final Map<Object, List<QuerydslJoinInfo>> ENTITY_ALIAS_MAP =
            ImmutableMap.<Object, List<QuerydslJoinInfo>> builder()
                    .put(EntityAlias.EXCHANGE, Collections.<QuerydslJoinInfo> emptyList())
                    .put(EntityAlias.ACCOUNT, Arrays.asList(
                            new QuerydslJoinInfo(QueryObjects.EXCHANGE.contact, QueryObjects.ACCOUNT)))
                    .build();

    public static final Map<ExchangeSort, Path<? extends Comparable<?>>> SORT_MAP =
            ImmutableMap.<ExchangeSort, Path<? extends Comparable<?>>> builder()
                    .put(ExchangeSort.ID, QueryObjects.EXCHANGE.id)
                    .put(ExchangeSort.CONTACT_NAME, QueryObjects.ACCOUNT.naasAccount)
                    .put(ExchangeSort.DESCRIPTION, QueryObjects.EXCHANGE.description)
                    .put(ExchangeSort.NAME, QueryObjects.EXCHANGE.name)
                    .put(ExchangeSort.SECURE, QueryObjects.EXCHANGE.secure)
                    .put(ExchangeSort.TARGET_EXCHANGE_NAME, QueryObjects.EXCHANGE.targetExchangeName)
                    .put(ExchangeSort.URL, QueryObjects.EXCHANGE.url)
                    .build();

    public final Map<Object, CriteriaHandler<BooleanExpression, ? extends IField<?>, ?>> CRITERIA_FIELD_HANDLER =
            ImmutableMap.<Object, CriteriaHandler<BooleanExpression, ? extends IField<?>, ?>> builder()
                    .put(ExchangeSearchCriteria.CONTACT, new CriteriaHandler<>(EntityAlias.ACCOUNT,
                            new QuerydslFieldHandler<>(f -> QuerydslUtils.newExpression(f, QueryObjects.ACCOUNT.naasAccount))))
                    .put(ExchangeSearchCriteria.DESCRIPTION, new CriteriaHandler<>(EntityAlias.EXCHANGE,
                            new QuerydslFieldHandler<>(f -> QuerydslUtils.newExpression(f, QueryObjects.EXCHANGE.description))))
                    .put(ExchangeSearchCriteria.NAME, new CriteriaHandler<>(EntityAlias.EXCHANGE,
                            new QuerydslFieldHandler<>(f -> QuerydslUtils.newExpression(f, QueryObjects.EXCHANGE.name))))
                    .put(ExchangeSearchCriteria.SECURE, new CriteriaHandler<>(EntityAlias.EXCHANGE,
                            new QuerydslFieldHandler<>(f -> QuerydslUtils.newExpression(f, QueryObjects.EXCHANGE.secure))))
                    .put(ExchangeSearchCriteria.TARGET_EXCHANGE_NAME, new CriteriaHandler<>(EntityAlias.EXCHANGE,
                            new QuerydslFieldHandler<>(f -> QuerydslUtils.newExpression(f, QueryObjects.EXCHANGE.targetExchangeName))))
                    .put(ExchangeSearchCriteria.URL, new CriteriaHandler<>(EntityAlias.EXCHANGE,
                            new QuerydslFieldHandler<>(f -> QuerydslUtils.newExpression(f, QueryObjects.EXCHANGE.url))))
                    .put(ExchangeSearchCriteria.NOT_IDS, new CriteriaHandler<>(EntityAlias.EXCHANGE,
                            new QuerydslFieldHandler<>(f -> QuerydslUtils.newExpression(f, QueryObjects.EXCHANGE.id))))
                    .put(ExchangeSearchCriteria.NOT_SECURE_OR_IDS, new CriteriaHandler<>(EntityAlias.EXCHANGE,
                            new QuerydslFieldHandler<>(f -> QueryObjects.EXCHANGE.secure.eq(false).or(QuerydslUtils.newExpression(f, QueryObjects.EXCHANGE.id)))))
                    .build();

    @Override
    protected EntityPath<Exchange> getFrom() {
        return QueryObjects.EXCHANGE;
    }

    @Override
    protected Map<Object, List<QuerydslJoinInfo>> getEntityAliasMap() {
        return ENTITY_ALIAS_MAP;
    }

    @Override
    protected Map<ExchangeSort, Path<? extends Comparable<?>>> getSortMap() {
        return SORT_MAP;
    }

    @Override
    protected Map<Object, CriteriaHandler<BooleanExpression, ? extends IField<?>, ?>> getCriteriaFieldHandlders() {
        return CRITERIA_FIELD_HANDLER;
    }

    @Override
    public void cleanupDocumentFiles() {
        find(new ExchangeSearchCriteria(), ExchangeSorts.NAME)
                .filter( ex -> ex.isAutoDeleteFiles())
                .forEach( ex -> cleanupDocumentFiles(ex));
    }

    private void cleanupDocumentFiles(Exchange exchange){

        // bail out if the file age <= 0
        if(exchange.getAutoDeleteFileAge() <= 0) {
            return;
        }

        LocalDateTime localDateTime =  LocalDateTime.now().minusDays(exchange.getAutoDeleteFileAge());
        LOGGER.info("Clearing documents for exchange \"" + exchange.getName() + "\" older than " + localDateTime);

        String query = "update Document as d set d.content = null where d.transaction.id in ("
                + "  select t.id from Transaction t where t.exchange.id = :eid"
                + "    and t.modifiedOn <= :mdate"
                + ")";
        getEntityManager().createQuery(query)
                .setParameter("eid", exchange.getId())
                .setParameter("mdate", localDateTime)
                .executeUpdate();
    }
}
