
package net.exchangenetwork.wsdl.node._2;

import net.exchangenetwork.schema.node._2.Authenticate;
import net.exchangenetwork.schema.node._2.AuthenticateResponse;
import net.exchangenetwork.schema.node._2.Download;
import net.exchangenetwork.schema.node._2.DownloadResponse;
import net.exchangenetwork.schema.node._2.Execute;
import net.exchangenetwork.schema.node._2.ExecuteResponse;
import net.exchangenetwork.schema.node._2.GenericXmlType;
import net.exchangenetwork.schema.node._2.GetServices;
import net.exchangenetwork.schema.node._2.GetStatus;
import net.exchangenetwork.schema.node._2.NodePing;
import net.exchangenetwork.schema.node._2.NodePingResponse;
import net.exchangenetwork.schema.node._2.Notify;
import net.exchangenetwork.schema.node._2.Query;
import net.exchangenetwork.schema.node._2.ResultSetType;
import net.exchangenetwork.schema.node._2.Solicit;
import net.exchangenetwork.schema.node._2.StatusResponseType;
import net.exchangenetwork.schema.node._2.Submit;

import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebResult;
import javax.jws.WebService;
import javax.jws.soap.SOAPBinding;
import javax.xml.bind.annotation.XmlSeeAlso;


/**
 * This class was generated by the JAX-WS RI.
 * JAX-WS RI 2.2.9-b130926.1035
 * Generated source version: 2.2
 * 
 */
@WebService(name = "NetworkNodePortType2", targetNamespace = "http://www.exchangenetwork.net/wsdl/node/2")
@SOAPBinding(parameterStyle = SOAPBinding.ParameterStyle.BARE)
@XmlSeeAlso({
    net.exchangenetwork.schema.node._2.ObjectFactory.class,
    org.w3._2005._05.xmlmime.ObjectFactory.class
})
public interface NetworkNodePortType2 {


    /**
     * User authentication method, must be called initially.
     * 
     * @param parameter
     * @return
     *     returns net.exchangenetwork.schema.node._2.AuthenticateResponse
     * @throws NodeFaultMessage
     */
    @WebMethod(operationName = "Authenticate")
    @WebResult(name = "AuthenticateResponse", targetNamespace = "http://www.exchangenetwork.net/schema/node/2", partName = "return")
    public AuthenticateResponse authenticate(
            @WebParam(name = "Authenticate", targetNamespace = "http://www.exchangenetwork.net/schema/node/2", partName = "parameter")
                    Authenticate parameter)
        throws NodeFaultMessage
    ;

    /**
     * Submit one or more documents to the node.
     *
     * @param parameter
     * @return
     *     returns net.exchangenetwork.schema.node._2.StatusResponseType
     * @throws NodeFaultMessage
     */
    @WebMethod(operationName = "Submit")
    @WebResult(name = "SubmitResponse", targetNamespace = "http://www.exchangenetwork.net/schema/node/2", partName = "return")
    public StatusResponseType submit(
            @WebParam(name = "Submit", targetNamespace = "http://www.exchangenetwork.net/schema/node/2", partName = "parameter")
                    Submit parameter)
        throws NodeFaultMessage
    ;

    /**
     * Check the status of a transaction
     *
     * @param parameter
     * @return
     *     returns net.exchangenetwork.schema.node._2.StatusResponseType
     * @throws NodeFaultMessage
     */
    @WebMethod(operationName = "GetStatus")
    @WebResult(name = "GetStatusResponse", targetNamespace = "http://www.exchangenetwork.net/schema/node/2", partName = "return")
    public StatusResponseType getStatus(
            @WebParam(name = "GetStatus", targetNamespace = "http://www.exchangenetwork.net/schema/node/2", partName = "parameter")
                    GetStatus parameter)
        throws NodeFaultMessage
    ;

    /**
     * Download one or more documents from the node
     *
     * @param parameter
     * @return
     *     returns net.exchangenetwork.schema.node._2.DownloadResponse
     * @throws NodeFaultMessage
     */
    @WebMethod(operationName = "Download")
    @WebResult(name = "DownloadResponse", targetNamespace = "http://www.exchangenetwork.net/schema/node/2", partName = "documents")
    public DownloadResponse download(
            @WebParam(name = "Download", targetNamespace = "http://www.exchangenetwork.net/schema/node/2", partName = "parameter")
                    Download parameter)
        throws NodeFaultMessage
    ;

    /**
     * Notify document availability, network events, submission statuses
     *
     * @param parameter
     * @return
     *     returns net.exchangenetwork.schema.node._2.StatusResponseType
     * @throws NodeFaultMessage
     */
    @WebMethod(operationName = "Notify")
    @WebResult(name = "NotifyResponse", targetNamespace = "http://www.exchangenetwork.net/schema/node/2", partName = "return")
    public StatusResponseType notify(
            @WebParam(name = "Notify", targetNamespace = "http://www.exchangenetwork.net/schema/node/2", partName = "parameter")
                    Notify parameter)
        throws NodeFaultMessage
    ;

    /**
     * Execute a database query
     *
     * @param parameter
     * @return
     *     returns net.exchangenetwork.schema.node._2.ResultSetType
     * @throws NodeFaultMessage
     */
    @WebMethod(operationName = "Query")
    @WebResult(name = "QueryResponse", targetNamespace = "http://www.exchangenetwork.net/schema/node/2", partName = "return")
    public ResultSetType query(
            @WebParam(name = "Query", targetNamespace = "http://www.exchangenetwork.net/schema/node/2", partName = "parameter")
                    Query parameter)
        throws NodeFaultMessage
    ;

    /**
     * Request the node to invoke a specified web services.
     *
     * @param parameter
     * @return
     *     returns net.exchangenetwork.schema.node._2.ExecuteResponse
     * @throws NodeFaultMessage
     */
    @WebMethod(operationName = "Execute")
    @WebResult(name = "ExecuteResponse", targetNamespace = "http://www.exchangenetwork.net/schema/node/2", partName = "return")
    public ExecuteResponse execute(
            @WebParam(name = "Execute", targetNamespace = "http://www.exchangenetwork.net/schema/node/2", partName = "parameter")
                    Execute parameter)
        throws NodeFaultMessage
    ;

    /**
     * Solicit a lengthy database operation.
     *
     * @param parameter
     * @return
     *     returns net.exchangenetwork.schema.node._2.StatusResponseType
     * @throws NodeFaultMessage
     */
    @WebMethod(operationName = "Solicit")
    @WebResult(name = "SolicitResponse", targetNamespace = "http://www.exchangenetwork.net/schema/node/2", partName = "return")
    public StatusResponseType solicit(
            @WebParam(name = "Solicit", targetNamespace = "http://www.exchangenetwork.net/schema/node/2", partName = "parameter")
                    Solicit parameter)
        throws NodeFaultMessage
    ;

    /**
     * Check the status of the service
     *
     * @param parameter
     * @return
     *     returns net.exchangenetwork.schema.node._2.NodePingResponse
     * @throws NodeFaultMessage
     */
    @WebMethod(operationName = "NodePing")
    @WebResult(name = "NodePingResponse", targetNamespace = "http://www.exchangenetwork.net/schema/node/2", partName = "return")
    public NodePingResponse nodePing(
            @WebParam(name = "NodePing", targetNamespace = "http://www.exchangenetwork.net/schema/node/2", partName = "parameter")
                    NodePing parameter)
        throws NodeFaultMessage
    ;

    /**
     * Query services offered by the node
     *
     * @param parameter
     * @return
     *     returns net.exchangenetwork.schema.node._2.GenericXmlType
     * @throws NodeFaultMessage
     */
    @WebMethod(operationName = "GetServices")
    @WebResult(name = "GetServicesResponse", targetNamespace = "http://www.exchangenetwork.net/schema/node/2", partName = "return")
    public GenericXmlType getServices(
            @WebParam(name = "GetServices", targetNamespace = "http://www.exchangenetwork.net/schema/node/2", partName = "parameter")
                    GetServices parameter)
        throws NodeFaultMessage
    ;

}
