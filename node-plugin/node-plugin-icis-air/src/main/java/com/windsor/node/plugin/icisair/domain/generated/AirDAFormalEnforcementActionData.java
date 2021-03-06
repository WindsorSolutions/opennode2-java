//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v2.2.4 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2014.09.02 at 11:05:46 AM PDT 
//


package com.windsor.node.plugin.icisair.domain.generated;

import java.io.Serializable;

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlTransient;
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
 * <p>Java class for AirDAFormalEnforcementActionData complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="AirDAFormalEnforcementActionData">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/icis/5}TransactionHeader"/>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/icis/5}AirDAFormalEnforcementAction"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "AirDAFormalEnforcementActionData", propOrder = {
    "transactionHeader",
    "airDAFormalEnforcementAction"
})
@Entity(name = "AirDAFormalEnforcementActionData")
@Table(name = "ICA_DA_FRML_ENFRC_ACTN")
@Inheritance(strategy = InheritanceType.JOINED)
public class AirDAFormalEnforcementActionData
    implements Serializable, Equals, HashCode
{

    private final static long serialVersionUID = 1L;
    @XmlElement(name = "TransactionHeader", required = true)
    protected TransactionHeader transactionHeader;
    @XmlElement(name = "AirDAFormalEnforcementAction", required = true)
    protected AirDAFormalEnforcementAction airDAFormalEnforcementAction;
    @XmlTransient
    protected String dbid;

    /**
     * Gets the value of the transactionHeader property.
     * 
     * @return
     *     possible object is
     *     {@link TransactionHeader }
     *     
     */
    @Embedded
    @AttributeOverrides({
        @AttributeOverride(name = "transactionType", column = @Column(name = "TRANSACTION_TYPE", columnDefinition = "char(1)", length = 1)),
        @AttributeOverride(name = "transactionTimestamp", column = @Column(name = "TRANSACTION_TIMESTAMP"))
    })
    public TransactionHeader getTransactionHeader() {
        return transactionHeader;
    }

    /**
     * Sets the value of the transactionHeader property.
     * 
     * @param value
     *     allowed object is
     *     {@link TransactionHeader }
     *     
     */
    public void setTransactionHeader(TransactionHeader value) {
        this.transactionHeader = value;
    }

    @Transient
    public boolean isSetTransactionHeader() {
        return (this.transactionHeader!= null);
    }

    /**
     * Gets the value of the airDAFormalEnforcementAction property.
     * 
     * @return
     *     possible object is
     *     {@link AirDAFormalEnforcementAction }
     *     
     */
    @Embedded
    public AirDAFormalEnforcementAction getAirDAFormalEnforcementAction() {
        return airDAFormalEnforcementAction;
    }

    /**
     * Sets the value of the airDAFormalEnforcementAction property.
     * 
     * @param value
     *     allowed object is
     *     {@link AirDAFormalEnforcementAction }
     *     
     */
    public void setAirDAFormalEnforcementAction(AirDAFormalEnforcementAction value) {
        this.airDAFormalEnforcementAction = value;
    }

    @Transient
    public boolean isSetAirDAFormalEnforcementAction() {
        return (this.airDAFormalEnforcementAction!= null);
    }

    /**
     * 
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    @Id
    @Column(name = "ICA_DA_FRML_ENFRC_ACTN_ID")
    public String getDbid() {
        return dbid;
    }

    /**
     * 
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setDbid(String value) {
        this.dbid = value;
    }

    public boolean equals(ObjectLocator thisLocator, ObjectLocator thatLocator, Object object, EqualsStrategy strategy) {
        if (!(object instanceof AirDAFormalEnforcementActionData)) {
            return false;
        }
        if (this == object) {
            return true;
        }
        final AirDAFormalEnforcementActionData that = ((AirDAFormalEnforcementActionData) object);
        {
            TransactionHeader lhsTransactionHeader;
            lhsTransactionHeader = this.getTransactionHeader();
            TransactionHeader rhsTransactionHeader;
            rhsTransactionHeader = that.getTransactionHeader();
            if (!strategy.equals(LocatorUtils.property(thisLocator, "transactionHeader", lhsTransactionHeader), LocatorUtils.property(thatLocator, "transactionHeader", rhsTransactionHeader), lhsTransactionHeader, rhsTransactionHeader)) {
                return false;
            }
        }
        {
            AirDAFormalEnforcementAction lhsAirDAFormalEnforcementAction;
            lhsAirDAFormalEnforcementAction = this.getAirDAFormalEnforcementAction();
            AirDAFormalEnforcementAction rhsAirDAFormalEnforcementAction;
            rhsAirDAFormalEnforcementAction = that.getAirDAFormalEnforcementAction();
            if (!strategy.equals(LocatorUtils.property(thisLocator, "airDAFormalEnforcementAction", lhsAirDAFormalEnforcementAction), LocatorUtils.property(thatLocator, "airDAFormalEnforcementAction", rhsAirDAFormalEnforcementAction), lhsAirDAFormalEnforcementAction, rhsAirDAFormalEnforcementAction)) {
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
            TransactionHeader theTransactionHeader;
            theTransactionHeader = this.getTransactionHeader();
            currentHashCode = strategy.hashCode(LocatorUtils.property(locator, "transactionHeader", theTransactionHeader), currentHashCode, theTransactionHeader);
        }
        {
            AirDAFormalEnforcementAction theAirDAFormalEnforcementAction;
            theAirDAFormalEnforcementAction = this.getAirDAFormalEnforcementAction();
            currentHashCode = strategy.hashCode(LocatorUtils.property(locator, "airDAFormalEnforcementAction", theAirDAFormalEnforcementAction), currentHashCode, theAirDAFormalEnforcementAction);
        }
        return currentHashCode;
    }

    public int hashCode() {
        final HashCodeStrategy strategy = JAXBHashCodeStrategy.INSTANCE;
        return this.hashCode(null, strategy);
    }

}
