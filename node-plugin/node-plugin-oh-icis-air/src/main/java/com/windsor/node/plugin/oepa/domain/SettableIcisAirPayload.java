package com.windsor.node.plugin.oepa.domain;

import com.windsor.node.plugin.oepa.domain.IcisAirPayload;
import javax.persistence.JoinColumn;
import javax.persistence.MappedSuperclass;
import javax.persistence.OneToOne;
import javax.xml.bind.annotation.XmlTransient;

@MappedSuperclass
public abstract class SettableIcisAirPayload {
   private IcisAirPayload icisAirPayload;

   @XmlTransient
   @OneToOne(
      targetEntity = IcisAirPayload.class
   )
   @JoinColumn(
      name = "ICA_PAYLOAD_ID"
   )
   public IcisAirPayload getIcisAirPayload() {
      return this.icisAirPayload;
   }

   public void setIcisAirPayload(IcisAirPayload icisAirPayload) {
      this.icisAirPayload = icisAirPayload;
   }
}
