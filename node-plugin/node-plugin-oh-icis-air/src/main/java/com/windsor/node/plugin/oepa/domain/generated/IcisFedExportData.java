package com.windsor.node.plugin.oepa.domain.generated;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;

@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(
   name = "",
   propOrder = {"header", "payload", "numRecords"}
)
@XmlRootElement(
   name = "icisFedExportData"
)
public class IcisFedExportData {
   @XmlElement(
      name = "Header",
      required = true
   )
   protected IcisFedExportData.Header header;
   @XmlElement(
      name = "Payload",
      required = true
   )
   protected IcisFedExportData.Payload payload;
   protected short numRecords;

   public IcisFedExportData.Header getHeader() {
      return this.header;
   }

   public void setHeader(IcisFedExportData.Header value) {
      this.header = value;
   }

   public IcisFedExportData.Payload getPayload() {
      return this.payload;
   }

   public void setPayload(IcisFedExportData.Payload value) {
      this.payload = value;
   }

   public short getNumRecords() {
      return this.numRecords;
   }

   public void setNumRecords(short value) {
      this.numRecords = value;
   }

   @XmlAccessorType(XmlAccessType.FIELD)
   @XmlType(
      name = "",
      propOrder = {"airFacilityData"}
   )
   public static class Payload {
      @XmlElement(
         name = "AirFacilityData"
      )
      protected List<IcisFedExportData.Payload.AirFacilityData> airFacilityData;
      @XmlAttribute(
         name = "Operation"
      )
      protected String operation;

      public List<IcisFedExportData.Payload.AirFacilityData> getAirFacilityData() {
         if(this.airFacilityData == null) {
            this.airFacilityData = new ArrayList();
         }

         return this.airFacilityData;
      }

      public String getOperation() {
         return this.operation;
      }

      public void setOperation(String value) {
         this.operation = value;
      }

      @XmlAccessorType(XmlAccessType.FIELD)
      @XmlType(
         name = "",
         propOrder = {"airFacility"}
      )
      public static class AirFacilityData {
         @XmlElement(
            name = "AirFacility",
            required = true
         )
         protected IcisFedExportData.Payload.AirFacilityData.AirFacility airFacility;

         public IcisFedExportData.Payload.AirFacilityData.AirFacility getAirFacility() {
            return this.airFacility;
         }

         public void setAirFacility(IcisFedExportData.Payload.AirFacilityData.AirFacility value) {
            this.airFacility = value;
         }

         @XmlAccessorType(XmlAccessType.FIELD)
         @XmlType(
            name = "",
            propOrder = {"airFacilityIdentifier", "facilitySiteName", "locationAddressText", "locationAddressCityCode", "locationStateCode", "locationZipCode", "naicsCodeDetails"}
         )
         public static class AirFacility {
            @XmlElement(
               name = "AirFacilityIdentifier",
               required = true
            )
            protected String airFacilityIdentifier;
            @XmlElement(
               name = "FacilitySiteName",
               required = true
            )
            protected String facilitySiteName;
            @XmlElement(
               name = "LocationAddressText",
               required = true
            )
            protected String locationAddressText;
            @XmlElement(
               name = "LocationAddressCityCode",
               required = true
            )
            protected String locationAddressCityCode;
            @XmlElement(
               name = "LocationStateCode",
               required = true
            )
            protected String locationStateCode;
            @XmlElement(
               name = "LocationZipCode"
            )
            protected int locationZipCode;
            @XmlElement(
               name = "NAICSCodeDetails",
               required = true
            )
            protected IcisFedExportData.Payload.AirFacilityData.AirFacility.NAICSCodeDetails naicsCodeDetails;

            public String getAirFacilityIdentifier() {
               return this.airFacilityIdentifier;
            }

            public void setAirFacilityIdentifier(String value) {
               this.airFacilityIdentifier = value;
            }

            public String getFacilitySiteName() {
               return this.facilitySiteName;
            }

            public void setFacilitySiteName(String value) {
               this.facilitySiteName = value;
            }

            public String getLocationAddressText() {
               return this.locationAddressText;
            }

            public void setLocationAddressText(String value) {
               this.locationAddressText = value;
            }

            public String getLocationAddressCityCode() {
               return this.locationAddressCityCode;
            }

            public void setLocationAddressCityCode(String value) {
               this.locationAddressCityCode = value;
            }

            public String getLocationStateCode() {
               return this.locationStateCode;
            }

            public void setLocationStateCode(String value) {
               this.locationStateCode = value;
            }

            public int getLocationZipCode() {
               return this.locationZipCode;
            }

            public void setLocationZipCode(int value) {
               this.locationZipCode = value;
            }

            public IcisFedExportData.Payload.AirFacilityData.AirFacility.NAICSCodeDetails getNAICSCodeDetails() {
               return this.naicsCodeDetails;
            }

            public void setNAICSCodeDetails(IcisFedExportData.Payload.AirFacilityData.AirFacility.NAICSCodeDetails value) {
               this.naicsCodeDetails = value;
            }

            @XmlAccessorType(XmlAccessType.FIELD)
            @XmlType(
               name = "",
               propOrder = {"naicsCode", "naicsPrimaryIndicatorCode"}
            )
            public static class NAICSCodeDetails {
               @XmlElement(
                  name = "NAICSCode"
               )
               protected int naicsCode;
               @XmlElement(
                  name = "NAICSPrimaryIndicatorCode",
                  required = true
               )
               protected String naicsPrimaryIndicatorCode;

               public int getNAICSCode() {
                  return this.naicsCode;
               }

               public void setNAICSCode(int value) {
                  this.naicsCode = value;
               }

               public String getNAICSPrimaryIndicatorCode() {
                  return this.naicsPrimaryIndicatorCode;
               }

               public void setNAICSPrimaryIndicatorCode(String value) {
                  this.naicsPrimaryIndicatorCode = value;
               }
            }
         }
      }
   }

   @XmlAccessorType(XmlAccessType.FIELD)
   @XmlType(
      name = "",
      propOrder = {"id"}
   )
   public static class Header {
      @XmlElement(
         name = "Id",
         required = true
      )
      protected String id;

      public String getId() {
         return this.id;
      }

      public void setId(String value) {
         this.id = value;
      }
   }
}
