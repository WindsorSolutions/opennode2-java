package com.windsor.node.hyperjaxb3;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;

import com.sun.java.xml.ns.persistence.orm.Basic;
import org.jvnet.annox.model.XAnnotation;
import org.jvnet.hyperjaxb3.ejb.jpa2.strategy.annotate.CreateXAnnotations;

import com.sun.java.xml.ns.persistence.orm.ElementCollection;

/**
 * Extends {@link CreateXAnnotations} to disable the creation of the
 * {@link OrderColumn} annotation for {@link ElementCollection} annotations.
 *
 */
public class NodeCreateXAnnotations extends CreateXAnnotations {

	private boolean createOrderColumn = false;
	private boolean createEnumerated = true;

	public boolean isCreateOrderColumn() {
		return createOrderColumn;
	}

	public void setCreateOrderColumn(boolean createOrderColumn) {
		this.createOrderColumn = createOrderColumn;
	}

	public boolean isCreateEnumerated() {
		return createEnumerated;
	}

	public void setCreateEnumerated(boolean createEnumerated) {
		this.createEnumerated = createEnumerated;
	}

	private Collection<XAnnotation> getBasicAnnotations(Basic cBasic) {
		Collection<XAnnotation> allList = Arrays.asList(
				createBasic(cBasic),
				//
				createColumn(cBasic.getColumn()),
				//
				createLob(cBasic.getLob()),
				//
				createTemporal(cBasic.getTemporal()),
				//
				createEnumerated(isCreateEnumerated() ? cBasic.getEnumerated() : null));
		return allList;
	}

	private Collection<XAnnotation> getNonNullAnnotations(final ElementCollection source) {
		Collection<XAnnotation> allList = Arrays.asList(
				createElementCollection(source),
				//
				createOrderBy(source.getOrderBy()),
				//
				isCreateOrderColumn() ? createOrderColumn(source.getOrderColumn()) : null,
				//
				createMapKey(source.getMapKey()),
				//
				createMapKeyClass(source.getMapKeyClass()),
				//
				createMapKeyTemporal(source.getMapKeyTemporal()),
				//
				createMapKeyEnumerated(source.getMapKeyEnumerated()),
				//
				createAttributeOverrides(source.getMapKeyAttributeOverride()),
				//
				createMapKeyColumn(source.getMapKeyColumn()),
				//
				createMapKeyJoinColumns(source.getMapKeyJoinColumn()),
				//
				createColumn(source.getColumn()),
				//
				createTemporal(source.getTemporal()),
				//
				createEnumerated(isCreateEnumerated() ? source.getEnumerated() : null), // : null,
				//
				createLob(source.getLob()),
				//
				createAttributeOverrides(source.getAttributeOverride()),
				//
				createAssociationOverrides(source.getAssociationOverride()),
				//
				createCollectionTable(source.getCollectionTable()),
				//
				createAccess(source.getAccess())
		);
		Collection<XAnnotation> nonNullList = new ArrayList<>();
		for (XAnnotation xa : allList) {
			if (xa != null) {
				nonNullList.add(xa);
			}
		}
		return nonNullList;
	}

	@Override
	public Collection<XAnnotation> createElementCollectionAnnotations(final ElementCollection source) {
		Collection<XAnnotation> annotations;
		if (source == null) {
			annotations = Collections.<XAnnotation> emptyList();
		} else {
			Collection<XAnnotation> nonNullAnnotations = getNonNullAnnotations(source);
			annotations = annotations(nonNullAnnotations.toArray(new XAnnotation[0]));
		}
		return annotations;
	}

	@Override
	public Collection<XAnnotation> createBasicAnnotations(Basic cBasic) {
		return cBasic == null ? Collections.<XAnnotation> emptyList() : getBasicAnnotations(cBasic);
	}

}
