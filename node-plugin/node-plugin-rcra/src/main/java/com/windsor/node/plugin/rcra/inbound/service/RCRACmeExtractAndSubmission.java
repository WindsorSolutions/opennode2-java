package com.windsor.node.plugin.rcra.inbound.service;

import javax.xml.bind.JAXBElement;

import com.windsor.node.plugin.rcra.inbound.domain.HazardousWasteCMESubmissionDataType;
import com.windsor.node.plugin.rcra.inbound.domain.ObjectFactory;
import com.windsor.node.plugin.rcra.inbound.domain.OperationType;

public class RCRACmeExtractAndSubmission extends AbstractRcraSubmitService<HazardousWasteCMESubmissionDataType> {

	public RCRACmeExtractAndSubmission() {
		super(OperationType.CME);
	}

	@Override
	protected JAXBElement<HazardousWasteCMESubmissionDataType> getPayloadRootElement(ObjectFactory objectFactory, HazardousWasteCMESubmissionDataType entity) {
		return objectFactory.createHazardousWasteCMESubmission(entity);
	}

	@Override
	protected HazardousWasteCMESubmissionDataType getPayloadRootEntity() {
		return getRcraDao().getCmeRoot();
	}
	
}
