package com.windsor.node.plugin.rcra.outbound.outbound;

import com.windsor.node.plugin.rcra.outbound.solicit.request.SolicitRequest;
import com.windsor.node.plugin.rcra.outbound.solicit.request.SolicitRequestFactory;
import com.windsor.node.plugin.rcra.outbound.status.GetStatusRequest;
import com.windsor.node.service.helper.naas.auth.AuthMethod;
import com.windsor.node.service.helper.naas.auth.NetworkSecurityBindingStub;
import net.exchangenetwork.schema.node._2.StatusResponseType;
import net.exchangenetwork.wsdl.node._2.NodeFaultMessage;
import org.apache.axis.AxisFault;

import java.net.MalformedURLException;
import java.net.URL;
import java.rmi.RemoteException;
import java.util.Calendar;
import java.util.GregorianCalendar;

public class TestClient {

    private final static String NAAS_ENDPOINT = "https://cdxnodenaas.epa.gov/xml/auth.wsdl"; //"https://naas.epacdxnode.net/xml/auth.wsdl";
//    private final static String NAAS_ACCOUNT = "noderuntime@windsorsolutions.com";
//    private final static String NAAS_PASSWORD = "kJnx8m7pyb";

    private final static String STATE = "NC";

//    private final static String NAAS_ACCOUNT = "andrew_geery@windsorsolutions.com";
//    private final static String NAAS_PASSWORD = "M3moria!";

    // PROD
    private final static String NAAS_ACCOUNT = "node_operator@ncmail.net";
    private final static String NAAS_PASSWORD = "ot*V0326";

    // TEST
//    private final static String NAAS_ACCOUNT = "testuser@ncmail.net";
//    private final static String NAAS_PASSWORD = "suT8*jkl";

    private final static String SERVICE_ENDPOINT = "https://cdxnodengn.epa.gov/ngn-enws20/services/NetworkNode2ServiceConditionalMTOM";

    public static void main(String[] args) {

        String securityToken = null;
        String transactionId = null;

        try {
            NetworkSecurityBindingStub securityBindingStub =
                    new NetworkSecurityBindingStub(new URL(NAAS_ENDPOINT), null);
            securityToken = securityBindingStub.authenticate(NAAS_ACCOUNT, NAAS_PASSWORD,
                    AuthMethod.fromValue("password"));
            System.out.println("Security Token: " + securityToken);
        } catch(MalformedURLException exception) {
            System.out.println("Bad URL: " + exception.getMessage());
        } catch(AxisFault exception) {
            System.out.println("Axis Fault: " + exception.getMessage());
        } catch(RemoteException exception) {
            System.out.println("RMI exception: " + exception.getMessage());
        }

        SolicitRequestFactory requestFactory =
                new SolicitRequestFactory(SERVICE_ENDPOINT, securityToken);
        SolicitRequest request = requestFactory.getCAByState(STATE, "2022-07-01");

        try {
            StatusResponseType responseType = request.execute();
            transactionId = responseType.getTransactionId();
            System.out.println("Response: " + responseType.getTransactionId());
            System.out.println("Response: " + responseType.getStatus());
            System.out.println("Response: " + responseType.getStatusDetail());

            GetStatusRequest getStatusRequest = new GetStatusRequest(SERVICE_ENDPOINT, securityToken, transactionId);
            responseType = getStatusRequest.execute();
            System.out.println("Response: " + responseType.getTransactionId());
            System.out.println("Response: " + responseType.getStatus());
            System.out.println("Response: " + responseType.getStatusDetail());

            // loop until our request completed or fails
            String status = null;
            while(status == null || (!status.equals("COMPLETED") && !status.equals("FAILED"))) {

                System.out.println("Sleeping for 10 secounds...");
                Thread.sleep(10000);

                getStatusRequest = new GetStatusRequest(SERVICE_ENDPOINT, securityToken, transactionId);
                responseType = getStatusRequest.execute();
                status = responseType.getStatus().toString();
                System.out.println("Response: " + responseType.getTransactionId());
                System.out.println("Response: " + responseType.getStatus());
                System.out.println("Response: " + responseType.getStatusDetail());
            }
        } catch(NodeFaultMessage exception) {
            System.out.println("CDX Node Fault Message: " + exception.getFaultInfo().getDescription());
        } catch(InterruptedException exception) {
            // do nothing
        }
    }
}
