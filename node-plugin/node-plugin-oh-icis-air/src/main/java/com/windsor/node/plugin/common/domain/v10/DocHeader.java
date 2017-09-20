package com.windsor.node.plugin.common.domain.v10;

import com.windsor.node.plugin.common.domain.v10.NameValuePair;
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
   name = "DocHeader",
   propOrder = {"author", "organization", "title", "creationTime", "comment", "dataService", "contactInfo", "notification", "sensitivity", "property"}
)
public class DocHeader {
   @XmlElement(
      name = "Author",
      required = true
   )
   protected String author;
   @XmlElement(
      name = "Organization",
      required = true
   )
   protected String organization;
   @XmlElement(
      name = "Title",
      required = true
   )
   protected String title;
   @XmlElement(
      name = "CreationTime",
      required = true
   )
   @XmlSchemaType(
      name = "dateTime"
   )
   protected XMLGregorianCalendar creationTime;
   @XmlElement(
      name = "Comment"
   )
   protected String comment;
   @XmlElement(
      name = "DataService"
   )
   protected String dataService;
   @XmlElement(
      name = "ContactInfo"
   )
   protected String contactInfo;
   @XmlElement(
      name = "Notification"
   )
   @XmlSchemaType(
      name = "anyURI"
   )
   protected List<String> notification;
   @XmlElement(
      name = "Sensitivity"
   )
   protected String sensitivity;
   @XmlElement(
      name = "Property"
   )
   protected List<NameValuePair> property;

   public String getAuthor() {
      return this.author;
   }

   public void setAuthor(String value) {
      this.author = value;
   }

   public String getOrganization() {
      return this.organization;
   }

   public void setOrganization(String value) {
      this.organization = value;
   }

   public String getTitle() {
      return this.title;
   }

   public void setTitle(String value) {
      this.title = value;
   }

   public XMLGregorianCalendar getCreationTime() {
      return this.creationTime;
   }

   public void setCreationTime(XMLGregorianCalendar value) {
      this.creationTime = value;
   }

   public String getComment() {
      return this.comment;
   }

   public void setComment(String value) {
      this.comment = value;
   }

   public String getDataService() {
      return this.dataService;
   }

   public void setDataService(String value) {
      this.dataService = value;
   }

   public String getContactInfo() {
      return this.contactInfo;
   }

   public void setContactInfo(String value) {
      this.contactInfo = value;
   }

   public List<String> getNotification() {
      if(this.notification == null) {
         this.notification = new ArrayList();
      }

      return this.notification;
   }

   public String getSensitivity() {
      return this.sensitivity;
   }

   public void setSensitivity(String value) {
      this.sensitivity = value;
   }

   public List<NameValuePair> getProperty() {
      if(this.property == null) {
         this.property = new ArrayList();
      }

      return this.property;
   }
}
