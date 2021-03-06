
package org.tempuri;

import java.net.MalformedURLException;
import java.net.URL;
import javax.xml.namespace.QName;
import javax.xml.ws.Service;
import javax.xml.ws.WebEndpoint;
import javax.xml.ws.WebServiceClient;
import javax.xml.ws.WebServiceException;
import javax.xml.ws.WebServiceFeature;


/**
 * This class was generated by the JAX-WS RI.
 * JAX-WS RI 2.2.9-b130926.1035
 * Generated source version: 2.2
 * 
 */
@WebServiceClient(name = "AQSXmlService", targetNamespace = "http://tempuri.org/", wsdlLocation = "http://108.163.187.10:9889/AirVision.Services.WebServices.AQSXml/AQSXmlService/?wsdl")
public class AQSXmlService_Service
    extends Service
{

    private final static URL AQSXMLSERVICE_WSDL_LOCATION;
    private final static WebServiceException AQSXMLSERVICE_EXCEPTION;
    private final static QName AQSXMLSERVICE_QNAME = new QName("http://tempuri.org/", "AQSXmlService");

    static {
        URL url = null;
        WebServiceException e = null;
        try {
            url = new URL("http://108.163.187.10:9889/AirVision.Services.WebServices.AQSXml/AQSXmlService/?wsdl");
        } catch (MalformedURLException ex) {
            e = new WebServiceException(ex);
        }
        AQSXMLSERVICE_WSDL_LOCATION = url;
        AQSXMLSERVICE_EXCEPTION = e;
    }

    public AQSXmlService_Service() {
        super(__getWsdlLocation(), AQSXMLSERVICE_QNAME);
    }

    public AQSXmlService_Service(WebServiceFeature... features) {
        super(__getWsdlLocation(), AQSXMLSERVICE_QNAME, features);
    }

    public AQSXmlService_Service(URL wsdlLocation) {
        super(wsdlLocation, AQSXMLSERVICE_QNAME);
    }

    public AQSXmlService_Service(URL wsdlLocation, WebServiceFeature... features) {
        super(wsdlLocation, AQSXMLSERVICE_QNAME, features);
    }

    public AQSXmlService_Service(URL wsdlLocation, QName serviceName) {
        super(wsdlLocation, serviceName);
    }

    public AQSXmlService_Service(URL wsdlLocation, QName serviceName, WebServiceFeature... features) {
        super(wsdlLocation, serviceName, features);
    }

    /**
     * 
     * @return
     *     returns AQSXmlService
     */
    @WebEndpoint(name = "BasicHttpBinding_AQSXmlService")
    public AQSXmlService getBasicHttpBindingAQSXmlService() {
        return super.getPort(new QName("http://tempuri.org/", "BasicHttpBinding_AQSXmlService"), AQSXmlService.class);
    }

    /**
     * 
     * @param features
     *     A list of {@link javax.xml.ws.WebServiceFeature} to configure on the proxy.  Supported features not in the <code>features</code> parameter will have their default values.
     * @return
     *     returns AQSXmlService
     */
    @WebEndpoint(name = "BasicHttpBinding_AQSXmlService")
    public AQSXmlService getBasicHttpBindingAQSXmlService(WebServiceFeature... features) {
        return super.getPort(new QName("http://tempuri.org/", "BasicHttpBinding_AQSXmlService"), AQSXmlService.class, features);
    }

    private static URL __getWsdlLocation() {
        if (AQSXMLSERVICE_EXCEPTION!= null) {
            throw AQSXMLSERVICE_EXCEPTION;
        }
        return AQSXMLSERVICE_WSDL_LOCATION;
    }

}
