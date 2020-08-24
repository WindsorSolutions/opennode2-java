package com.windsor.node.plugin.rcra.inbound.service;

import javax.xml.bind.JAXBElement;

import com.windsor.node.plugin.rcra.inbound.domain.FinancialAssuranceSubmissionDataType;
import com.windsor.node.plugin.rcra.inbound.domain.ObjectFactory;
import com.windsor.node.plugin.rcra.inbound.domain.OperationType;

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
