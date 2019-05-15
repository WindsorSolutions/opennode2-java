package com.windsor.node.plugin.oepa.domain.generated;

import com.windsor.node.plugin.oepa.domain.generated.IcisFedExportData;
import javax.xml.bind.annotation.XmlRegistry;

@XmlRegistry
public class ObjectFactory {
   public IcisFedExportData createIcisFedExportData() {
      return new IcisFedExportData();
   }

   public IcisFedExportData.Payload createIcisFedExportDataPayload() {
      return new IcisFedExportData.Payload();
   }

   public IcisFedExportData.Payload.AirFacilityData createIcisFedExportDataPayloadAirFacilityData() {
      return new IcisFedExportData.Payload.AirFacilityData();
   }

   public IcisFedExportData.Payload.AirFacilityData.AirFacility createIcisFedExportDataPayloadAirFacilityDataAirFacility() {
      return new IcisFedExportData.Payload.AirFacilityData.AirFacility();
   }

   public IcisFedExportData.Header createIcisFedExportDataHeader() {
      return new IcisFedExportData.Header();
   }

   public IcisFedExportData.Payload.AirFacilityData.AirFacility.NAICSCodeDetails createIcisFedExportDataPayloadAirFacilityDataAirFacilityNAICSCodeDetails() {
      return new IcisFedExportData.Payload.AirFacilityData.AirFacility.NAICSCodeDetails();
   }
}
