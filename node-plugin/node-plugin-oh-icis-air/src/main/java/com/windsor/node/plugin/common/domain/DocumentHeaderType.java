package com.windsor.node.plugin.common.domain;

import com.windsor.node.plugin.common.domain.NameValuePair;
import com.windsor.node.plugin.common.domain.SignatureType;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlSchemaType;
import javax.xml.bind.annotation.XmlType;
import javax.xml.datatype.XMLGregorianCalendar;

@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(
   name = "DocumentHeaderType",
   namespace = "http://www.exchangenetwork.net/schema/header/2",
   propOrder = {"authorName", "organizationName", "documentTitle", "creationDateTime", "keywords", "comment", "dataFlowName", "dataServiceName", "senderContact", "applicationUserIdentifier", "senderAddress", "property", "signature"}
)
public class DocumentHeaderType implements Serializable {
   private static final long serialVersionUID = 1L;
   @XmlElement(
      name = "AuthorName",
      required = true
   )
   protected String authorName;
   @XmlElement(
      name = "OrganizationName",
      required = true
   )
   protected String organizationName;
   @XmlElement(
      name = "DocumentTitle",
      required = true
   )
   protected String documentTitle;
   @XmlElement(
      name = "CreationDateTime",
      required = true
   )
   @XmlSchemaType(
      name = "dateTime"
   )
   protected XMLGregorianCalendar creationDateTime;
   @XmlElement(
      name = "Keywords"
   )
   protected String keywords;
   @XmlElement(
      name = "Comment"
   )
   protected String comment;
   @XmlElement(
      name = "DataFlowName"
   )
   protected String dataFlowName;
   @XmlElement(
      name = "DataServiceName"
   )
   protected String dataServiceName;
   @XmlElement(
      name = "SenderContact"
   )
   protected String senderContact;
   @XmlElement(
      name = "ApplicationUserIdentifier"
   )
   protected String applicationUserIdentifier;
   @XmlElement(
      name = "SenderAddress"
   )
   @XmlSchemaType(
      name = "anyURI"
   )
   protected List<String> senderAddress;
   @XmlElement(
      name = "Property"
   )
   protected List<NameValuePair> property;
   @XmlElement(
      name = "Signature",
      namespace = "http://www.w3.org/2000/09/xmldsig#"
   )
   protected SignatureType signature;

   public String getAuthorName() {
      return this.authorName;
   }

   public void setAuthorName(String value) {
      this.authorName = value;
   }

   public String getOrganizationName() {
      return this.organizationName;
   }

   public void setOrganizationName(String value) {
      this.organizationName = value;
   }

   public String getDocumentTitle() {
      return this.documentTitle;
   }

   public void setDocumentTitle(String value) {
      this.documentTitle = value;
   }

   public XMLGregorianCalendar getCreationDateTime() {
      return this.creationDateTime;
   }

   public void setCreationDateTime(XMLGregorianCalendar value) {
      this.creationDateTime = value;
   }

   public String getKeywords() {
      return this.keywords;
   }

   public void setKeywords(String value) {
      this.keywords = value;
   }

   public String getComment() {
      return this.comment;
   }

   public void setComment(String value) {
      this.comment = value;
   }

   public String getDataFlowName() {
      return this.dataFlowName;
   }

   public void setDataFlowName(String value) {
      this.dataFlowName = value;
   }

   public String getDataServiceName() {
      return this.dataServiceName;
   }

   public void setDataServiceName(String value) {
      this.dataServiceName = value;
   }

   public String getSenderContact() {
      return this.senderContact;
   }

   public void setSenderContact(String value) {
      this.senderContact = value;
   }

   public String getApplicationUserIdentifier() {
      return this.applicationUserIdentifier;
   }

   public void setApplicationUserIdentifier(String value) {
      this.applicationUserIdentifier = value;
   }

   public List<String> getSenderAddress() {
      if(this.senderAddress == null) {
         this.senderAddress = new ArrayList();
      }

      return this.senderAddress;
   }

   public List<NameValuePair> getProperty() {
      if(this.property == null) {
         this.property = new ArrayList();
      }

      return this.property;
   }

   public SignatureType getSignature() {
      return this.signature;
   }

   public void setSignature(SignatureType value) {
      this.signature = value;
   }
}
