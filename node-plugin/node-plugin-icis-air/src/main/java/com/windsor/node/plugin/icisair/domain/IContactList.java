package com.windsor.node.plugin.icisair.domain;

import java.util.List;

/**
 * Defines how to get the list of contacts.
 *
 */
public interface IContactList {

	/**
	 * Returns the list of contacts
	 * @return list of contacts
	 */
	List<?> getContact();

}
