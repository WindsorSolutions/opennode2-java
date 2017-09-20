package com.windsor.node.plugin.gagapdesgeos.domain;


import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "GAPDES_SW_SUB_MILESTONE")
public class Milestone {

    @Id
    @GeneratedValue
    public Integer id;

    @ManyToOne
    @JoinColumn(name = "submission_id",  nullable = false)
    public GeosSwSubmission geosSwSubmission;

    @Column(name = "milestone_type")
    public String milestoneType;

    @Column(name = "milestone_date")
    public Date milestoneDate;


    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public GeosSwSubmission getGeosSwSubmission() {
        return geosSwSubmission;
    }

    public void setGeosSwSubmission(GeosSwSubmission geosSwSubmission) {
        this.geosSwSubmission = geosSwSubmission;
    }

    public String getMilestoneType() {
        return milestoneType;
    }

    public void setMilestoneType(String milestoneType) {
        this.milestoneType = milestoneType;
    }

    public Date getMilestoneDate() {
        return milestoneDate;
    }

    public void setMilestoneDate(Date milestoneDate) {
        this.milestoneDate = milestoneDate;
    }

    @Override
    public String toString() {
        return "Milestone{" +
                "milestoneType='" + milestoneType + '\'' +
                ", milestoneDate=" + milestoneDate +
                '}';
    }
}