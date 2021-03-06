package com.windsor.node.domain.entity;

import java.util.List;

import javax.persistence.*;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Type;

@Entity
@Cacheable
@Cache(usage = CacheConcurrencyStrategy.NONSTRICT_READ_WRITE)
@Table(name = "NFlow")
public class Exchange extends AbstractBaseEntity {

    @Column(name = "InfoUrl")
    private String url;

    @ManyToOne(optional = false)
    @JoinColumn(name = "Contact")
    private Account contact;

    @Column(name = "IsProtected", nullable = false)
    @Type(type = "yes_no")
    private boolean secure;

    @Column(name = "Code", nullable = false)
    private String name;

    @Column(name = "TargetExchangeName")
    private String targetExchangeName;

    @Column(name = "Description")
    private String description;

    @Column(name = "AutoDeleteFiles")
    @Type(type = "yes_no")
    private boolean autoDeleteFiles;

    @Column(name = "AutoDeleteFileAge")
    private Integer autoDeleteFileAge;

    @OneToMany(mappedBy = "exchange", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<AccountPolicy> accountPolicies;

    @OneToMany(mappedBy = "exchange", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ExchangeService> services;

    @OneToMany(mappedBy = "exchange")
    @OrderBy("ModifiedOn DESC")
    private List<Plugin> plugins;

    @OneToMany(mappedBy = "exchange", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Notification> notifications;

    @OneToMany(mappedBy = "exchange", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Schedule> schedules;
//
//    @Transient
//    private PluginUpload pluginUpload;

    public Exchange() {
        super();
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public Account getContact() {
        return contact;
    }

    public void setContact(Account contact) {
        this.contact = contact;
    }

    public boolean isSecure() {
        return secure;
    }

    public void setSecure(boolean secure) {
        this.secure = secure;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getTargetExchangeName() {
        return targetExchangeName;
    }

    public void setTargetExchangeName(String targetExchangeName) {
        this.targetExchangeName = targetExchangeName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isAutoDeleteFiles() {
        return autoDeleteFiles;
    }

    public void setAutoDeleteFiles(boolean autoDeleteFiles) {
        this.autoDeleteFiles = autoDeleteFiles;
    }

    public Integer getAutoDeleteFileAge() {
        return autoDeleteFileAge;
    }

    public void setAutoDeleteFileAge(Integer autoDeleteFileAge) {
        this.autoDeleteFileAge = autoDeleteFileAge;
    }

    public List<AccountPolicy> getAccountPolicies() {
        return accountPolicies;
    }

    public void setAccountPolicies(List<AccountPolicy> accountPolicies) {
        this.accountPolicies = accountPolicies;
    }

    public List<ExchangeService> getServices() {
        return services;
    }

    public void setServices(List<ExchangeService> services) {
        this.services = services;
    }

    public List<Plugin> getPlugins() {
        return plugins;
    }

    public void setPlugins(List<Plugin> plugins) {
        this.plugins = plugins;
    }

    public List<Notification> getNotifications() {
        return notifications;
    }

    public void setNotifications(List<Notification> notifications) {
        this.notifications = notifications;
    }

    public List<Schedule> getSchedules() {
        return schedules;
    }

    public void setSchedules(List<Schedule> schedules) {
        this.schedules = schedules;
    }

    //
//    public PluginUpload getPluginUpload() {
//        return pluginUpload;
//    }
//
//    public void setPluginUpload(PluginUpload pluginUpload) {
//        this.pluginUpload = pluginUpload;
//    }

    public boolean hasTargetExchange() {
        return targetExchangeName != null;
    }

    public static Exchange defaultExchange() {
        Exchange exchange = new Exchange();
        exchange.setSecure(true);
        return exchange;
    }

    @Override
    public String toString() {
        return "Exchange{" +
                "url='" + url + '\'' +
                ", contact=" + contact +
                ", secure=" + secure +
                ", name='" + name + '\'' +
                ", targetExchangeName='" + targetExchangeName + '\'' +
                ", description='" + description + '\'' +
                '}';
    }
}
