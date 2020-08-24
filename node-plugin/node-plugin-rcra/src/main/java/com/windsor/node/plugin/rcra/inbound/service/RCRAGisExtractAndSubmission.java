package com.windsor.node.plugin.rcra.inbound.service;

import javax.xml.bind.JAXBElement;

import com.windsor.node.plugin.rcra.inbound.domain.GeographicInformationSubmissionDataType;
import com.windsor.node.plugin.rcra.inbound.domain.ObjectFactory;
import com.windsor.node.plugin.rcra.inbound.domain.OperationType;

public class RCRAGisExtractAndSubmission extends AbstractRcraSubmitService<GeographicInformationSubmissionDataType> {

	public RCRAGisExtractAndSubmission() {
		super(OperationType.GIS);
	}

	@Override
	protected GeographicInformationSubmissionDataType getPayloadRootEntity() {
		return getRcraDao().getGisRoot();
	}

	@Override
	protected JAXBElement<GeographicInformationSubmissionDataType> getPayloadRootElement(ObjectFactory objectFactory,
			GeographicInformationSubmissionDataType rootEntity) {
		return objectFactory.createGeographicInformationSubmission(rootEntity);
	}

}
