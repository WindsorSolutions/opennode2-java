package com.windsor.node.plugin.oepa.domain;

import com.windsor.node.plugin.oepa.domain.IcisAirFacility;
import com.windsor.node.plugin.oepa.domain.IcisFedExportData;
import com.windsor.node.plugin.oepa.domain.NaicsCodeDetails;
import javax.xml.bind.annotation.XmlRegistry;

@XmlRegistry
public class ObjectFactory {
   public IcisFedExportData createIcisAirFacilities() {
      return new IcisFedExportData();
   }

   public IcisAirFacility createIcisAirFacility() {
      return new IcisAirFacility();
   }

   public NaicsCodeDetails createNaicsCodeDetails() {
      return new NaicsCodeDetails();
   }
}
