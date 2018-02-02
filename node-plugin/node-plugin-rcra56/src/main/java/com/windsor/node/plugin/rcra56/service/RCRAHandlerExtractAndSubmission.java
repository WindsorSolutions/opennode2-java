package com.windsor.node.plugin.rcra56.service;

import javax.xml.bind.JAXBElement;

import com.windsor.node.plugin.rcra56.domain.HazardousWasteHandlerSubmissionDataType;
import com.windsor.node.plugin.rcra56.domain.ObjectFactory;
import com.windsor.node.plugin.rcra56.domain.OperationType;

public class RCRAHandlerExtractAndSubmission extends AbstractRcraSubmitService<HazardousWasteHandlerSubmissionDataType> {

	public RCRAHandlerExtractAndSubmission() {
		super(OperationType.HANDLER);
	}

	@Override
	protected HazardousWasteHandlerSubmissionDataType getPayloadRootEntity() {
		return getRcraDao().getHandlerRoot();
	}

	@Override
	protected JAXBElement<HazardousWasteHandlerSubmissionDataType> getPayloadRootElement(ObjectFactory objectFactory,
			HazardousWasteHandlerSubmissionDataType rootEntity) {
		return objectFactory.createHazardousWasteHandlerSubmission(rootEntity);
	}

}
