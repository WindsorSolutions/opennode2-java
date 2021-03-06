/*     */ package com.windsor.node.plugin.common.domain;
/*     */ 
/*     */ import java.util.ArrayList;
/*     */ import java.util.List;
/*     */ import javax.xml.bind.annotation.XmlAccessType;
/*     */ import javax.xml.bind.annotation.XmlAccessorType;
/*     */ import javax.xml.bind.annotation.XmlAnyElement;
/*     */ import javax.xml.bind.annotation.XmlAttribute;
/*     */ import javax.xml.bind.annotation.XmlMixed;
/*     */ import javax.xml.bind.annotation.XmlSchemaType;
/*     */ import javax.xml.bind.annotation.XmlType;
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ @XmlAccessorType(XmlAccessType.FIELD)
/*     */ @XmlType(name="CanonicalizationMethodType", propOrder={"content"})
/*     */ public class CanonicalizationMethodType
/*     */ {
/*     */   @XmlMixed
/*     */   @XmlAnyElement(lax=true)
/*     */   protected List<Object> content;
/*     */   @XmlAttribute(name="Algorithm", required=true)
/*     */   @XmlSchemaType(name="anyURI")
/*     */   protected String algorithm;
/*     */   
/*     */   public List<Object> getContent()
/*     */   {
/*  79 */     if (this.content == null) {
/*  80 */       this.content = new ArrayList();
/*     */     }
/*  82 */     return this.content;
/*     */   }
/*     */   
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */   public String getAlgorithm()
/*     */   {
/*  94 */     return this.algorithm;
/*     */   }
/*     */   
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */ 
/*     */   public void setAlgorithm(String value)
/*     */   {
/* 106 */     this.algorithm = value;
/*     */   }
/*     */ }


/* Location:              C:\Users\cmiles\Documents\Java Projects\AQS\AQS\_25C455FD-A159-4216-8911-704D52B3739C\aqs.jar!\com\windsor\node\plugin\common\domain\CanonicalizationMethodType.class
 * Java compiler version: 7 (51.0)
 * JD-Core Version:       0.7.1
 */