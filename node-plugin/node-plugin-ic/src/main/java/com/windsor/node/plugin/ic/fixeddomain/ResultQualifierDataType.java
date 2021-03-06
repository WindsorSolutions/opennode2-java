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
 * <p>Java class for ResultQualifierDataType complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="ResultQualifierDataType">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/IC/1}ResultQualifierCode" minOccurs="0"/>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/IC/1}ResultQualifierCodeListIdentifier" minOccurs="0"/>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/IC/1}ResultQualifierName" minOccurs="0"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ResultQualifierDataType", propOrder = {
    "resultQualifierCode",
    "resultQualifierCodeListIdentifier",
    "resultQualifierName"
})
@Embeddable
public class ResultQualifierDataType
    implements Serializable, Equals, HashCode
{

    private final static long serialVersionUID = 1L;
    @XmlElement(name = "ResultQualifierCode")
    protected String resultQualifierCode;
    @XmlElement(name = "ResultQualifierCodeListIdentifier")
    protected ResultQualifierCodeListIdentifierDataType resultQualifierCodeListIdentifier;
    @XmlElement(name = "ResultQualifierName")
    protected String resultQualifierName;

    /**
     * Gets the value of the resultQualifierCode property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    @Basic
    @Column(name = "RESULT_QUAL_CODE", length = 255)
    public String getResultQualifierCode() {
        return resultQualifierCode;
    }

    /**
     * Sets the value of the resultQualifierCode property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setResultQualifierCode(String value) {
        this.resultQualifierCode = value;
    }

    @Transient
    public boolean isSetResultQualifierCode() {
        return (this.resultQualifierCode!= null);
    }

    /**
     * Gets the value of the resultQualifierCodeListIdentifier property.
     * 
     * @return
     *     possible object is
     *     {@link ResultQualifierCodeListIdentifierDataType }
     *     
     */
    @Embedded
    @AttributeOverrides({
        @AttributeOverride(name = "value", column = @Column(name = "VALUE", length = 255)),
        @AttributeOverride(name = "codeListVersionIdentifier", column = @Column(name = "CODE_LST_IDEN", length = 255)),
        @AttributeOverride(name = "codeListVersionAgencyIdentifier", column = @Column(name = "CODE_LST_AGENCY_IDEN", length = 255))
    })
    public ResultQualifierCodeListIdentifierDataType getResultQualifierCodeListIdentifier() {
        return resultQualifierCodeListIdentifier;
    }

    /**
     * Sets the value of the resultQualifierCodeListIdentifier property.
     * 
     * @param value
     *     allowed object is
     *     {@link ResultQualifierCodeListIdentifierDataType }
     *     
     */
    public void setResultQualifierCodeListIdentifier(ResultQualifierCodeListIdentifierDataType value) {
        this.resultQualifierCodeListIdentifier = value;
    }

    @Transient
    public boolean isSetResultQualifierCodeListIdentifier() {
        return (this.resultQualifierCodeListIdentifier!= null);
    }

    /**
     * Gets the value of the resultQualifierName property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    @Basic
    @Column(name = "RESULT_QUAL_NAME", length = 255)
    public String getResultQualifierName() {
        return resultQualifierName;
    }

    /**
     * Sets the value of the resultQualifierName property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setResultQualifierName(String value) {
        this.resultQualifierName = value;
    }

    @Transient
    public boolean isSetResultQualifierName() {
        return (this.resultQualifierName!= null);
    }

    public boolean equals(ObjectLocator thisLocator, ObjectLocator thatLocator, Object object, EqualsStrategy strategy) {
        if (!(object instanceof ResultQualifierDataType)) {
            return false;
        }
        if (this == object) {
            return true;
        }
        final ResultQualifierDataType that = ((ResultQualifierDataType) object);
        {
            String lhsResultQualifierCode;
            lhsResultQualifierCode = this.getResultQualifierCode();
            String rhsResultQualifierCode;
            rhsResultQualifierCode = that.getResultQualifierCode();
            if (!strategy.equals(LocatorUtils.property(thisLocator, "resultQualifierCode", lhsResultQualifierCode), LocatorUtils.property(thatLocator, "resultQualifierCode", rhsResultQualifierCode), lhsResultQualifierCode, rhsResultQualifierCode)) {
                return false;
            }
        }
        {
            ResultQualifierCodeListIdentifierDataType lhsResultQualifierCodeListIdentifier;
            lhsResultQualifierCodeListIdentifier = this.getResultQualifierCodeListIdentifier();
            ResultQualifierCodeListIdentifierDataType rhsResultQualifierCodeListIdentifier;
            rhsResultQualifierCodeListIdentifier = that.getResultQualifierCodeListIdentifier();
            if (!strategy.equals(LocatorUtils.property(thisLocator, "resultQualifierCodeListIdentifier", lhsResultQualifierCodeListIdentifier), LocatorUtils.property(thatLocator, "resultQualifierCodeListIdentifier", rhsResultQualifierCodeListIdentifier), lhsResultQualifierCodeListIdentifier, rhsResultQualifierCodeListIdentifier)) {
                return false;
            }
        }
        {
            String lhsResultQualifierName;
            lhsResultQualifierName = this.getResultQualifierName();
            String rhsResultQualifierName;
            rhsResultQualifierName = that.getResultQualifierName();
            if (!strategy.equals(LocatorUtils.property(thisLocator, "resultQualifierName", lhsResultQualifierName), LocatorUtils.property(thatLocator, "resultQualifierName", rhsResultQualifierName), lhsResultQualifierName, rhsResultQualifierName)) {
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
            String theResultQualifierCode;
            theResultQualifierCode = this.getResultQualifierCode();
            currentHashCode = strategy.hashCode(LocatorUtils.property(locator, "resultQualifierCode", theResultQualifierCode), currentHashCode, theResultQualifierCode);
        }
        {
            ResultQualifierCodeListIdentifierDataType theResultQualifierCodeListIdentifier;
            theResultQualifierCodeListIdentifier = this.getResultQualifierCodeListIdentifier();
            currentHashCode = strategy.hashCode(LocatorUtils.property(locator, "resultQualifierCodeListIdentifier", theResultQualifierCodeListIdentifier), currentHashCode, theResultQualifierCodeListIdentifier);
        }
        {
            String theResultQualifierName;
            theResultQualifierName = this.getResultQualifierName();
            currentHashCode = strategy.hashCode(LocatorUtils.property(locator, "resultQualifierName", theResultQualifierName), currentHashCode, theResultQualifierName);
        }
        return currentHashCode;
    }

    public int hashCode() {
        final HashCodeStrategy strategy = JAXBHashCodeStrategy.INSTANCE;
        return this.hashCode(null, strategy);
    }

}
