package com.windsor.node.plugin.common.domain;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;

@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(
   name = "DSAKeyValueType",
   propOrder = {"p", "q", "g", "y", "j", "seed", "pgenCounter"}
)
public class DSAKeyValueType {
   @XmlElement(
      name = "P"
   )
   protected byte[] p;
   @XmlElement(
      name = "Q"
   )
   protected byte[] q;
   @XmlElement(
      name = "G"
   )
   protected byte[] g;
   @XmlElement(
      name = "Y",
      required = true
   )
   protected byte[] y;
   @XmlElement(
      name = "J"
   )
   protected byte[] j;
   @XmlElement(
      name = "Seed"
   )
   protected byte[] seed;
   @XmlElement(
      name = "PgenCounter"
   )
   protected byte[] pgenCounter;

   public byte[] getP() {
      return this.p;
   }

   public void setP(byte[] value) {
      this.p = (byte[])value;
   }

   public byte[] getQ() {
      return this.q;
   }

   public void setQ(byte[] value) {
      this.q = (byte[])value;
   }

   public byte[] getG() {
      return this.g;
   }

   public void setG(byte[] value) {
      this.g = (byte[])value;
   }

   public byte[] getY() {
      return this.y;
   }

   public void setY(byte[] value) {
      this.y = (byte[])value;
   }

   public byte[] getJ() {
      return this.j;
   }

   public void setJ(byte[] value) {
      this.j = (byte[])value;
   }

   public byte[] getSeed() {
      return this.seed;
   }

   public void setSeed(byte[] value) {
      this.seed = (byte[])value;
   }

   public byte[] getPgenCounter() {
      return this.pgenCounter;
   }

   public void setPgenCounter(byte[] value) {
      this.pgenCounter = (byte[])value;
   }
}
