package com.windsor.node.web.app.config;

import org.hibernate.SessionFactory;
import org.hibernate.event.service.spi.EventListenerRegistry;
import org.hibernate.internal.SessionFactoryImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;

/**
 * Provides the Hibernate configuration for the application.
 */
public class HibernateConfig {

    @Autowired
    private SessionFactory sessionFactory;

    @Bean
    public EventListenerRegistry eventListenerRegistry() {
        SessionFactoryImpl sf = (SessionFactoryImpl) sessionFactory;
        return sf.getServiceRegistry().getService(EventListenerRegistry.class);
    }
}
