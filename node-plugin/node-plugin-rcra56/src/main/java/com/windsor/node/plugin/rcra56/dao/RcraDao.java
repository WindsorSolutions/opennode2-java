package com.windsor.node.plugin.rcra56.dao;

import java.util.List;

import com.windsor.node.common.domain.CommonTransactionStatusCode;
import com.windsor.node.common.domain.NodeTransaction;
import com.windsor.node.common.domain.ProcessContentResult;
import com.windsor.node.plugin.rcra56.domain.FinancialAssuranceSubmissionDataType;
import com.windsor.node.plugin.rcra56.domain.GeographicInformationSubmissionDataType;
import com.windsor.node.plugin.rcra56.domain.HazardousWasteCMESubmissionDataType;
import com.windsor.node.plugin.rcra56.domain.HazardousWasteCorrectiveActionDataType;
import com.windsor.node.plugin.rcra56.domain.HazardousWasteHandlerSubmissionDataType;
import com.windsor.node.plugin.rcra56.domain.HazardousWastePermitDataType;
import com.windsor.node.plugin.rcra56.domain.OperationType;
import com.windsor.node.plugin.rcra56.domain.SubmissionHistory;

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
