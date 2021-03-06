//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, vJAXB 2.1.10 in JDK 6 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2012.01.24 at 11:33:47 AM PST 
//


package com.windsor.node.plugin.facid3.domain;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;
import javax.xml.datatype.XMLGregorianCalendar;


/**
 * <p>Java class for EnvironmentalInterestDataType complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="EnvironmentalInterestDataType">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/facilityid/3}DataSource"/>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/facilityid/3}EnvironmentalInterestIdentifier"/>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/facilityid/3}EnvironmentalInterestTypeText"/>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/facilityid/3}EnvironmentalInterestStartDate" minOccurs="0"/>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/facilityid/3}EnvironmentalInterestStartDateQualifierText" minOccurs="0"/>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/facilityid/3}EnvironmentalInterestEndDate" minOccurs="0"/>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/facilityid/3}EnvironmentalInterestEndDateQualifierText" minOccurs="0"/>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/facilityid/3}EnvironmentalInterestActiveIndicator" minOccurs="0"/>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/facilityid/3}AgencyType" minOccurs="0"/>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/facilityid/3}NAICSList" minOccurs="0"/>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/facilityid/3}SICList" minOccurs="0"/>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/facilityid/3}AffiliationList" minOccurs="0"/>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/facilityid/3}AlternativeIdentificationList" minOccurs="0"/>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/facilityid/3}ElectronicAddressList" minOccurs="0"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "EnvironmentalInterestDataType", propOrder = {
    "dataSource",
    "environmentalInterestIdentifier",
    "environmentalInterestTypeText",
    "environmentalInterestStartDate",
    "environmentalInterestStartDateQualifierText",
    "environmentalInterestEndDate",
    "environmentalInterestEndDateQualifierText",
    "environmentalInterestActiveIndicator",
    "agencyType",
    "naicsList",
    "sicList",
    "affiliationList",
    "alternativeIdentificationList",
    "electronicAddressList"
})
public class EnvironmentalInterestDataType {

    @XmlElement(name = "DataSource", required = true)
    protected DataSourceDataType dataSource;
    @XmlElement(name = "EnvironmentalInterestIdentifier", required = true)
    protected String environmentalInterestIdentifier;
    @XmlElement(name = "EnvironmentalInterestTypeText", required = true)
    protected String environmentalInterestTypeText;
    @XmlElement(name = "EnvironmentalInterestStartDate")
    protected XMLGregorianCalendar environmentalInterestStartDate;
    @XmlElement(name = "EnvironmentalInterestStartDateQualifierText")
    protected String environmentalInterestStartDateQualifierText;
    @XmlElement(name = "EnvironmentalInterestEndDate")
    protected XMLGregorianCalendar environmentalInterestEndDate;
    @XmlElement(name = "EnvironmentalInterestEndDateQualifierText")
    protected String environmentalInterestEndDateQualifierText;
    @XmlElement(name = "EnvironmentalInterestActiveIndicator")
    protected YesNoIndicatorDataType environmentalInterestActiveIndicator;
    @XmlElement(name = "AgencyType")
    protected AgencyTypeDataType agencyType;
    @XmlElement(name = "NAICSList")
    protected NAICSListDataType naicsList;
    @XmlElement(name = "SICList")
    protected SICListDataType sicList;
    @XmlElement(name = "AffiliationList")
    protected AffiliationListDataType affiliationList;
    @XmlElement(name = "AlternativeIdentificationList")
    protected AlternativeIdentificationListDataType alternativeIdentificationList;
    @XmlElement(name = "ElectronicAddressList")
    protected ElectronicAddressListDataType electronicAddressList;

    /**
     * Gets the value of the dataSource property.
     * 
     * @return
     *     possible object is
     *     {@link DataSourceDataType }
     *     
     */
    public DataSourceDataType getDataSource() {
        return dataSource;
    }

    /**
     * Sets the value of the dataSource property.
     * 
     * @param value
     *     allowed object is
     *     {@link DataSourceDataType }
     *     
     */
    public void setDataSource(DataSourceDataType value) {
        this.dataSource = value;
    }

    /**
     * Gets the value of the environmentalInterestIdentifier property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getEnvironmentalInterestIdentifier() {
        return environmentalInterestIdentifier;
    }

    /**
     * Sets the value of the environmentalInterestIdentifier property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setEnvironmentalInterestIdentifier(String value) {
        this.environmentalInterestIdentifier = value;
    }

    /**
     * Gets the value of the environmentalInterestTypeText property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getEnvironmentalInterestTypeText() {
        return environmentalInterestTypeText;
    }

    /**
     * Sets the value of the environmentalInterestTypeText property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setEnvironmentalInterestTypeText(String value) {
        this.environmentalInterestTypeText = value;
    }

    /**
     * Gets the value of the environmentalInterestStartDate property.
     * 
     * @return
     *     possible object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public XMLGregorianCalendar getEnvironmentalInterestStartDate() {
        return environmentalInterestStartDate;
    }

    /**
     * Sets the value of the environmentalInterestStartDate property.
     * 
     * @param value
     *     allowed object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public void setEnvironmentalInterestStartDate(XMLGregorianCalendar value) {
        this.environmentalInterestStartDate = value;
    }

    /**
     * Gets the value of the environmentalInterestStartDateQualifierText property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getEnvironmentalInterestStartDateQualifierText() {
        return environmentalInterestStartDateQualifierText;
    }

    /**
     * Sets the value of the environmentalInterestStartDateQualifierText property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setEnvironmentalInterestStartDateQualifierText(String value) {
        this.environmentalInterestStartDateQualifierText = value;
    }

    /**
     * Gets the value of the environmentalInterestEndDate property.
     * 
     * @return
     *     possible object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public XMLGregorianCalendar getEnvironmentalInterestEndDate() {
        return environmentalInterestEndDate;
    }

    /**
     * Sets the value of the environmentalInterestEndDate property.
     * 
     * @param value
     *     allowed object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public void setEnvironmentalInterestEndDate(XMLGregorianCalendar value) {
        this.environmentalInterestEndDate = value;
    }

    /**
     * Gets the value of the environmentalInterestEndDateQualifierText property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getEnvironmentalInterestEndDateQualifierText() {
        return environmentalInterestEndDateQualifierText;
    }

    /**
     * Sets the value of the environmentalInterestEndDateQualifierText property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setEnvironmentalInterestEndDateQualifierText(String value) {
        this.environmentalInterestEndDateQualifierText = value;
    }

    /**
     * Gets the value of the environmentalInterestActiveIndicator property.
     * 
     * @return
     *     possible object is
     *     {@link YesNoIndicatorDataType }
     *     
     */
    public YesNoIndicatorDataType getEnvironmentalInterestActiveIndicator() {
        return environmentalInterestActiveIndicator;
    }

    /**
     * Sets the value of the environmentalInterestActiveIndicator property.
     * 
     * @param value
     *     allowed object is
     *     {@link YesNoIndicatorDataType }
     *     
     */
    public void setEnvironmentalInterestActiveIndicator(YesNoIndicatorDataType value) {
        this.environmentalInterestActiveIndicator = value;
    }

    /**
     * Gets the value of the agencyType property.
     * 
     * @return
     *     possible object is
     *     {@link AgencyTypeDataType }
     *     
     */
    public AgencyTypeDataType getAgencyType() {
        return agencyType;
    }

    /**
     * Sets the value of the agencyType property.
     * 
     * @param value
     *     allowed object is
     *     {@link AgencyTypeDataType }
     *     
     */
    public void setAgencyType(AgencyTypeDataType value) {
        this.agencyType = value;
    }

    /**
     * Gets the value of the naicsList property.
     * 
     * @return
     *     possible object is
     *     {@link NAICSListDataType }
     *     
     */
    public NAICSListDataType getNAICSList() {
        return naicsList;
    }

    /**
     * Sets the value of the naicsList property.
     * 
     * @param value
     *     allowed object is
     *     {@link NAICSListDataType }
     *     
     */
    public void setNAICSList(NAICSListDataType value) {
        this.naicsList = value;
    }

    /**
     * Gets the value of the sicList property.
     * 
     * @return
     *     possible object is
     *     {@link SICListDataType }
     *     
     */
    public SICListDataType getSICList() {
        return sicList;
    }

    /**
     * Sets the value of the sicList property.
     * 
     * @param value
     *     allowed object is
     *     {@link SICListDataType }
     *     
     */
    public void setSICList(SICListDataType value) {
        this.sicList = value;
    }

    /**
     * Gets the value of the affiliationList property.
     * 
     * @return
     *     possible object is
     *     {@link AffiliationListDataType }
     *     
     */
    public AffiliationListDataType getAffiliationList() {
        return affiliationList;
    }

    /**
     * Sets the value of the affiliationList property.
     * 
     * @param value
     *     allowed object is
     *     {@link AffiliationListDataType }
     *     
     */
    public void setAffiliationList(AffiliationListDataType value) {
        this.affiliationList = value;
    }

    /**
     * Gets the value of the alternativeIdentificationList property.
     * 
     * @return
     *     possible object is
     *     {@link AlternativeIdentificationListDataType }
     *     
     */
    public AlternativeIdentificationListDataType getAlternativeIdentificationList() {
        return alternativeIdentificationList;
    }

    /**
     * Sets the value of the alternativeIdentificationList property.
     * 
     * @param value
     *     allowed object is
     *     {@link AlternativeIdentificationListDataType }
     *     
     */
    public void setAlternativeIdentificationList(AlternativeIdentificationListDataType value) {
        this.alternativeIdentificationList = value;
    }

    /**
     * Gets the value of the electronicAddressList property.
     * 
     * @return
     *     possible object is
     *     {@link ElectronicAddressListDataType }
     *     
     */
    public ElectronicAddressListDataType getElectronicAddressList() {
        return electronicAddressList;
    }

    /**
     * Sets the value of the electronicAddressList property.
     * 
     * @param value
     *     allowed object is
     *     {@link ElectronicAddressListDataType }
     *     
     */
    public void setElectronicAddressList(ElectronicAddressListDataType value) {
        this.electronicAddressList = value;
    }

}
