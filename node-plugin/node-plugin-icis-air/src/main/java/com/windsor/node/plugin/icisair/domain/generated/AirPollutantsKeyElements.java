//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v2.2.4 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2014.09.02 at 11:05:46 AM PDT 
//


package com.windsor.node.plugin.icisair.domain.generated;

import java.io.Serializable;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.MappedSuperclass;
import javax.persistence.Transient;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlSeeAlso;
import javax.xml.bind.annotation.XmlType;

import org.jvnet.jaxb2_commons.lang.Equals;
import org.jvnet.jaxb2_commons.lang.EqualsStrategy;
import org.jvnet.jaxb2_commons.lang.HashCode;
import org.jvnet.jaxb2_commons.lang.HashCodeStrategy;
import org.jvnet.jaxb2_commons.lang.JAXBEqualsStrategy;
import org.jvnet.jaxb2_commons.lang.JAXBHashCodeStrategy;
import org.jvnet.jaxb2_commons.locator.ObjectLocator;
import org.jvnet.jaxb2_commons.locator.util.LocatorUtils;


/**
 * <p>Java class for AirPollutantsKeyElements complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="AirPollutantsKeyElements">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;group ref="{http://www.exchangenetwork.net/schema/icis/5}AirPollutantsKeyElementsGroup"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "AirPollutantsKeyElements", propOrder = {
    "airFacilityIdentifier",
    "airPollutantsCode"
})
@XmlSeeAlso({
    AirPollutants.class
})
@MappedSuperclass
public class AirPollutantsKeyElements
    implements Serializable, Equals, HashCode
{

    private final static long serialVersionUID = 1L;
    @XmlElement(name = "AirFacilityIdentifier", required = true)
    protected String airFacilityIdentifier;
    @XmlElement(name = "AirPollutantsCode")
    protected long airPollutantsCode;

    /**
     * Gets the value of the airFacilityIdentifier property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    @Basic
    @Column(name = "FAC_IDENT", length = 18)
    public String getAirFacilityIdentifier() {
        return airFacilityIdentifier;
    }

    /**
     * Sets the value of the airFacilityIdentifier property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setAirFacilityIdentifier(String value) {
        this.airFacilityIdentifier = value;
    }

    @Transient
    public boolean isSetAirFacilityIdentifier() {
        return (this.airFacilityIdentifier!= null);
    }

    /**
     * Gets the value of the airPollutantsCode property.
     * 
     */
    @Basic
    @Column(name = "POLUTS_CODE", precision = 20, scale = 0)
    public long getAirPollutantsCode() {
        return airPollutantsCode;
    }

    /**
     * Sets the value of the airPollutantsCode property.
     * 
     */
    public void setAirPollutantsCode(long value) {
        this.airPollutantsCode = value;
    }

    @Transient
    public boolean isSetAirPollutantsCode() {
        return true;
    }

    public boolean equals(ObjectLocator thisLocator, ObjectLocator thatLocator, Object object, EqualsStrategy strategy) {
        if (!(object instanceof AirPollutantsKeyElements)) {
            return false;
        }
        if (this == object) {
            return true;
        }
        final AirPollutantsKeyElements that = ((AirPollutantsKeyElements) object);
        {
            String lhsAirFacilityIdentifier;
            lhsAirFacilityIdentifier = this.getAirFacilityIdentifier();
            String rhsAirFacilityIdentifier;
            rhsAirFacilityIdentifier = that.getAirFacilityIdentifier();
            if (!strategy.equals(LocatorUtils.property(thisLocator, "airFacilityIdentifier", lhsAirFacilityIdentifier), LocatorUtils.property(thatLocator, "airFacilityIdentifier", rhsAirFacilityIdentifier), lhsAirFacilityIdentifier, rhsAirFacilityIdentifier)) {
                return false;
            }
        }
        {
            long lhsAirPollutantsCode;
            lhsAirPollutantsCode = (this.isSetAirPollutantsCode()?this.getAirPollutantsCode(): 0L);
            long rhsAirPollutantsCode;
            rhsAirPollutantsCode = (that.isSetAirPollutantsCode()?that.getAirPollutantsCode(): 0L);
            if (!strategy.equals(LocatorUtils.property(thisLocator, "airPollutantsCode", lhsAirPollutantsCode), LocatorUtils.property(thatLocator, "airPollutantsCode", rhsAirPollutantsCode), lhsAirPollutantsCode, rhsAirPollutantsCode)) {
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
            String theAirFacilityIdentifier;
            theAirFacilityIdentifier = this.getAirFacilityIdentifier();
            currentHashCode = strategy.hashCode(LocatorUtils.property(locator, "airFacilityIdentifier", theAirFacilityIdentifier), currentHashCode, theAirFacilityIdentifier);
        }
        {
            long theAirPollutantsCode;
            theAirPollutantsCode = (this.isSetAirPollutantsCode()?this.getAirPollutantsCode(): 0L);
            currentHashCode = strategy.hashCode(LocatorUtils.property(locator, "airPollutantsCode", theAirPollutantsCode), currentHashCode, theAirPollutantsCode);
        }
        return currentHashCode;
    }

    public int hashCode() {
        final HashCodeStrategy strategy = JAXBHashCodeStrategy.INSTANCE;
        return this.hashCode(null, strategy);
    }

}
