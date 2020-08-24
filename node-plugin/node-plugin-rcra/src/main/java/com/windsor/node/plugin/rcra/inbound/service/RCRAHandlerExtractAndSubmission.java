package com.windsor.node.plugin.rcra.inbound.service;

import javax.xml.bind.JAXBElement;

import com.windsor.node.plugin.rcra.inbound.domain.HazardousWasteHandlerSubmissionDataType;
import com.windsor.node.plugin.rcra.inbound.domain.ObjectFactory;
import com.windsor.node.plugin.rcra.inbound.domain.OperationType;

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
