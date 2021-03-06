//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v2.2.4 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2013.08.26 at 02:36:56 PM PDT 
//


package com.windsor.node.plugin.ic.fixeddomain;

import java.io.Serializable;
import java.math.BigInteger;
import java.util.Date;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlTransient;
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
 * <p>Java class for GeographicLocationDescriptionDataType complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="GeographicLocationDescriptionDataType">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/IC/1}LatitudeMeasure" minOccurs="0"/>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/IC/1}LongitudeMeasure" minOccurs="0"/>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/IC/1}SourceMapScaleNumber" minOccurs="0"/>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/IC/1}HorizontalAccuracyMeasure" minOccurs="0"/>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/IC/1}HorizontalCollectionMethod" minOccurs="0"/>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/IC/1}GeographicReferencePoint" minOccurs="0"/>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/IC/1}HorizontalReferenceDatum" minOccurs="0"/>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/IC/1}DataCollectionDate" minOccurs="0"/>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/IC/1}LocationCommentsText" minOccurs="0"/>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/IC/1}VerticalMeasure" minOccurs="0"/>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/IC/1}VerticalCollectionMethod" minOccurs="0"/>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/IC/1}VerticalReferenceDatum" minOccurs="0"/>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/IC/1}VerificationMethod" minOccurs="0"/>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/IC/1}CoordinateDataSource" minOccurs="0"/>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/IC/1}GeometricType" minOccurs="0"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "GeographicLocationDescriptionDataType", propOrder = {
    "latitudeMeasure",
    "longitudeMeasure",
    "sourceMapScaleNumber",
    "horizontalAccuracyMeasure",
    "horizontalCollectionMethod",
    "geographicReferencePoint",
    "horizontalReferenceDatum",
    "dataCollectionDate",
    "locationCommentsText",
    "verticalMeasure",
    "verticalCollectionMethod",
    "verticalReferenceDatum",
    "verificationMethod",
    "coordinateDataSource",
    "geometricType"
})
public class GeographicLocationDescriptionDataType
    implements Serializable, Equals, HashCode
{

    private final static long serialVersionUID = 1L;
    @XmlElement(name = "LatitudeMeasure")
    protected String latitudeMeasure;
    @XmlElement(name = "LongitudeMeasure")
    protected String longitudeMeasure;
    @XmlElement(name = "SourceMapScaleNumber")
    protected BigInteger sourceMapScaleNumber;
    @XmlElement(name = "HorizontalAccuracyMeasure")
    protected MeasureDataType horizontalAccuracyMeasure;
    @XmlElement(name = "HorizontalCollectionMethod")
    protected ReferenceMethodDataType horizontalCollectionMethod;
    @XmlElement(name = "GeographicReferencePoint")
    protected GeographicReferencePointDataType geographicReferencePoint;
    @XmlElement(name = "HorizontalReferenceDatum")
    protected GeographicReferenceDatumDataType horizontalReferenceDatum;
    @XmlElement(name = "DataCollectionDate")
    protected XMLGregorianCalendar dataCollectionDate;
    @XmlElement(name = "LocationCommentsText")
    protected String locationCommentsText;
    @XmlElement(name = "VerticalMeasure")
    protected MeasureDataType verticalMeasure;
    @XmlElement(name = "VerticalCollectionMethod")
    protected ReferenceMethodDataType verticalCollectionMethod;
    @XmlElement(name = "VerticalReferenceDatum")
    protected GeographicReferenceDatumDataType verticalReferenceDatum;
    @XmlElement(name = "VerificationMethod")
    protected ReferenceMethodDataType verificationMethod;
    @XmlElement(name = "CoordinateDataSource")
    protected CoordinateDataSourceDataType coordinateDataSource;
    @XmlElement(name = "GeometricType")
    protected GeometricTypeDataType geometricType;
    @XmlTransient
    protected String dbid;

    /**
     * Gets the value of the latitudeMeasure property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getLatitudeMeasure() {
        return latitudeMeasure;
    }

    /**
     * Sets the value of the latitudeMeasure property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setLatitudeMeasure(String value) {
        this.latitudeMeasure = value;
    }

    public boolean isSetLatitudeMeasure() {
        return (this.latitudeMeasure!= null);
    }

    /**
     * Gets the value of the longitudeMeasure property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getLongitudeMeasure() {
        return longitudeMeasure;
    }

    /**
     * Sets the value of the longitudeMeasure property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setLongitudeMeasure(String value) {
        this.longitudeMeasure = value;
    }

    public boolean isSetLongitudeMeasure() {
        return (this.longitudeMeasure!= null);
    }

    /**
     * Gets the value of the sourceMapScaleNumber property.
     * 
     * @return
     *     possible object is
     *     {@link BigInteger }
     *     
     */
    public BigInteger getSourceMapScaleNumber() {
        return sourceMapScaleNumber;
    }

    /**
     * Sets the value of the sourceMapScaleNumber property.
     * 
     * @param value
     *     allowed object is
     *     {@link BigInteger }
     *     
     */
    public void setSourceMapScaleNumber(BigInteger value) {
        this.sourceMapScaleNumber = value;
    }

    public boolean isSetSourceMapScaleNumber() {
        return (this.sourceMapScaleNumber!= null);
    }

    /**
     * Gets the value of the horizontalAccuracyMeasure property.
     * 
     * @return
     *     possible object is
     *     {@link MeasureDataType }
     *     
     */
    public MeasureDataType getHorizontalAccuracyMeasure() {
        return horizontalAccuracyMeasure;
    }

    /**
     * Sets the value of the horizontalAccuracyMeasure property.
     * 
     * @param value
     *     allowed object is
     *     {@link MeasureDataType }
     *     
     */
    public void setHorizontalAccuracyMeasure(MeasureDataType value) {
        this.horizontalAccuracyMeasure = value;
    }

    public boolean isSetHorizontalAccuracyMeasure() {
        return (this.horizontalAccuracyMeasure!= null);
    }

    /**
     * Gets the value of the horizontalCollectionMethod property.
     * 
     * @return
     *     possible object is
     *     {@link ReferenceMethodDataType }
     *     
     */
    public ReferenceMethodDataType getHorizontalCollectionMethod() {
        return horizontalCollectionMethod;
    }

    /**
     * Sets the value of the horizontalCollectionMethod property.
     * 
     * @param value
     *     allowed object is
     *     {@link ReferenceMethodDataType }
     *     
     */
    public void setHorizontalCollectionMethod(ReferenceMethodDataType value) {
        this.horizontalCollectionMethod = value;
    }

    public boolean isSetHorizontalCollectionMethod() {
        return (this.horizontalCollectionMethod!= null);
    }

    /**
     * Gets the value of the geographicReferencePoint property.
     * 
     * @return
     *     possible object is
     *     {@link GeographicReferencePointDataType }
     *     
     */
    public GeographicReferencePointDataType getGeographicReferencePoint() {
        return geographicReferencePoint;
    }

    /**
     * Sets the value of the geographicReferencePoint property.
     * 
     * @param value
     *     allowed object is
     *     {@link GeographicReferencePointDataType }
     *     
     */
    public void setGeographicReferencePoint(GeographicReferencePointDataType value) {
        this.geographicReferencePoint = value;
    }

    public boolean isSetGeographicReferencePoint() {
        return (this.geographicReferencePoint!= null);
    }

    /**
     * Gets the value of the horizontalReferenceDatum property.
     * 
     * @return
     *     possible object is
     *     {@link GeographicReferenceDatumDataType }
     *     
     */
    public GeographicReferenceDatumDataType getHorizontalReferenceDatum() {
        return horizontalReferenceDatum;
    }

    /**
     * Sets the value of the horizontalReferenceDatum property.
     * 
     * @param value
     *     allowed object is
     *     {@link GeographicReferenceDatumDataType }
     *     
     */
    public void setHorizontalReferenceDatum(GeographicReferenceDatumDataType value) {
        this.horizontalReferenceDatum = value;
    }

    public boolean isSetHorizontalReferenceDatum() {
        return (this.horizontalReferenceDatum!= null);
    }

    /**
     * Gets the value of the dataCollectionDate property.
     * 
     * @return
     *     possible object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public XMLGregorianCalendar getDataCollectionDate() {
        return dataCollectionDate;
    }

    /**
     * Sets the value of the dataCollectionDate property.
     * 
     * @param value
     *     allowed object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public void setDataCollectionDate(XMLGregorianCalendar value) {
        this.dataCollectionDate = value;
    }

    public boolean isSetDataCollectionDate() {
        return (this.dataCollectionDate!= null);
    }

    /**
     * Gets the value of the locationCommentsText property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getLocationCommentsText() {
        return locationCommentsText;
    }

    /**
     * Sets the value of the locationCommentsText property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setLocationCommentsText(String value) {
        this.locationCommentsText = value;
    }

    public boolean isSetLocationCommentsText() {
        return (this.locationCommentsText!= null);
    }

    /**
     * Gets the value of the verticalMeasure property.
     * 
     * @return
     *     possible object is
     *     {@link MeasureDataType }
     *     
     */
    public MeasureDataType getVerticalMeasure() {
        return verticalMeasure;
    }

    /**
     * Sets the value of the verticalMeasure property.
     * 
     * @param value
     *     allowed object is
     *     {@link MeasureDataType }
     *     
     */
    public void setVerticalMeasure(MeasureDataType value) {
        this.verticalMeasure = value;
    }

    public boolean isSetVerticalMeasure() {
        return (this.verticalMeasure!= null);
    }

    /**
     * Gets the value of the verticalCollectionMethod property.
     * 
     * @return
     *     possible object is
     *     {@link ReferenceMethodDataType }
     *     
     */
    public ReferenceMethodDataType getVerticalCollectionMethod() {
        return verticalCollectionMethod;
    }

    /**
     * Sets the value of the verticalCollectionMethod property.
     * 
     * @param value
     *     allowed object is
     *     {@link ReferenceMethodDataType }
     *     
     */
    public void setVerticalCollectionMethod(ReferenceMethodDataType value) {
        this.verticalCollectionMethod = value;
    }

    public boolean isSetVerticalCollectionMethod() {
        return (this.verticalCollectionMethod!= null);
    }

    /**
     * Gets the value of the verticalReferenceDatum property.
     * 
     * @return
     *     possible object is
     *     {@link GeographicReferenceDatumDataType }
     *     
     */
    public GeographicReferenceDatumDataType getVerticalReferenceDatum() {
        return verticalReferenceDatum;
    }

    /**
     * Sets the value of the verticalReferenceDatum property.
     * 
     * @param value
     *     allowed object is
     *     {@link GeographicReferenceDatumDataType }
     *     
     */
    public void setVerticalReferenceDatum(GeographicReferenceDatumDataType value) {
        this.verticalReferenceDatum = value;
    }

    public boolean isSetVerticalReferenceDatum() {
        return (this.verticalReferenceDatum!= null);
    }

    /**
     * Gets the value of the verificationMethod property.
     * 
     * @return
     *     possible object is
     *     {@link ReferenceMethodDataType }
     *     
     */
    public ReferenceMethodDataType getVerificationMethod() {
        return verificationMethod;
    }

    /**
     * Sets the value of the verificationMethod property.
     * 
     * @param value
     *     allowed object is
     *     {@link ReferenceMethodDataType }
     *     
     */
    public void setVerificationMethod(ReferenceMethodDataType value) {
        this.verificationMethod = value;
    }

    public boolean isSetVerificationMethod() {
        return (this.verificationMethod!= null);
    }

    /**
     * Gets the value of the coordinateDataSource property.
     * 
     * @return
     *     possible object is
     *     {@link CoordinateDataSourceDataType }
     *     
     */
    public CoordinateDataSourceDataType getCoordinateDataSource() {
        return coordinateDataSource;
    }

    /**
     * Sets the value of the coordinateDataSource property.
     * 
     * @param value
     *     allowed object is
     *     {@link CoordinateDataSourceDataType }
     *     
     */
    public void setCoordinateDataSource(CoordinateDataSourceDataType value) {
        this.coordinateDataSource = value;
    }

    public boolean isSetCoordinateDataSource() {
        return (this.coordinateDataSource!= null);
    }

    /**
     * Gets the value of the geometricType property.
     * 
     * @return
     *     possible object is
     *     {@link GeometricTypeDataType }
     *     
     */
    public GeometricTypeDataType getGeometricType() {
        return geometricType;
    }

    /**
     * Sets the value of the geometricType property.
     * 
     * @param value
     *     allowed object is
     *     {@link GeometricTypeDataType }
     *     
     */
    public void setGeometricType(GeometricTypeDataType value) {
        this.geometricType = value;
    }

    public boolean isSetGeometricType() {
        return (this.geometricType!= null);
    }

    /**
     * 
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
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

    public Date getDataCollectionDateItem() {
        return XmlAdapterUtils.unmarshall(XMLGregorianCalendarAsDate.class, this.getDataCollectionDate());
    }

    public void setDataCollectionDateItem(Date target) {
        setDataCollectionDate(XmlAdapterUtils.marshall(XMLGregorianCalendarAsDate.class, target));
    }

    public boolean equals(ObjectLocator thisLocator, ObjectLocator thatLocator, Object object, EqualsStrategy strategy) {
        if (!(object instanceof GeographicLocationDescriptionDataType)) {
            return false;
        }
        if (this == object) {
            return true;
        }
        final GeographicLocationDescriptionDataType that = ((GeographicLocationDescriptionDataType) object);
        {
            String lhsLatitudeMeasure;
            lhsLatitudeMeasure = this.getLatitudeMeasure();
            String rhsLatitudeMeasure;
            rhsLatitudeMeasure = that.getLatitudeMeasure();
            if (!strategy.equals(LocatorUtils.property(thisLocator, "latitudeMeasure", lhsLatitudeMeasure), LocatorUtils.property(thatLocator, "latitudeMeasure", rhsLatitudeMeasure), lhsLatitudeMeasure, rhsLatitudeMeasure)) {
                return false;
            }
        }
        {
            String lhsLongitudeMeasure;
            lhsLongitudeMeasure = this.getLongitudeMeasure();
            String rhsLongitudeMeasure;
            rhsLongitudeMeasure = that.getLongitudeMeasure();
            if (!strategy.equals(LocatorUtils.property(thisLocator, "longitudeMeasure", lhsLongitudeMeasure), LocatorUtils.property(thatLocator, "longitudeMeasure", rhsLongitudeMeasure), lhsLongitudeMeasure, rhsLongitudeMeasure)) {
                return false;
            }
        }
        {
            BigInteger lhsSourceMapScaleNumber;
            lhsSourceMapScaleNumber = this.getSourceMapScaleNumber();
            BigInteger rhsSourceMapScaleNumber;
            rhsSourceMapScaleNumber = that.getSourceMapScaleNumber();
            if (!strategy.equals(LocatorUtils.property(thisLocator, "sourceMapScaleNumber", lhsSourceMapScaleNumber), LocatorUtils.property(thatLocator, "sourceMapScaleNumber", rhsSourceMapScaleNumber), lhsSourceMapScaleNumber, rhsSourceMapScaleNumber)) {
                return false;
            }
        }
        {
            MeasureDataType lhsHorizontalAccuracyMeasure;
            lhsHorizontalAccuracyMeasure = this.getHorizontalAccuracyMeasure();
            MeasureDataType rhsHorizontalAccuracyMeasure;
            rhsHorizontalAccuracyMeasure = that.getHorizontalAccuracyMeasure();
            if (!strategy.equals(LocatorUtils.property(thisLocator, "horizontalAccuracyMeasure", lhsHorizontalAccuracyMeasure), LocatorUtils.property(thatLocator, "horizontalAccuracyMeasure", rhsHorizontalAccuracyMeasure), lhsHorizontalAccuracyMeasure, rhsHorizontalAccuracyMeasure)) {
                return false;
            }
        }
        {
            ReferenceMethodDataType lhsHorizontalCollectionMethod;
            lhsHorizontalCollectionMethod = this.getHorizontalCollectionMethod();
            ReferenceMethodDataType rhsHorizontalCollectionMethod;
            rhsHorizontalCollectionMethod = that.getHorizontalCollectionMethod();
            if (!strategy.equals(LocatorUtils.property(thisLocator, "horizontalCollectionMethod", lhsHorizontalCollectionMethod), LocatorUtils.property(thatLocator, "horizontalCollectionMethod", rhsHorizontalCollectionMethod), lhsHorizontalCollectionMethod, rhsHorizontalCollectionMethod)) {
                return false;
            }
        }
        {
            GeographicReferencePointDataType lhsGeographicReferencePoint;
            lhsGeographicReferencePoint = this.getGeographicReferencePoint();
            GeographicReferencePointDataType rhsGeographicReferencePoint;
            rhsGeographicReferencePoint = that.getGeographicReferencePoint();
            if (!strategy.equals(LocatorUtils.property(thisLocator, "geographicReferencePoint", lhsGeographicReferencePoint), LocatorUtils.property(thatLocator, "geographicReferencePoint", rhsGeographicReferencePoint), lhsGeographicReferencePoint, rhsGeographicReferencePoint)) {
                return false;
            }
        }
        {
            GeographicReferenceDatumDataType lhsHorizontalReferenceDatum;
            lhsHorizontalReferenceDatum = this.getHorizontalReferenceDatum();
            GeographicReferenceDatumDataType rhsHorizontalReferenceDatum;
            rhsHorizontalReferenceDatum = that.getHorizontalReferenceDatum();
            if (!strategy.equals(LocatorUtils.property(thisLocator, "horizontalReferenceDatum", lhsHorizontalReferenceDatum), LocatorUtils.property(thatLocator, "horizontalReferenceDatum", rhsHorizontalReferenceDatum), lhsHorizontalReferenceDatum, rhsHorizontalReferenceDatum)) {
                return false;
            }
        }
        {
            XMLGregorianCalendar lhsDataCollectionDate;
            lhsDataCollectionDate = this.getDataCollectionDate();
            XMLGregorianCalendar rhsDataCollectionDate;
            rhsDataCollectionDate = that.getDataCollectionDate();
            if (!strategy.equals(LocatorUtils.property(thisLocator, "dataCollectionDate", lhsDataCollectionDate), LocatorUtils.property(thatLocator, "dataCollectionDate", rhsDataCollectionDate), lhsDataCollectionDate, rhsDataCollectionDate)) {
                return false;
            }
        }
        {
            String lhsLocationCommentsText;
            lhsLocationCommentsText = this.getLocationCommentsText();
            String rhsLocationCommentsText;
            rhsLocationCommentsText = that.getLocationCommentsText();
            if (!strategy.equals(LocatorUtils.property(thisLocator, "locationCommentsText", lhsLocationCommentsText), LocatorUtils.property(thatLocator, "locationCommentsText", rhsLocationCommentsText), lhsLocationCommentsText, rhsLocationCommentsText)) {
                return false;
            }
        }
        {
            MeasureDataType lhsVerticalMeasure;
            lhsVerticalMeasure = this.getVerticalMeasure();
            MeasureDataType rhsVerticalMeasure;
            rhsVerticalMeasure = that.getVerticalMeasure();
            if (!strategy.equals(LocatorUtils.property(thisLocator, "verticalMeasure", lhsVerticalMeasure), LocatorUtils.property(thatLocator, "verticalMeasure", rhsVerticalMeasure), lhsVerticalMeasure, rhsVerticalMeasure)) {
                return false;
            }
        }
        {
            ReferenceMethodDataType lhsVerticalCollectionMethod;
            lhsVerticalCollectionMethod = this.getVerticalCollectionMethod();
            ReferenceMethodDataType rhsVerticalCollectionMethod;
            rhsVerticalCollectionMethod = that.getVerticalCollectionMethod();
            if (!strategy.equals(LocatorUtils.property(thisLocator, "verticalCollectionMethod", lhsVerticalCollectionMethod), LocatorUtils.property(thatLocator, "verticalCollectionMethod", rhsVerticalCollectionMethod), lhsVerticalCollectionMethod, rhsVerticalCollectionMethod)) {
                return false;
            }
        }
        {
            GeographicReferenceDatumDataType lhsVerticalReferenceDatum;
            lhsVerticalReferenceDatum = this.getVerticalReferenceDatum();
            GeographicReferenceDatumDataType rhsVerticalReferenceDatum;
            rhsVerticalReferenceDatum = that.getVerticalReferenceDatum();
            if (!strategy.equals(LocatorUtils.property(thisLocator, "verticalReferenceDatum", lhsVerticalReferenceDatum), LocatorUtils.property(thatLocator, "verticalReferenceDatum", rhsVerticalReferenceDatum), lhsVerticalReferenceDatum, rhsVerticalReferenceDatum)) {
                return false;
            }
        }
        {
            ReferenceMethodDataType lhsVerificationMethod;
            lhsVerificationMethod = this.getVerificationMethod();
            ReferenceMethodDataType rhsVerificationMethod;
            rhsVerificationMethod = that.getVerificationMethod();
            if (!strategy.equals(LocatorUtils.property(thisLocator, "verificationMethod", lhsVerificationMethod), LocatorUtils.property(thatLocator, "verificationMethod", rhsVerificationMethod), lhsVerificationMethod, rhsVerificationMethod)) {
                return false;
            }
        }
        {
            CoordinateDataSourceDataType lhsCoordinateDataSource;
            lhsCoordinateDataSource = this.getCoordinateDataSource();
            CoordinateDataSourceDataType rhsCoordinateDataSource;
            rhsCoordinateDataSource = that.getCoordinateDataSource();
            if (!strategy.equals(LocatorUtils.property(thisLocator, "coordinateDataSource", lhsCoordinateDataSource), LocatorUtils.property(thatLocator, "coordinateDataSource", rhsCoordinateDataSource), lhsCoordinateDataSource, rhsCoordinateDataSource)) {
                return false;
            }
        }
        {
            GeometricTypeDataType lhsGeometricType;
            lhsGeometricType = this.getGeometricType();
            GeometricTypeDataType rhsGeometricType;
            rhsGeometricType = that.getGeometricType();
            if (!strategy.equals(LocatorUtils.property(thisLocator, "geometricType", lhsGeometricType), LocatorUtils.property(thatLocator, "geometricType", rhsGeometricType), lhsGeometricType, rhsGeometricType)) {
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
            String theLatitudeMeasure;
            theLatitudeMeasure = this.getLatitudeMeasure();
            currentHashCode = strategy.hashCode(LocatorUtils.property(locator, "latitudeMeasure", theLatitudeMeasure), currentHashCode, theLatitudeMeasure);
        }
        {
            String theLongitudeMeasure;
            theLongitudeMeasure = this.getLongitudeMeasure();
            currentHashCode = strategy.hashCode(LocatorUtils.property(locator, "longitudeMeasure", theLongitudeMeasure), currentHashCode, theLongitudeMeasure);
        }
        {
            BigInteger theSourceMapScaleNumber;
            theSourceMapScaleNumber = this.getSourceMapScaleNumber();
            currentHashCode = strategy.hashCode(LocatorUtils.property(locator, "sourceMapScaleNumber", theSourceMapScaleNumber), currentHashCode, theSourceMapScaleNumber);
        }
        {
            MeasureDataType theHorizontalAccuracyMeasure;
            theHorizontalAccuracyMeasure = this.getHorizontalAccuracyMeasure();
            currentHashCode = strategy.hashCode(LocatorUtils.property(locator, "horizontalAccuracyMeasure", theHorizontalAccuracyMeasure), currentHashCode, theHorizontalAccuracyMeasure);
        }
        {
            ReferenceMethodDataType theHorizontalCollectionMethod;
            theHorizontalCollectionMethod = this.getHorizontalCollectionMethod();
            currentHashCode = strategy.hashCode(LocatorUtils.property(locator, "horizontalCollectionMethod", theHorizontalCollectionMethod), currentHashCode, theHorizontalCollectionMethod);
        }
        {
            GeographicReferencePointDataType theGeographicReferencePoint;
            theGeographicReferencePoint = this.getGeographicReferencePoint();
            currentHashCode = strategy.hashCode(LocatorUtils.property(locator, "geographicReferencePoint", theGeographicReferencePoint), currentHashCode, theGeographicReferencePoint);
        }
        {
            GeographicReferenceDatumDataType theHorizontalReferenceDatum;
            theHorizontalReferenceDatum = this.getHorizontalReferenceDatum();
            currentHashCode = strategy.hashCode(LocatorUtils.property(locator, "horizontalReferenceDatum", theHorizontalReferenceDatum), currentHashCode, theHorizontalReferenceDatum);
        }
        {
            XMLGregorianCalendar theDataCollectionDate;
            theDataCollectionDate = this.getDataCollectionDate();
            currentHashCode = strategy.hashCode(LocatorUtils.property(locator, "dataCollectionDate", theDataCollectionDate), currentHashCode, theDataCollectionDate);
        }
        {
            String theLocationCommentsText;
            theLocationCommentsText = this.getLocationCommentsText();
            currentHashCode = strategy.hashCode(LocatorUtils.property(locator, "locationCommentsText", theLocationCommentsText), currentHashCode, theLocationCommentsText);
        }
        {
            MeasureDataType theVerticalMeasure;
            theVerticalMeasure = this.getVerticalMeasure();
            currentHashCode = strategy.hashCode(LocatorUtils.property(locator, "verticalMeasure", theVerticalMeasure), currentHashCode, theVerticalMeasure);
        }
        {
            ReferenceMethodDataType theVerticalCollectionMethod;
            theVerticalCollectionMethod = this.getVerticalCollectionMethod();
            currentHashCode = strategy.hashCode(LocatorUtils.property(locator, "verticalCollectionMethod", theVerticalCollectionMethod), currentHashCode, theVerticalCollectionMethod);
        }
        {
            GeographicReferenceDatumDataType theVerticalReferenceDatum;
            theVerticalReferenceDatum = this.getVerticalReferenceDatum();
            currentHashCode = strategy.hashCode(LocatorUtils.property(locator, "verticalReferenceDatum", theVerticalReferenceDatum), currentHashCode, theVerticalReferenceDatum);
        }
        {
            ReferenceMethodDataType theVerificationMethod;
            theVerificationMethod = this.getVerificationMethod();
            currentHashCode = strategy.hashCode(LocatorUtils.property(locator, "verificationMethod", theVerificationMethod), currentHashCode, theVerificationMethod);
        }
        {
            CoordinateDataSourceDataType theCoordinateDataSource;
            theCoordinateDataSource = this.getCoordinateDataSource();
            currentHashCode = strategy.hashCode(LocatorUtils.property(locator, "coordinateDataSource", theCoordinateDataSource), currentHashCode, theCoordinateDataSource);
        }
        {
            GeometricTypeDataType theGeometricType;
            theGeometricType = this.getGeometricType();
            currentHashCode = strategy.hashCode(LocatorUtils.property(locator, "geometricType", theGeometricType), currentHashCode, theGeometricType);
        }
        return currentHashCode;
    }

    public int hashCode() {
        final HashCodeStrategy strategy = JAXBHashCodeStrategy.INSTANCE;
        return this.hashCode(null, strategy);
    }

}
