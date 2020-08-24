package com.windsor.node.plugin.rcra.inbound.service;

import javax.xml.bind.JAXBElement;

import com.windsor.node.plugin.rcra.inbound.domain.HazardousWastePermitDataType;
import com.windsor.node.plugin.rcra.inbound.domain.ObjectFactory;
import com.windsor.node.plugin.rcra.inbound.domain.OperationType;

public class RCRAPermittingExtractAndSubmission extends AbstractRcraSubmitService<HazardousWastePermitDataType> {

	public RCRAPermittingExtractAndSubmission() {
		super(OperationType.PERMITTING);
	}

	@Override
	protected HazardousWastePermitDataType getPayloadRootEntity() {
		return getRcraDao().getPermitRoot();
	}

	@Override
	protected JAXBElement<HazardousWastePermitDataType> getPayloadRootElement(ObjectFactory objectFactory,
			HazardousWastePermitDataType rootEntity) {
		return objectFactory.createHazardousWastePermitSubmission(rootEntity);
	}

}
