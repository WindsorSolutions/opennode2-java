package com.windsor.node.plugin.common.domain.v10;

import com.windsor.node.plugin.common.domain.v10.DocHeader;
import com.windsor.node.plugin.common.domain.v10.ExchangeNetworkDocument;
import com.windsor.node.plugin.common.domain.v10.NameValuePair;
import com.windsor.node.plugin.common.domain.v10.Payload;
import javax.xml.bind.JAXBElement;
import javax.xml.bind.annotation.XmlElementDecl;
import javax.xml.bind.annotation.XmlRegistry;
import javax.xml.namespace.QName;

@XmlRegistry
public class ObjectFactory {
   private static final QName _Document_QNAME = new QName("http://www.exchangenetwork.net/schema/v1.0/ExchangeNetworkDocument.xsd", "Document");

   public ExchangeNetworkDocument createExchangeNetworkDocument() {
      return new ExchangeNetworkDocument();
   }

   public Payload createPayload() {
      return new Payload();
   }

   public DocHeader createDocHeader() {
      return new DocHeader();
   }

   public NameValuePair createNameValuePair() {
      return new NameValuePair();
   }

   @XmlElementDecl(
      namespace = "http://www.exchangenetwork.net/schema/v1.0/ExchangeNetworkDocument.xsd",
      name = "Document"
   )
   public JAXBElement<ExchangeNetworkDocument> createDocument(ExchangeNetworkDocument value) {
      return new JAXBElement(_Document_QNAME, ExchangeNetworkDocument.class, (Class)null, value);
   }
}
