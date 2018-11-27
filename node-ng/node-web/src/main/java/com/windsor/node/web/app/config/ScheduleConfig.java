package com.windsor.node.web.app.config;

import com.windsor.node.service.ExchangeService;
import org.apache.wicket.spring.injection.annot.SpringBean;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

/**
 * Provides scheduling for the application.
 */
@Component
public class ScheduleConfig {

    @SpringBean
    private ExchangeService service;

    @Scheduled(cron = "*/5 * * * *") // cron = "0 3 * * *"
    public void cleanupDocumentFiles() {
        service.cleanupDocumentFiles();
    }
}
