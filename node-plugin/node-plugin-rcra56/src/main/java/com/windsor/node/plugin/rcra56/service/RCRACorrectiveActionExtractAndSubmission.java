package com.windsor.node.plugin.rcra56.service;

import javax.xml.bind.JAXBElement;

import com.windsor.node.plugin.rcra56.domain.HazardousWasteCorrectiveActionDataType;
import com.windsor.node.plugin.rcra56.domain.ObjectFactory;
import com.windsor.node.plugin.rcra56.domain.OperationType;

public class RCRACorrectiveActionExtractAndSubmission extends AbstractRcraSubmitService<HazardousWasteCorrectiveActionDataType> {

	public RCRACorrectiveActionExtractAndSubmission() {
		super(OperationType.CORRECTIVE_ACTION);
	}

	@Override
	protected HazardousWasteCorrectiveActionDataType getPayloadRootEntity() {
		return getRcraDao().getCorrectiveActionRoot();
	}

	@Override
	protected JAXBElement<HazardousWasteCorrectiveActionDataType> getPayloadRootElement(ObjectFactory objectFactory,
			HazardousWasteCorrectiveActionDataType rootEntity) {
		return objectFactory.createHazardousWasteCorrectiveActionSubmission(rootEntity);
	}

}
