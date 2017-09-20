package com.windsor.node.plugin.gagapdesgeos.domain;

import javax.persistence.*;

@Entity
@Table(name = "GAPDES_SW_SUB_LIST")
public class FormList {

    @Id
    @GeneratedValue
    public Integer id;

    @ManyToOne
    @JoinColumn(name = "submission_id",  nullable = false)
    public GeosSwSubmission geosSwSubmission;

    @Column(name = "list_type")
    public String listType;

    @Column(name = "column_01")
    public String column01;

    @Column(name = "column_02")
    public String column02;

    @Column(name = "column_03")
    public String column03;

    @Column(name = "column_04")
    public String column04;

    @Column(name = "column_05")
    public String column05;

    @Column(name = "column_06")
    public String column06;

    @Column(name = "column_07")
    public String column07;

    @Column(name = "column_08")
    public String column08;

    @Column(name = "column_09")
    public String column09;

    @Column(name = "column_10")
    public String column10;

    @Column(name = "column_11")
    public String column11;

    @Column(name = "column_12")
    public String column12;

    @Column(name = "column_13")
    public String column13;

    @Column(name = "column_14")
    public String column14;

    @Column(name = "column_15")
    public String column15;

    @Column(name = "column_16")
    public String column16;

    @Column(name = "column_17")
    public String column17;

    @Column(name = "column_18")
    public String column18;

    @Column(name = "column_19")
    public String column19;

    @Column(name = "column_20")
    public String column20;

    @Column(name = "column_21")
    public String column21;

    @Column(name = "column_22")
    public String column22;

    @Column(name = "column_23")
    public String column23;

    @Column(name = "column_24")
    public String column24;

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

    public String getListType() {
        return listType;
    }

    public void setListType(String listType) {
        this.listType = listType;
    }

    public String getColumn01() {
        return column01;
    }

    public void setColumn01(String column01) {
        this.column01 = column01;
    }

    public String getColumn02() {
        return column02;
    }

    public void setColumn02(String column02) {
        this.column02 = column02;
    }

    public String getColumn03() {
        return column03;
    }

    public void setColumn03(String column03) {
        this.column03 = column03;
    }

    public String getColumn04() {
        return column04;
    }

    public void setColumn04(String column04) {
        this.column04 = column04;
    }

    public String getColumn05() {
        return column05;
    }

    public void setColumn05(String column05) {
        this.column05 = column05;
    }

    public String getColumn06() {
        return column06;
    }

    public void setColumn06(String column06) {
        this.column06 = column06;
    }

    public String getColumn07() {
        return column07;
    }

    public void setColumn07(String column07) {
        this.column07 = column07;
    }

    public String getColumn08() {
        return column08;
    }

    public void setColumn08(String column08) {
        this.column08 = column08;
    }

    public String getColumn09() {
        return column09;
    }

    public void setColumn09(String column09) {
        this.column09 = column09;
    }

    public String getColumn10() {
        return column10;
    }

    public void setColumn10(String column10) {
        this.column10 = column10;
    }

    public String getColumn11() {
        return column11;
    }

    public void setColumn11(String column11) {
        this.column11 = column11;
    }

    public String getColumn12() {
        return column12;
    }

    public void setColumn12(String column12) {
        this.column12 = column12;
    }

    public String getColumn13() {
        return column13;
    }

    public void setColumn13(String column13) {
        this.column13 = column13;
    }

    public String getColumn14() {
        return column14;
    }

    public void setColumn14(String column14) {
        this.column14 = column14;
    }

    public String getColumn15() {
        return column15;
    }

    public void setColumn15(String column15) {
        this.column15 = column15;
    }

    public String getColumn16() {
        return column16;
    }

    public void setColumn16(String column16) {
        this.column16 = column16;
    }

    public String getColumn17() {
        return column17;
    }

    public void setColumn17(String column17) {
        this.column17 = column17;
    }

    public String getColumn18() {
        return column18;
    }

    public void setColumn18(String column18) {
        this.column18 = column18;
    }

    public String getColumn19() {
        return column19;
    }

    public void setColumn19(String column19) {
        this.column19 = column19;
    }

    public String getColumn20() {
        return column20;
    }

    public void setColumn20(String column20) {
        this.column20 = column20;
    }

    public String getColumn21() {
        return column21;
    }

    public void setColumn21(String column21) {
        this.column21 = column21;
    }

    public String getColumn22() {
        return column22;
    }

    public void setColumn22(String column22) {
        this.column22 = column22;
    }

    public String getColumn23() {
        return column23;
    }

    public void setColumn23(String column23) {
        this.column23 = column23;
    }

    public String getColumn24() {
        return column24;
    }

    public void setColumn24(String column24) {
        this.column24 = column24;
    }

    @Override
    public String toString() {
        return "FormList{" +
                "listType='" + listType + '\'' +
                ", column01='" + column01 + '\'' +
                ", column02='" + column02 + '\'' +
                ", column03='" + column03 + '\'' +
                ", column04='" + column04 + '\'' +
                ", column05='" + column05 + '\'' +
                ", column06='" + column06 + '\'' +
                ", column07='" + column07 + '\'' +
                ", column08='" + column08 + '\'' +
                ", column09='" + column09 + '\'' +
                ", column10='" + column10 + '\'' +
                ", column11='" + column11 + '\'' +
                ", column12='" + column12 + '\'' +
                ", column13='" + column13 + '\'' +
                ", column14='" + column14 + '\'' +
                ", column15='" + column15 + '\'' +
                ", column16='" + column16 + '\'' +
                ", column17='" + column17 + '\'' +
                ", column18='" + column18 + '\'' +
                ", column19='" + column19 + '\'' +
                ", column20='" + column20 + '\'' +
                ", column21='" + column21 + '\'' +
                ", column22='" + column22 + '\'' +
                ", column23='" + column23 + '\'' +
                ", column24='" + column24 + '\'' +
                '}';
    }
}