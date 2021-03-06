package com.windsor.node.plugin.icisnpdes.domain;

import javax.persistence.MappedSuperclass;
import javax.persistence.Transient;

import com.windsor.node.plugin.icisnpdes.generated.BiosolidsPermit;

/**
 * Specifies how to access address and contact info for {@link BiosolidsPermit}
 * data.
 *
 */
@MappedSuperclass
public abstract class AbstractBiosolidsPermitData extends AbstractAddressContactEntity {

	/**
	 * Returns the {@link BiosolidsPermit} object. The generated class will
	 * override this method.
	 *
	 * @return the {@link BiosolidsPermit} object
	 */
	@Transient
	public abstract BiosolidsPermit getBiosolidsPermit();

	@Override
	@Transient
	public IAddressList getAddressList() {
		IAddressList list = null;
		final BiosolidsPermit permit = getBiosolidsPermit();
		if (permit != null) {
			list = permit.getBiosolidsPermitAddress();
		}
		return list;
	}

	@Override
	public void nullAddress() {
		final BiosolidsPermit permit = getBiosolidsPermit();
		if (permit != null) {
			permit.setBiosolidsPermitAddress(null);
		}
	}

	@Override
	@Transient
	public IContactList getContactList() {
		IContactList list = null;
		final BiosolidsPermit permit = getBiosolidsPermit();
		if (permit != null) {
			list = permit.getBiosolidsPermitContact();
		}
		return list;
	}

	@Override
	public void nullContact() {
		final BiosolidsPermit permit = getBiosolidsPermit();
		if (permit != null) {
			permit.setBiosolidsPermitContact(null);
		}
	}

}
