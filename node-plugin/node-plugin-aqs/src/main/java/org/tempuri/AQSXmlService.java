
package org.tempuri;

import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebResult;
import javax.jws.WebService;
import javax.xml.bind.annotation.XmlSeeAlso;
import javax.xml.datatype.XMLGregorianCalendar;
import javax.xml.ws.RequestWrapper;
import javax.xml.ws.ResponseWrapper;
import org.datacontract.schemas._2004._07.airvision_common_services_webservices.AQS3WebServiceArgument;
import org.datacontract.schemas._2004._07.airvision_common_services_webservices.AQSWebServiceArgument;
import org.datacontract.schemas._2004._07.airvision_common_services_webservices.AQSXmlResultData;
import org.datacontract.schemas._2004._07.airvision_common_services_webservices.ArrayOfAQSParameterInformation;


/**
 * This class was generated by the JAX-WS RI.
 * JAX-WS RI 2.2.9-b130926.1035
 * Generated source version: 2.2
 * 
 */
@WebService(name = "AQSXmlService", targetNamespace = "http://www.agilairecorp.com/")
@XmlSeeAlso({
    com.agilairecorp.ObjectFactory.class,
    com.microsoft.schemas._2003._10.serialization.ObjectFactory.class,
    com.microsoft.schemas._2003._10.serialization.arrays.ObjectFactory.class,
    org.datacontract.schemas._2004._07.airvision_common_services_webservices.ObjectFactory.class
})
public interface AQSXmlService {


    /**
     * 
     * @param args
     * @return
     *     returns org.datacontract.schemas._2004._07.airvision_common_services_webservices.AQSXmlResultData
     */
    @WebMethod(operationName = "GetAQSXmlData", action = "http://www.agilairecorp.com/AQSXmlService/GetAQSXmlData")
    @WebResult(name = "GetAQSXmlDataResult", targetNamespace = "http://www.agilairecorp.com/")
    @RequestWrapper(localName = "GetAQSXmlData", targetNamespace = "http://www.agilairecorp.com/", className = "com.agilairecorp.GetAQSXmlData")
    @ResponseWrapper(localName = "GetAQSXmlDataResponse", targetNamespace = "http://www.agilairecorp.com/", className = "com.agilairecorp.GetAQSXmlDataResponse")
    public AQSXmlResultData getAQSXmlData(
        @WebParam(name = "args", targetNamespace = "http://www.agilairecorp.com/")
        AQSWebServiceArgument args);

    /**
     * 
     * @param args
     * @return
     *     returns org.datacontract.schemas._2004._07.airvision_common_services_webservices.AQSXmlResultData
     */
    @WebMethod(operationName = "GetAQS3XmlData", action = "http://www.agilairecorp.com/AQSXmlService/GetAQS3XmlData")
    @WebResult(name = "GetAQS3XmlDataResult", targetNamespace = "http://www.agilairecorp.com/")
    @RequestWrapper(localName = "GetAQS3XmlData", targetNamespace = "http://www.agilairecorp.com/", className = "com.agilairecorp.GetAQS3XmlData")
    @ResponseWrapper(localName = "GetAQS3XmlDataResponse", targetNamespace = "http://www.agilairecorp.com/", className = "com.agilairecorp.GetAQS3XmlDataResponse")
    public AQSXmlResultData getAQS3XmlData(
        @WebParam(name = "args", targetNamespace = "http://www.agilairecorp.com/")
        AQS3WebServiceArgument args);

    /**
     * 
     * @param sendRdTransactions
     * @param aqsXmlSchemaVersion
     * @param sendRaTransactions
     * @param sendRpTransactions
     * @param startTime
     * @param sendRbTransactions
     * @param endTime
     * @param sendOnlyQaData
     * @return
     *     returns org.datacontract.schemas._2004._07.airvision_common_services_webservices.AQSXmlResultData
     */
    @WebMethod(operationName = "GetAQSXmlDataWeb", action = "http://www.agilairecorp.com/AQSXmlService/GetAQSXmlDataWeb")
    @WebResult(name = "GetAQSXmlDataWebResult", targetNamespace = "http://www.agilairecorp.com/")
    @RequestWrapper(localName = "GetAQSXmlDataWeb", targetNamespace = "http://www.agilairecorp.com/", className = "com.agilairecorp.GetAQSXmlDataWeb")
    @ResponseWrapper(localName = "GetAQSXmlDataWebResponse", targetNamespace = "http://www.agilairecorp.com/", className = "com.agilairecorp.GetAQSXmlDataWebResponse")
    public AQSXmlResultData getAQSXmlDataWeb(
        @WebParam(name = "startTime", targetNamespace = "http://www.agilairecorp.com/")
        XMLGregorianCalendar startTime,
        @WebParam(name = "endTime", targetNamespace = "http://www.agilairecorp.com/")
        XMLGregorianCalendar endTime,
        @WebParam(name = "aqsXmlSchemaVersion", targetNamespace = "http://www.agilairecorp.com/")
        String aqsXmlSchemaVersion,
        @WebParam(name = "sendRdTransactions", targetNamespace = "http://www.agilairecorp.com/")
        Boolean sendRdTransactions,
        @WebParam(name = "sendRbTransactions", targetNamespace = "http://www.agilairecorp.com/")
        Boolean sendRbTransactions,
        @WebParam(name = "sendRaTransactions", targetNamespace = "http://www.agilairecorp.com/")
        Boolean sendRaTransactions,
        @WebParam(name = "sendRpTransactions", targetNamespace = "http://www.agilairecorp.com/")
        Boolean sendRpTransactions,
        @WebParam(name = "sendOnlyQaData", targetNamespace = "http://www.agilairecorp.com/")
        Boolean sendOnlyQaData);

    /**
     * 
     * @return
     *     returns org.datacontract.schemas._2004._07.airvision_common_services_webservices.ArrayOfAQSParameterInformation
     */
    @WebMethod(operationName = "GetAQSParameters", action = "http://www.agilairecorp.com/AQSXmlService/GetAQSParameters")
    @WebResult(name = "GetAQSParametersResult", targetNamespace = "http://www.agilairecorp.com/")
    @RequestWrapper(localName = "GetAQSParameters", targetNamespace = "http://www.agilairecorp.com/", className = "com.agilairecorp.GetAQSParameters")
    @ResponseWrapper(localName = "GetAQSParametersResponse", targetNamespace = "http://www.agilairecorp.com/", className = "com.agilairecorp.GetAQSParametersResponse")
    public ArrayOfAQSParameterInformation getAQSParameters();

}
