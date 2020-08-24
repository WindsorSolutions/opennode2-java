package com.windsor.node.plugin.rcra.inbound.dao;

import java.util.List;

import com.windsor.node.common.domain.CommonTransactionStatusCode;
import com.windsor.node.common.domain.NodeTransaction;
import com.windsor.node.common.domain.ProcessContentResult;
import com.windsor.node.plugin.rcra.inbound.domain.FinancialAssuranceSubmissionDataType;
import com.windsor.node.plugin.rcra.inbound.domain.GeographicInformationSubmissionDataType;
import com.windsor.node.plugin.rcra.inbound.domain.HazardousWasteCMESubmissionDataType;
import com.windsor.node.plugin.rcra.inbound.domain.HazardousWasteCorrectiveActionDataType;
import com.windsor.node.plugin.rcra.inbound.domain.HazardousWasteHandlerSubmissionDataType;
import com.windsor.node.plugin.rcra.inbound.domain.HazardousWastePermitDataType;
import com.windsor.node.plugin.rcra.inbound.domain.OperationType;
import com.windsor.node.plugin.rcra.inbound.domain.SubmissionHistory;

public interface RcraDao {

	HazardousWasteCMESubmissionDataType getCmeRoot();
	
	HazardousWasteCorrectiveActionDataType getCorrectiveActionRoot();
	
	FinancialAssuranceSubmissionDataType getFinancialAssuranceRoot();
	
	GeographicInformationSubmissionDataType getGisRoot();
	
	HazardousWasteHandlerSubmissionDataType getHandlerRoot();
	
	HazardousWastePermitDataType getPermitRoot();
	
	void saveHistory(NodeTransaction transaction, ProcessContentResult result, OperationType operationType);
	
	void callStoredProcedure(String storedProcedure);
	
	List<SubmissionHistory> getOutstandingSubmissions();
	
	void updateSubmissionHistoryStatus(SubmissionHistory submissionHistory, CommonTransactionStatusCode status);
	
}
