//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v2.2.4 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2013.08.26 at 02:36:56 PM PDT 
//


package com.windsor.node.plugin.ic.fixeddomain;

import java.io.Serializable;
import javax.persistence.Basic;
import javax.persistence.Column;
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
 * <p>Java class for LandParcelDataType complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="LandParcelDataType">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/IC/1}LandParcelNamingSchema"/>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/IC/1}LandParcelSource"/>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/IC/1}LandParcelIdentifier"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "LandParcelDataType", propOrder = {
    "landParcelNamingSchema",
    "landParcelSource",
    "landParcelIdentifier"
})
@Entity(name = "LandParcelDataType")
@Table(name = "IC_LAND_PARCEL")
@Inheritance(strategy = InheritanceType.JOINED)
public class LandParcelDataType
    implements Serializable, Equals, HashCode
{

    private final static long serialVersionUID = 1L;
    @XmlElement(name = "LandParcelNamingSchema", required = true)
    protected String landParcelNamingSchema;
    @XmlElement(name = "LandParcelSource", required = true)
    protected String landParcelSource;
    @XmlElement(name = "LandParcelIdentifier", required = true)
    protected String landParcelIdentifier;
    @XmlTransient
    protected String dbid;
    /*@XmlTransient
    public ICLocationDataType parent;
    @OneToOne(mappedBy="landParcel")
    public ICLocationDataType getParent()
    {
        return parent;
    }
    public void setParent(ICLocationDataType v)
    {
        parent = v;
    }*/

    
    /**
     * Gets the value of the landParcelNamingSchema property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    @Basic
    @Column(name = "LAND_PARCEL_NAMING_SCHEMA", length = 255)
    public String getLandParcelNamingSchema() {
        return landParcelNamingSchema;
    }

    /**
     * Sets the value of the landParcelNamingSchema property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setLandParcelNamingSchema(String value) {
        this.landParcelNamingSchema = value;
    }

    @Transient
    public boolean isSetLandParcelNamingSchema() {
        return (this.landParcelNamingSchema!= null);
    }

    /**
     * Gets the value of the landParcelSource property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    @Basic
    @Column(name = "LAND_PARCEL_SRC", length = 255)
    public String getLandParcelSource() {
        return landParcelSource;
    }

    /**
     * Sets the value of the landParcelSource property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setLandParcelSource(String value) {
        this.landParcelSource = value;
    }

    @Transient
    public boolean isSetLandParcelSource() {
        return (this.landParcelSource!= null);
    }

    /**
     * Gets the value of the landParcelIdentifier property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    @Basic
    @Column(name = "LAND_PARCEL_IDEN", length = 255)
    public String getLandParcelIdentifier() {
        return landParcelIdentifier;
    }

    /**
     * Sets the value of the landParcelIdentifier property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setLandParcelIdentifier(String value) {
        this.landParcelIdentifier = value;
    }

    @Transient
    public boolean isSetLandParcelIdentifier() {
        return (this.landParcelIdentifier!= null);
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
    @Column(name = "IC_LAND_PARCEL_ID")
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
        if (!(object instanceof LandParcelDataType)) {
            return false;
        }
        if (this == object) {
            return true;
        }
        final LandParcelDataType that = ((LandParcelDataType) object);
        {
            String lhsLandParcelNamingSchema;
            lhsLandParcelNamingSchema = this.getLandParcelNamingSchema();
            String rhsLandParcelNamingSchema;
            rhsLandParcelNamingSchema = that.getLandParcelNamingSchema();
            if (!strategy.equals(LocatorUtils.property(thisLocator, "landParcelNamingSchema", lhsLandParcelNamingSchema), LocatorUtils.property(thatLocator, "landParcelNamingSchema", rhsLandParcelNamingSchema), lhsLandParcelNamingSchema, rhsLandParcelNamingSchema)) {
                return false;
            }
        }
        {
            String lhsLandParcelSource;
            lhsLandParcelSource = this.getLandParcelSource();
            String rhsLandParcelSource;
            rhsLandParcelSource = that.getLandParcelSource();
            if (!strategy.equals(LocatorUtils.property(thisLocator, "landParcelSource", lhsLandParcelSource), LocatorUtils.property(thatLocator, "landParcelSource", rhsLandParcelSource), lhsLandParcelSource, rhsLandParcelSource)) {
                return false;
            }
        }
        {
            String lhsLandParcelIdentifier;
            lhsLandParcelIdentifier = this.getLandParcelIdentifier();
            String rhsLandParcelIdentifier;
            rhsLandParcelIdentifier = that.getLandParcelIdentifier();
            if (!strategy.equals(LocatorUtils.property(thisLocator, "landParcelIdentifier", lhsLandParcelIdentifier), LocatorUtils.property(thatLocator, "landParcelIdentifier", rhsLandParcelIdentifier), lhsLandParcelIdentifier, rhsLandParcelIdentifier)) {
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
            String theLandParcelNamingSchema;
            theLandParcelNamingSchema = this.getLandParcelNamingSchema();
            currentHashCode = strategy.hashCode(LocatorUtils.property(locator, "landParcelNamingSchema", theLandParcelNamingSchema), currentHashCode, theLandParcelNamingSchema);
        }
        {
            String theLandParcelSource;
            theLandParcelSource = this.getLandParcelSource();
            currentHashCode = strategy.hashCode(LocatorUtils.property(locator, "landParcelSource", theLandParcelSource), currentHashCode, theLandParcelSource);
        }
        {
            String theLandParcelIdentifier;
            theLandParcelIdentifier = this.getLandParcelIdentifier();
            currentHashCode = strategy.hashCode(LocatorUtils.property(locator, "landParcelIdentifier", theLandParcelIdentifier), currentHashCode, theLandParcelIdentifier);
        }
        return currentHashCode;
    }

    public int hashCode() {
        final HashCodeStrategy strategy = JAXBHashCodeStrategy.INSTANCE;
        return this.hashCode(null, strategy);
    }

}
