//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v2.2.4 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2013.08.26 at 02:36:56 PM PDT 
//


package com.windsor.node.plugin.ic.fixeddomain;

import java.io.Serializable;
import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Embeddable;
import javax.persistence.Embedded;
import javax.persistence.Transient;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
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
 * <p>Java class for StateIdentityDataType complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="StateIdentityDataType">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/IC/1}StateCode" minOccurs="0"/>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/IC/1}StateCodeListIdentifier" minOccurs="0"/>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/IC/1}StateName" minOccurs="0"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "StateIdentityDataType", propOrder = {
    "stateCode",
    "stateCodeListIdentifier",
    "stateName"
})
@Embeddable
public class StateIdentityDataType
    implements Serializable, Equals, HashCode
{

    private final static long serialVersionUID = 1L;
    @XmlElement(name = "StateCode")
    protected String stateCode;
    @XmlElement(name = "StateCodeListIdentifier")
    protected StateCodeListIdentifierDataType stateCodeListIdentifier;
    @XmlElement(name = "StateName")
    protected String stateName;

    /**
     * Gets the value of the stateCode property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    @Basic
    @Column(name = "ST_CODE", length = 255)
    public String getStateCode() {
        return stateCode;
    }

    /**
     * Sets the value of the stateCode property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setStateCode(String value) {
        this.stateCode = value;
    }

    @Transient
    public boolean isSetStateCode() {
        return (this.stateCode!= null);
    }

    /**
     * Gets the value of the stateCodeListIdentifier property.
     * 
     * @return
     *     possible object is
     *     {@link StateCodeListIdentifierDataType }
     *     
     */
    @Embedded
    @AttributeOverrides({
        @AttributeOverride(name = "value", column = @Column(name = "VALUE", length = 255)),
        @AttributeOverride(name = "codeListVersionIdentifier", column = @Column(name = "CODE_LST_IDEN", length = 255)),
        @AttributeOverride(name = "codeListVersionAgencyIdentifier", column = @Column(name = "CODE_LST_AGENCY_IDEN", length = 255))
    })
    public StateCodeListIdentifierDataType getStateCodeListIdentifier() {
        return stateCodeListIdentifier;
    }

    /**
     * Sets the value of the stateCodeListIdentifier property.
     * 
     * @param value
     *     allowed object is
     *     {@link StateCodeListIdentifierDataType }
     *     
     */
    public void setStateCodeListIdentifier(StateCodeListIdentifierDataType value) {
        this.stateCodeListIdentifier = value;
    }

    @Transient
    public boolean isSetStateCodeListIdentifier() {
        return (this.stateCodeListIdentifier!= null);
    }

    /**
     * Gets the value of the stateName property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    @Basic
    @Column(name = "ST_NAME", length = 255)
    public String getStateName() {
        return stateName;
    }

    /**
     * Sets the value of the stateName property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setStateName(String value) {
        this.stateName = value;
    }

    @Transient
    public boolean isSetStateName() {
        return (this.stateName!= null);
    }

    public boolean equals(ObjectLocator thisLocator, ObjectLocator thatLocator, Object object, EqualsStrategy strategy) {
        if (!(object instanceof StateIdentityDataType)) {
            return false;
        }
        if (this == object) {
            return true;
        }
        final StateIdentityDataType that = ((StateIdentityDataType) object);
        {
            String lhsStateCode;
            lhsStateCode = this.getStateCode();
            String rhsStateCode;
            rhsStateCode = that.getStateCode();
            if (!strategy.equals(LocatorUtils.property(thisLocator, "stateCode", lhsStateCode), LocatorUtils.property(thatLocator, "stateCode", rhsStateCode), lhsStateCode, rhsStateCode)) {
                return false;
            }
        }
        {
            StateCodeListIdentifierDataType lhsStateCodeListIdentifier;
            lhsStateCodeListIdentifier = this.getStateCodeListIdentifier();
            StateCodeListIdentifierDataType rhsStateCodeListIdentifier;
            rhsStateCodeListIdentifier = that.getStateCodeListIdentifier();
            if (!strategy.equals(LocatorUtils.property(thisLocator, "stateCodeListIdentifier", lhsStateCodeListIdentifier), LocatorUtils.property(thatLocator, "stateCodeListIdentifier", rhsStateCodeListIdentifier), lhsStateCodeListIdentifier, rhsStateCodeListIdentifier)) {
                return false;
            }
        }
        {
            String lhsStateName;
            lhsStateName = this.getStateName();
            String rhsStateName;
            rhsStateName = that.getStateName();
            if (!strategy.equals(LocatorUtils.property(thisLocator, "stateName", lhsStateName), LocatorUtils.property(thatLocator, "stateName", rhsStateName), lhsStateName, rhsStateName)) {
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
            String theStateCode;
            theStateCode = this.getStateCode();
            currentHashCode = strategy.hashCode(LocatorUtils.property(locator, "stateCode", theStateCode), currentHashCode, theStateCode);
        }
        {
            StateCodeListIdentifierDataType theStateCodeListIdentifier;
            theStateCodeListIdentifier = this.getStateCodeListIdentifier();
            currentHashCode = strategy.hashCode(LocatorUtils.property(locator, "stateCodeListIdentifier", theStateCodeListIdentifier), currentHashCode, theStateCodeListIdentifier);
        }
        {
            String theStateName;
            theStateName = this.getStateName();
            currentHashCode = strategy.hashCode(LocatorUtils.property(locator, "stateName", theStateName), currentHashCode, theStateName);
        }
        return currentHashCode;
    }

    public int hashCode() {
        final HashCodeStrategy strategy = JAXBHashCodeStrategy.INSTANCE;
        return this.hashCode(null, strategy);
    }

}
