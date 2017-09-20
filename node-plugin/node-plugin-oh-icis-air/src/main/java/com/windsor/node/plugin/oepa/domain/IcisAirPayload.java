package com.windsor.node.plugin.oepa.domain;

import java.io.Serializable;
import javax.persistence.Access;
import javax.persistence.AccessType;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import org.apache.commons.lang3.StringUtils;
import org.safehaus.uuid.UUID;
import org.safehaus.uuid.UUIDGenerator;

@Entity(
   name = "IcisAirPayload"
)
@Table(
   name = "ICA_PAYLOAD"
)
@Access(AccessType.PROPERTY)
public class IcisAirPayload implements Serializable {
   private static final long serialVersionUID = 210L;
   protected String dbid;
   private String operation;

   @Basic
   @Column(
      name = "OPERATION"
   )
   public String getOperation() {
      return this.operation;
   }

   public void setOperation(String operation) {
      this.operation = operation;
   }

   @Id
   @Column(
      name = "ICA_PAYLOAD_ID"
   )
   public String getDbid() {
      if(StringUtils.isBlank(this.dbid)) {
         UUID uuid = UUIDGenerator.getInstance().generateRandomBasedUUID();
         this.dbid = uuid.toString();
      }

      return this.dbid;
   }

   public void setDbid(String dbid) {
      this.dbid = dbid;
   }
}
