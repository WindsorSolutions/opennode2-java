package com.windsor.node.plugin.icisnpdes.domain;

import javax.persistence.*;
import javax.xml.bind.annotation.XmlTransient;

import com.windsor.node.plugin.icisnpdes.generated.SWConstructionPermit;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;

/**
 * Specifies how to access address and contact info for
 * {@link SWConstructionPermit} data.
 *
 */
@MappedSuperclass
public abstract class AbstractSWConstructionPermitData extends AbstractAddressContactEntity {

	@XmlTransient
	@Transient
	private Logger logger = LoggerFactory.getLogger(AbstractSWConstructionPermitData.class);

	/**
	 * Returns the {@link SWConstructionPermit} object. The generated class will
	 * override this method.
	 *
	 * @return the {@link SWConstructionPermit} object
	 */
	@Transient
	public abstract SWConstructionPermit getSWConstructionPermit();

    @XmlTransient
    @Transient
    protected String constructionSiteOtherText;

	@Override
	@Transient
	public IAddressList getAddressList() {
		IAddressList list = null;
		final SWConstructionPermit permit = getSWConstructionPermit();
		if (permit != null) {
			list = permit.getStormWaterAddress();
		}
		return list;
	}

	@Override
	public void nullAddress() {
		final SWConstructionPermit permit = getSWConstructionPermit();
		if (permit != null) {
			permit.setStormWaterAddress(null);
		}
	}

	@Override
	@Transient
	public IContactList getContactList() {
		IContactList list = null;
		final SWConstructionPermit permit = getSWConstructionPermit();
		if (permit != null) {
			list = permit.getStormWaterContact();
		}
		return list;
	}

	@Override
	public void nullContact() {
		final SWConstructionPermit permit = getSWConstructionPermit();
		if (permit != null) {
			permit.setStormWaterContact(null);
		}
	}

    /**
     * Gets the value of the constructionSiteOtherText property.
     *
     * @return
     *     possible object is
     *     {@link String }
     *
     */
    @Basic
    @Column(name = "CNST_SITE_OTHR_TXT", length = 100)
    public String getConstructionSiteOtherText() {
        return constructionSiteOtherText;
    }

    /**
     * Sets the value of the constructionSiteOtherText property.
     *
     * @param value
     *     allowed object is
     *     {@link String }
     *
     */
    public void setConstructionSiteOtherText(String value) {
        this.constructionSiteOtherText = value;
    }

    /**
     * After the data is loaded, checks whether the contact and/or address field
     * needs to be nulled out, based on the whether there are indeed any
     * addresses or contacts.
     */
    @PostLoad
    public void handlePostLoad() {
        handleAddressPostLoad();
        handleContactPostLoad();
        handleConstructionSiteListPostLoad();
    }

    /**
     * Nulls out the address field if there are no addresses in the list.
     */
    protected void handleAddressPostLoad() {
        final IAddressList addresses = getAddressList();
        if (addresses != null) {
            final List<?> list = addresses.getAddress();
            if (list == null || list.isEmpty()) {
                nullAddress();
            }
        }
    }

    /**
     * Nulls out the contact field if there are no contacts in the list.
     */
    protected void handleContactPostLoad() {
        final IContactList contacts = getContactList();
        if (contacts != null) {
            final List<?> list = contacts.getContact();
            if (list == null || list.isEmpty()) {
                nullContact();
            }
        }
    }

    /**
     * Nulls out the construction site list field if there are no addresses in the list.
     */
    protected void handleConstructionSiteListPostLoad() {
        logger.info("Handling post-load for ConstructionSiteList");
        final SWConstructionPermit permit = getSWConstructionPermit();
        if (getConstructionSiteOtherText() != null && getConstructionSiteOtherText().trim().length() > 0) {
            if (permit.getConstructionSiteList() != null) {
                permit.getConstructionSiteList().setConstructionSiteOtherText(getConstructionSiteOtherText());
            }
        }
    }
}
