package com.windsor.node.plugin.rcra56.service;

import javax.xml.bind.JAXBElement;

import com.windsor.node.plugin.rcra56.domain.FinancialAssuranceSubmissionDataType;
import com.windsor.node.plugin.rcra56.domain.ObjectFactory;
import com.windsor.node.plugin.rcra56.domain.OperationType;

public class RCRAFinancialAssuranceExtractAndSubmission extends AbstractRcraSubmitService<FinancialAssuranceSubmissionDataType> {

	public RCRAFinancialAssuranceExtractAndSubmission() {
		super(OperationType.FINANCIAL_ASSURANCE);
	}

	@Override
	protected FinancialAssuranceSubmissionDataType getPayloadRootEntity() {
		return getRcraDao().getFinancialAssuranceRoot();
	}

	@Override
	protected JAXBElement<FinancialAssuranceSubmissionDataType> getPayloadRootElement(ObjectFactory objectFactory,
			FinancialAssuranceSubmissionDataType rootEntity) {
		return objectFactory.createFinancialAssuranceSubmission(rootEntity);
	}

}
