//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v2.2.4 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2014.09.02 at 11:05:46 AM PDT 
//


package com.windsor.node.plugin.icisair.domain.generated;

import java.io.Serializable;
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
 * <p>Java class for ErrorReportDataType complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="ErrorReportDataType">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/icis/5}ErrorCode" minOccurs="0"/>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/icis/5}ErrorTypeCode"/>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/icis/5}ErrorDescription"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ErrorReportDataType", propOrder = {
    "errorCode",
    "errorTypeCode",
    "errorDescription"
})
public class ErrorReportDataType
    implements Serializable, Equals, HashCode
{

    private final static long serialVersionUID = 1L;
    @XmlElement(name = "ErrorCode")
    protected String errorCode;
    @XmlElement(name = "ErrorTypeCode", required = true)
    protected ErrorTypeCodeDataType errorTypeCode;
    @XmlElement(name = "ErrorDescription", required = true)
    protected String errorDescription;

    /**
     * Gets the value of the errorCode property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getErrorCode() {
        return errorCode;
    }

    /**
     * Sets the value of the errorCode property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setErrorCode(String value) {
        this.errorCode = value;
    }

    public boolean isSetErrorCode() {
        return (this.errorCode!= null);
    }

    /**
     * Gets the value of the errorTypeCode property.
     * 
     * @return
     *     possible object is
     *     {@link ErrorTypeCodeDataType }
     *     
     */
    public ErrorTypeCodeDataType getErrorTypeCode() {
        return errorTypeCode;
    }

    /**
     * Sets the value of the errorTypeCode property.
     * 
     * @param value
     *     allowed object is
     *     {@link ErrorTypeCodeDataType }
     *     
     */
    public void setErrorTypeCode(ErrorTypeCodeDataType value) {
        this.errorTypeCode = value;
    }

    public boolean isSetErrorTypeCode() {
        return (this.errorTypeCode!= null);
    }

    /**
     * Gets the value of the errorDescription property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getErrorDescription() {
        return errorDescription;
    }

    /**
     * Sets the value of the errorDescription property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setErrorDescription(String value) {
        this.errorDescription = value;
    }

    public boolean isSetErrorDescription() {
        return (this.errorDescription!= null);
    }

    public boolean equals(ObjectLocator thisLocator, ObjectLocator thatLocator, Object object, EqualsStrategy strategy) {
        if (!(object instanceof ErrorReportDataType)) {
            return false;
        }
        if (this == object) {
            return true;
        }
        final ErrorReportDataType that = ((ErrorReportDataType) object);
        {
            String lhsErrorCode;
            lhsErrorCode = this.getErrorCode();
            String rhsErrorCode;
            rhsErrorCode = that.getErrorCode();
            if (!strategy.equals(LocatorUtils.property(thisLocator, "errorCode", lhsErrorCode), LocatorUtils.property(thatLocator, "errorCode", rhsErrorCode), lhsErrorCode, rhsErrorCode)) {
                return false;
            }
        }
        {
            ErrorTypeCodeDataType lhsErrorTypeCode;
            lhsErrorTypeCode = this.getErrorTypeCode();
            ErrorTypeCodeDataType rhsErrorTypeCode;
            rhsErrorTypeCode = that.getErrorTypeCode();
            if (!strategy.equals(LocatorUtils.property(thisLocator, "errorTypeCode", lhsErrorTypeCode), LocatorUtils.property(thatLocator, "errorTypeCode", rhsErrorTypeCode), lhsErrorTypeCode, rhsErrorTypeCode)) {
                return false;
            }
        }
        {
            String lhsErrorDescription;
            lhsErrorDescription = this.getErrorDescription();
            String rhsErrorDescription;
            rhsErrorDescription = that.getErrorDescription();
            if (!strategy.equals(LocatorUtils.property(thisLocator, "errorDescription", lhsErrorDescription), LocatorUtils.property(thatLocator, "errorDescription", rhsErrorDescription), lhsErrorDescription, rhsErrorDescription)) {
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
            String theErrorCode;
            theErrorCode = this.getErrorCode();
            currentHashCode = strategy.hashCode(LocatorUtils.property(locator, "errorCode", theErrorCode), currentHashCode, theErrorCode);
        }
        {
            ErrorTypeCodeDataType theErrorTypeCode;
            theErrorTypeCode = this.getErrorTypeCode();
            currentHashCode = strategy.hashCode(LocatorUtils.property(locator, "errorTypeCode", theErrorTypeCode), currentHashCode, theErrorTypeCode);
        }
        {
            String theErrorDescription;
            theErrorDescription = this.getErrorDescription();
            currentHashCode = strategy.hashCode(LocatorUtils.property(locator, "errorDescription", theErrorDescription), currentHashCode, theErrorDescription);
        }
        return currentHashCode;
    }

    public int hashCode() {
        final HashCodeStrategy strategy = JAXBHashCodeStrategy.INSTANCE;
        return this.hashCode(null, strategy);
    }

}
