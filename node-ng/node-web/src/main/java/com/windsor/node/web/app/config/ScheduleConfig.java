package com.windsor.node.web.app.config;

import com.windsor.node.service.ExchangeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

/**
 * Provides scheduling for the application.
 */
@Component
public class ScheduleConfig {

    @Autowired
    private ExchangeService service;

    @Scheduled(cron = "0 */5 * * * *") // cron = "0 0 3 * * *"
    public void cleanupDocumentFiles() {
        service.cleanupDocumentFiles();
    }
}
