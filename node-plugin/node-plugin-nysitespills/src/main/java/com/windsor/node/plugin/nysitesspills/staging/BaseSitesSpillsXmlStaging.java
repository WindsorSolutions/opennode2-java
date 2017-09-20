/*
Copyright (c) 2009, The Environmental Council of the States (ECOS)
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

 * Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
 * Neither the name of the ECOS nor the names of its contributors may
   be used to endorse or promote products derived from this software
   without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
 */

package com.windsor.node.plugin.nysitesspills.staging;

import java.util.List;
import java.util.Map;

import com.windsor.node.plugin.common.staging.BaseXmlStaging;
import com.windsor.node.plugin.nysitesspills.SitesSpillsXmlGenerator;

public abstract class BaseSitesSpillsXmlStaging extends BaseXmlStaging {

    protected static Map listElementMap;

    /**
     * Defaults to 75, based on performance testing with the large
     * &lt;DERPrograms&gt; elements.
     * 
     * <p>
     * Setting to 0 effectively disables the batchSize, so the entire input file
     * will be loaded in one shot.
     * </p>
     */
    protected int batchSize = 75;

    /**
     * Defaults to 75, based on performance testing with the large
     * &lt;DERPrograms&gt; elements.
     * 
     * <p>
     * Setting to 0 effectively disables the batchSize, so the entire input file
     * will be loaded in one shot.
     * </p>
     * 
     * @see com.windsor.node.plugin.common.staging.XmlStaging#getBatchSize()
     */
    public int getBatchSize() {

        return batchSize;
    }

    /*
     * (non-Javadoc)
     * 
     * @see com.windsor.node.plugin.common.BaseXmlStaging#setBatchSize(int)
     */
    public void setBatchSize(int size) {

        this.batchSize = size;
    }

    /*
     * (non-Javadoc)
     * 
     * @see com.windsor.node.plugin.common.BaseXmlStaging#getDocumentClose()
     */
    public String getDocumentClose() {

        return SitesSpillsXmlGenerator.DOCUMENT_CLOSE;
    }

    /*
     * (non-Javadoc)
     * 
     * @see com.windsor.node.plugin.common.BaseXmlStaging#getDocumentOpen()
     */
    public String getDocumentOpen() {

        return SitesSpillsXmlGenerator.DOCUMENT_OPEN;
    }

    /*
     * (non-Javadoc)
     * 
     * @see com.windsor.node.plugin.common.BaseXmlStaging#getListElementMap()
     */
    public Map getListElementMap() {

        return listElementMap;
    }

    /*
     * (non-Javadoc)
     * 
     * @see com.windsor.node.plugin.common.BaseXmlStaging#getListNames()
     */
    public abstract List getListNames();
}