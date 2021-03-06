//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v2.2.4 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2013.08.26 at 02:36:56 PM PDT 
//


package com.windsor.node.plugin.ic.fixeddomain;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Embeddable;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Transient;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;
import javax.xml.datatype.XMLGregorianCalendar;
import org.jvnet.hyperjaxb3.xml.bind.annotation.adapters.XMLGregorianCalendarAsDate;
import org.jvnet.hyperjaxb3.xml.bind.annotation.adapters.XmlAdapterUtils;
import org.jvnet.jaxb2_commons.lang.Equals;
import org.jvnet.jaxb2_commons.lang.EqualsStrategy;
import org.jvnet.jaxb2_commons.lang.HashCode;
import org.jvnet.jaxb2_commons.lang.HashCodeStrategy;
import org.jvnet.jaxb2_commons.lang.JAXBEqualsStrategy;
import org.jvnet.jaxb2_commons.lang.JAXBHashCodeStrategy;
import org.jvnet.jaxb2_commons.locator.ObjectLocator;
import org.jvnet.jaxb2_commons.locator.util.LocatorUtils;


/**
 * <p>Java class for DataSourceDataType complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="DataSourceDataType">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/IC/1}OriginatingPartnerName"/>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/IC/1}InformationSystemAcronymName"/>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/IC/1}LastUpdatedDate"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "DataSourceDataType", propOrder = {
    "originatingPartnerName",
    "informationSystemAcronymName",
    "lastUpdatedDate"
})
@Embeddable
public class DataSourceDataType
    implements Serializable, Equals, HashCode
{

    private final static long serialVersionUID = 1L;
    @XmlElement(name = "OriginatingPartnerName", required = true)
    protected String originatingPartnerName;
    @XmlElement(name = "InformationSystemAcronymName", required = true)
    protected String informationSystemAcronymName;
    @XmlElement(name = "LastUpdatedDate", required = true)
    protected XMLGregorianCalendar lastUpdatedDate;

    /**
     * Gets the value of the originatingPartnerName property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    @Basic
    @Column(name = "ORIG_PARTNER_NAME", length = 255)
    public String getOriginatingPartnerName() {
        return originatingPartnerName;
    }

    /**
     * Sets the value of the originatingPartnerName property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setOriginatingPartnerName(String value) {
        this.originatingPartnerName = value;
    }

    @Transient
    public boolean isSetOriginatingPartnerName() {
        return (this.originatingPartnerName!= null);
    }

    /**
     * Gets the value of the informationSystemAcronymName property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    @Basic
    @Column(name = "INFO_SYSTEM_ACRONYM_NAME", length = 255)
    public String getInformationSystemAcronymName() {
        return informationSystemAcronymName;
    }

    /**
     * Sets the value of the informationSystemAcronymName property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setInformationSystemAcronymName(String value) {
        this.informationSystemAcronymName = value;
    }

    @Transient
    public boolean isSetInformationSystemAcronymName() {
        return (this.informationSystemAcronymName!= null);
    }

    /**
     * Gets the value of the lastUpdatedDate property.
     * 
     * @return
     *     possible object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    @Transient
    public XMLGregorianCalendar getLastUpdatedDate() {
        return lastUpdatedDate;
    }

    /**
     * Sets the value of the lastUpdatedDate property.
     * 
     * @param value
     *     allowed object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public void setLastUpdatedDate(XMLGregorianCalendar value) {
        this.lastUpdatedDate = value;
    }

    @Transient
    public boolean isSetLastUpdatedDate() {
        return (this.lastUpdatedDate!= null);
    }

    @Basic
    @Column(name = "LAST_UPDATED_DATE")
    @Temporal(TemporalType.DATE)
    public Date getLastUpdatedDateItem() {
        return XmlAdapterUtils.unmarshall(XMLGregorianCalendarAsDate.class, this.getLastUpdatedDate());
    }

    public void setLastUpdatedDateItem(Date target) {
        setLastUpdatedDate(XmlAdapterUtils.marshall(XMLGregorianCalendarAsDate.class, target));
    }

    public boolean equals(ObjectLocator thisLocator, ObjectLocator thatLocator, Object object, EqualsStrategy strategy) {
        if (!(object instanceof DataSourceDataType)) {
            return false;
        }
        if (this == object) {
            return true;
        }
        final DataSourceDataType that = ((DataSourceDataType) object);
        {
            String lhsOriginatingPartnerName;
            lhsOriginatingPartnerName = this.getOriginatingPartnerName();
            String rhsOriginatingPartnerName;
            rhsOriginatingPartnerName = that.getOriginatingPartnerName();
            if (!strategy.equals(LocatorUtils.property(thisLocator, "originatingPartnerName", lhsOriginatingPartnerName), LocatorUtils.property(thatLocator, "originatingPartnerName", rhsOriginatingPartnerName), lhsOriginatingPartnerName, rhsOriginatingPartnerName)) {
                return false;
            }
        }
        {
            String lhsInformationSystemAcronymName;
            lhsInformationSystemAcronymName = this.getInformationSystemAcronymName();
            String rhsInformationSystemAcronymName;
            rhsInformationSystemAcronymName = that.getInformationSystemAcronymName();
            if (!strategy.equals(LocatorUtils.property(thisLocator, "informationSystemAcronymName", lhsInformationSystemAcronymName), LocatorUtils.property(thatLocator, "informationSystemAcronymName", rhsInformationSystemAcronymName), lhsInformationSystemAcronymName, rhsInformationSystemAcronymName)) {
                return false;
            }
        }
        {
            XMLGregorianCalendar lhsLastUpdatedDate;
            lhsLastUpdatedDate = this.getLastUpdatedDate();
            XMLGregorianCalendar rhsLastUpdatedDate;
            rhsLastUpdatedDate = that.getLastUpdatedDate();
            if (!strategy.equals(LocatorUtils.property(thisLocator, "lastUpdatedDate", lhsLastUpdatedDate), LocatorUtils.property(thatLocator, "lastUpdatedDate", rhsLastUpdatedDate), lhsLastUpdatedDate, rhsLastUpdatedDate)) {
                return false;
            }
        }
        return true;
    }

    public boolean equals(Object object) {
        final EqualsStrategy strategy = JAXBEqualsStrategy.INSTANCE;
        return equals(null, null, object, strategy);
    }

    public int hashCode(ObjectLocator locator, HashCodeStrategy strategy) {
        int currentHashCode = 1;
        {
            String theOriginatingPartnerName;
            theOriginatingPartnerName = this.getOriginatingPartnerName();
            currentHashCode = strategy.hashCode(LocatorUtils.property(locator, "originatingPartnerName", theOriginatingPartnerName), currentHashCode, theOriginatingPartnerName);
        }
        {
            String theInformationSystemAcronymName;
            theInformationSystemAcronymName = this.getInformationSystemAcronymName();
            currentHashCode = strategy.hashCode(LocatorUtils.property(locator, "informationSystemAcronymName", theInformationSystemAcronymName), currentHashCode, theInformationSystemAcronymName);
        }
        {
            XMLGregorianCalendar theLastUpdatedDate;
            theLastUpdatedDate = this.getLastUpdatedDate();
            currentHashCode = strategy.hashCode(LocatorUtils.property(locator, "lastUpdatedDate", theLastUpdatedDate), currentHashCode, theLastUpdatedDate);
        }
        return currentHashCode;
    }

    public int hashCode() {
        final HashCodeStrategy strategy = JAXBHashCodeStrategy.INSTANCE;
        return this.hashCode(null, strategy);
    }

}
