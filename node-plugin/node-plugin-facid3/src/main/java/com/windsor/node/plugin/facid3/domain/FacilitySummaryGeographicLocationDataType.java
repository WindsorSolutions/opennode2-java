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


/**
 * <p>Java class for FacilitySummaryGeographicLocationDataType complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="FacilitySummaryGeographicLocationDataType">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element ref="{http://www.opengis.net/gml}Point"/>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/facilityid/3}HorizontalAccuracyMeasure" minOccurs="0"/>
 *         &lt;element ref="{http://www.exchangenetwork.net/schema/facilityid/3}HorizontalCollectionMethod" minOccurs="0"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "FacilitySummaryGeographicLocationDataType", propOrder = {
    "point",
    "horizontalAccuracyMeasure",
    "horizontalCollectionMethod"
})
public class FacilitySummaryGeographicLocationDataType {

    @XmlElement(name = "Point", namespace = "http://www.opengis.net/gml", required = true)
    protected PointType point;
    @XmlElement(name = "HorizontalAccuracyMeasure")
    protected MeasureDataType horizontalAccuracyMeasure;
    @XmlElement(name = "HorizontalCollectionMethod")
    protected ReferenceMethodDataType horizontalCollectionMethod;

    /**
     * Gets the value of the point property.
     * 
     * @return
     *     possible object is
     *     {@link PointType }
     *     
     */
    public PointType getPoint() {
        return point;
    }

    /**
     * Sets the value of the point property.
     * 
     * @param value
     *     allowed object is
     *     {@link PointType }
     *     
     */
    public void setPoint(PointType value) {
        this.point = value;
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

}
