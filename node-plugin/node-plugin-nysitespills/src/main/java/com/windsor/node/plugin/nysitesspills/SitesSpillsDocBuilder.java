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

package com.windsor.node.plugin.nysitesspills;

import java.io.IOException;
import java.io.OutputStreamWriter;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.sql.DataSource;

import com.windsor.node.common.domain.ProcessContentResult;
import com.windsor.node.plugin.common.BaseDocumentBuilder;
import com.windsor.node.plugin.nysitesspills.dao.ControlDao;
import com.windsor.node.plugin.nysitesspills.dao.ControlElementDao;
import com.windsor.node.plugin.nysitesspills.dao.DerProgramDao;
import com.windsor.node.plugin.nysitesspills.dao.ErAdjacentPropertyDao;
import com.windsor.node.plugin.nysitesspills.dao.ErClassChangeDao;
import com.windsor.node.plugin.nysitesspills.dao.ErClassHistoryDao;
import com.windsor.node.plugin.nysitesspills.dao.ErMaterialDao;
import com.windsor.node.plugin.nysitesspills.dao.ErOpUnitDao;
import com.windsor.node.plugin.nysitesspills.dao.ErPetitionFiledDao;
import com.windsor.node.plugin.nysitesspills.dao.ErProjectDao;
import com.windsor.node.plugin.nysitesspills.dao.ErRemedyDao;
import com.windsor.node.plugin.nysitesspills.dao.ErSiteDao;
import com.windsor.node.plugin.nysitesspills.dao.MaterialCodeDao;
import com.windsor.node.plugin.nysitesspills.dao.MaterialFamilyCodeDao;
import com.windsor.node.plugin.nysitesspills.dao.MediaAffectedCodeDao;
import com.windsor.node.plugin.nysitesspills.dao.MediaAffectedDao;
import com.windsor.node.plugin.nysitesspills.dao.ProgramAffiliationDao;
import com.windsor.node.plugin.nysitesspills.dao.ProgramGeoLocDao;
import com.windsor.node.plugin.nysitesspills.dao.SpTankTestDao;
import com.windsor.node.plugin.nysitesspills.dao.SpillDao;
import com.windsor.node.plugin.nysitesspills.domain.Control;
import com.windsor.node.plugin.nysitesspills.domain.DerProgram;
import com.windsor.node.plugin.nysitesspills.domain.ErAdjacentProperty;
import com.windsor.node.plugin.nysitesspills.domain.ErMaterial;
import com.windsor.node.plugin.nysitesspills.domain.ErOpUnit;
import com.windsor.node.plugin.nysitesspills.domain.ErSite;
import com.windsor.node.plugin.nysitesspills.domain.Spill;

public abstract class SitesSpillsDocBuilder extends BaseDocumentBuilder {

    protected SitesSpillsXmlGenerator gen;

    /**
     * Forces the SitesSpillsXmlGenerator to look for Velocity templates on the
     * filesystem in the specified directory.
     */
    protected SitesSpillsDocBuilder(String templatePath) {

        super();
        gen = new SitesSpillsXmlGenerator(templatePath);
    }

    public abstract void buildDocument(DataSource ds, String targetFilePath,
            ProcessContentResult result);

    public abstract void buildDocument(DataSource ds, String targetFilePath,
            ProcessContentResult result, int maxListItems);

    protected void buildDerProgramsList(DataSource ds, OutputStreamWriter out,
            int maxDerPrograms) throws IOException {

        DerProgramDao dao = new DerProgramDao();
        dao.setDataSource(ds);

        List derPrograms = null;

        if (maxDerPrograms > 0) {

            derPrograms = dao.getDerProgramsAndFacilities(maxDerPrograms);

        } else {

            derPrograms = dao.getDerProgramsAndFacilities();
        }

        buildDerProgramsList(derPrograms, ds, out);
        derPrograms = null;

    }

    protected void buildDerProgramsList(List derPrograms, DataSource ds,
            OutputStreamWriter out) throws IOException {

        gen.writeDerProgramsListOpen(out);

        Iterator iter = derPrograms.iterator();

        while (iter.hasNext()) {

            DerProgram program = (DerProgram) iter.next();

            gen.writeDerProgramBody(out, program);

            int programSeqNum = program.getProgramSequenceNum().intValue();

            buildProgramAffiliations(ds, out, programSeqNum);
            buildErOpUnits(ds, out, programSeqNum);
            buildProgramGeoLocs(ds, out, programSeqNum);
            buildErSite(ds, out, programSeqNum);
            buildSpills(ds, out, programSeqNum);

            gen.writeDerProgramClose(out, program);
        }

        gen.writeDerProgramsListClose(out);

    }

    protected void buildProgramAffiliations(DataSource ds,
            OutputStreamWriter out, int programSeqNum) throws IOException {

        ProgramAffiliationDao dao = new ProgramAffiliationDao();
        dao.setDataSource(ds);

        List affiliations = dao.getAffiliationsForProgramSeqNum(programSeqNum);

        gen.writeProgramAffiliations(out, affiliations);
        affiliations = null;
    }

    protected void buildErOpUnits(DataSource ds, OutputStreamWriter out,
            int programSeqNum) throws IOException {

        ErOpUnitDao dao = new ErOpUnitDao();
        dao.setDataSource(ds);

        List opUnits = dao.getOpUnitsForProgramSeqNum(programSeqNum);

        Iterator iter = opUnits.iterator();

        while (iter.hasNext()) {

            ErOpUnit unit = (ErOpUnit) iter.next();

            int opUnitSeqNum = unit.getOpUnitSequenceNum().intValue();

            gen.writeErOpUnitBody(out, unit);

            buildErRemedies(ds, out, opUnitSeqNum);
            buildErProjects(ds, out, opUnitSeqNum);
            buildErMaterials(ds, out, opUnitSeqNum);

            gen.writeErOpUnitClose(out, unit);
        }
        opUnits = null;
    }

    protected void buildErRemedies(DataSource ds, OutputStreamWriter out,
            int opUnitSeqNum) throws IOException {

        ErRemedyDao dao = new ErRemedyDao();
        dao.setDataSource(ds);

        List remedies = dao.getRemediesForOpUnitSeqNum(opUnitSeqNum);

        gen.writeErRemedies(out, remedies);
        remedies = null;

    }

    protected void buildErProjects(DataSource ds, OutputStreamWriter out,
            int opUnitSeqNum) throws IOException {

        ErProjectDao dao = new ErProjectDao();
        dao.setDataSource(ds);

        List projects = dao.getProjectsForOpUnitSeqNum(opUnitSeqNum);

        gen.writeErProjects(out, projects);
        projects = null;

    }

    protected void buildErMaterials(DataSource ds, OutputStreamWriter out,
            int opUnitSeqNum) throws IOException {

        ErMaterialDao dao = new ErMaterialDao();
        dao.setDataSource(ds);

        List materials = dao.getMaterialsForOpUnitSeqNum(opUnitSeqNum);

        Iterator iter = materials.iterator();

        while (iter.hasNext()) {

            ErMaterial material = (ErMaterial) iter.next();
            int matSeqNum = material.getMaterialSequenceNum().intValue();

            gen.writeErMaterialBody(out, material);

            buildMediaAffected(ds, out, matSeqNum);

            gen.writeErMaterialClose(out, material);

        }
        materials = null;
    }

    protected void buildProgramGeoLocs(DataSource ds, OutputStreamWriter out,
            int programSeqNum) throws IOException {

        ProgramGeoLocDao dao = new ProgramGeoLocDao();
        dao.setDataSource(ds);

        List geoLocs = dao.getProgramGeoLocsForProgramSeqNum(programSeqNum);

        gen.writeProgramGeoLocs(out, geoLocs);
        geoLocs = null;
    }

    protected void buildErSite(DataSource ds, OutputStreamWriter out,
            int programSeqNum) throws IOException {

        ErSiteDao dao = new ErSiteDao();
        dao.setDataSource(ds);

        ErSite erSite = dao.getErSiteForProgramSeqNum(programSeqNum);

        if (null != erSite) {
            int siteSeqNum = erSite.getSiteSequenceNum().intValue();

            gen.writeErSiteBody(out, erSite);

            buildErAdjacentProperty(ds, out, siteSeqNum);
            buildErClassHistory(ds, out, siteSeqNum);
            buildErClassChange(ds, out, siteSeqNum);
            buildErPetitionsFiled(ds, out, siteSeqNum);

            gen.writeErSiteClose(out, erSite);
            erSite = null;
        }
    }

    protected void buildErAdjacentProperty(DataSource ds,
            OutputStreamWriter out, int siteSeqNum) throws IOException {

        ErAdjacentPropertyDao dao = new ErAdjacentPropertyDao();
        dao.setDataSource(ds);

        List properties = dao.getErAdjacentPropertiesForSiteSeqNum(siteSeqNum);

        Iterator iter = properties.iterator();

        while (iter.hasNext()) {

            ErAdjacentProperty adjacentProp = (ErAdjacentProperty) iter.next();

            int adjPropSeqNum = adjacentProp.getAdjacentPropertySequenceNum()
                    .intValue();

            gen.writeErAdjacentPropertyBody(out, adjacentProp);

            buildControls(ds, out, adjPropSeqNum);

            gen.writeErAdjacentPropertyClose(out, adjacentProp);

        }
        properties = null;
    }

    protected void buildControls(DataSource ds, OutputStreamWriter out,
            int adjPropSeqNum) throws IOException {

        ControlDao dao = new ControlDao();
        dao.setDataSource(ds);

        List controls = dao.getControlsForAdjacentPropertySeqNum(adjPropSeqNum);

        Iterator iter = controls.iterator();

        while (iter.hasNext()) {

            Control control = (Control) iter.next();

            int controlSeqNum = control.getControlSequenceNum().intValue();

            gen.writeControlBody(out, control);

            buildControlElements(ds, out, controlSeqNum);

            gen.writeControlClose(out, control);
        }
        controls = null;
    }

    protected void buildControlElements(DataSource ds, OutputStreamWriter out,
            int controlSeqNum) throws IOException {

        ControlElementDao dao = new ControlElementDao();
        dao.setDataSource(ds);

        List elements = dao.getControlElementsForControlSeqNum(controlSeqNum);

        gen.writeControlElements(out, elements);
        elements = null;
    }

    protected void buildErClassHistory(DataSource ds, OutputStreamWriter out,
            int siteSeqNum) throws IOException {

        ErClassHistoryDao dao = new ErClassHistoryDao();
        dao.setDataSource(ds);

        List histories = dao.getErClassHistoriesForSiteSeqNum(siteSeqNum);

        gen.writeErClassHistories(out, histories);
        histories = null;
    }

    protected void buildErClassChange(DataSource ds, OutputStreamWriter out,
            int siteSeqNum) throws IOException {

        ErClassChangeDao dao = new ErClassChangeDao();
        dao.setDataSource(ds);

        List changes = dao.getErClassChangesForSiteSeqNum(siteSeqNum);

        gen.writeErClassChanges(out, changes);
        changes = null;
    }

    protected void buildErPetitionsFiled(DataSource ds, OutputStreamWriter out,
            int siteSeqNum) throws IOException {

        ErPetitionFiledDao dao = new ErPetitionFiledDao();
        dao.setDataSource(ds);

        List petitions = dao.getErPetitionsFiledForSiteSeqNum(siteSeqNum);

        gen.writeErPetitionsFiled(out, petitions);
        petitions = null;
    }

    protected void buildSpills(DataSource ds, OutputStreamWriter out,
            int programSeqNum) throws IOException {

        SpillDao dao = new SpillDao();
        dao.setDataSource(ds);

        Spill spill = dao.getSpillForProgramSeqNum(programSeqNum);

        if (null != spill) {

            int spillSeqNum = spill.getSpillSequenceNum().intValue();

            gen.writeSpillBody(out, spill);

            buildSpTankTests(ds, out, spillSeqNum);

            gen.writeSpillClose(out, spill);

            spill = null;
        }
    }

    protected void buildSpTankTests(DataSource ds, OutputStreamWriter out,
            int spillSeqNum) throws IOException {

        SpTankTestDao dao = new SpTankTestDao();
        dao.setDataSource(ds);

        List spTankTests = dao.getSpTankTestsForSpillSeqNum(spillSeqNum);

        gen.writeSpTankTests(out, spTankTests);
        spTankTests = null;
    }

    protected void buildMaterialCodesList(DataSource ds, OutputStreamWriter out)
            throws IOException {

        gen.writeMaterialCodesListOpen(out);

        buildMaterialCodes(ds, out);
        buildMaterialFamilyCodes(ds, out);
        buildMediaAffectedCodes(ds, out);

        gen.writeMaterialCodesListClose(out);

    }

    protected void buildMaterialCodes(DataSource ds, OutputStreamWriter out)
            throws IOException {

        MaterialCodeDao dao = new MaterialCodeDao();
        dao.setDataSource(ds);

        List matCodes = dao.getMaterialCodes();

        gen.writeMaterialCodes(out, matCodes);
        matCodes = null;
    }

    protected void buildMaterialFamilyCodes(DataSource ds,
            OutputStreamWriter out) throws IOException {

        MaterialFamilyCodeDao dao = new MaterialFamilyCodeDao();
        dao.setDataSource(ds);

        List matFamilies = dao.getMaterialFamilyCodes();

        gen.writeMaterialFamilyCodes(out, matFamilies);
        matFamilies = null;
    }

    protected void buildMediaAffected(DataSource ds, OutputStreamWriter out,
            int matSeqNum) throws IOException {

        MediaAffectedDao dao = new MediaAffectedDao();
        dao.setDataSource(ds);

        List media = dao.getMediaAffectedForMaterialSeqNum(matSeqNum);

        gen.writeMediaAffected(out, media);
        media = null;
    }

    protected void buildMediaAffectedCodes(DataSource ds, OutputStreamWriter out)
            throws IOException {

        MediaAffectedCodeDao dao = new MediaAffectedCodeDao();
        dao.setDataSource(ds);

        List media = dao.getMediaAffectedCodes();

        gen.writeMediaAffectedCodes(out, media);
        media = null;
    }

    protected void buildErMaterialList(DataSource ds, OutputStreamWriter out,
            int maxMaterials) throws IOException {

        ErMaterialDao dao = new ErMaterialDao();
        dao.setDataSource(ds);

        List materials = null;

        if (maxMaterials > 0) {

            materials = dao.getMaterials(maxMaterials);

        } else {

            materials = dao.getMaterials();

        }

        buildErMaterialList(materials, ds, out);

        materials = null;
    }

    protected void buildErMaterialList(List materials, DataSource ds,
            OutputStreamWriter out) throws IOException {

        gen.writeErMaterialListOpen(out);

        Iterator iter = materials.iterator();

        while (iter.hasNext()) {

            ErMaterial material = (ErMaterial) iter.next();
            int matSeqNum = material.getMaterialSequenceNum().intValue();

            gen.writeErMaterialBody(out, material);

            buildMediaAffected(ds, out, matSeqNum);

            gen.writeErMaterialClose(out, material);

        }

        gen.writeErMaterialListClose(out);

    }

    protected void buildAffiliationList(DataSource ds, OutputStreamWriter out,
            int maxAffiliations) throws IOException {

        ProgramAffiliationDao dao = new ProgramAffiliationDao();
        dao.setDataSource(ds);

        List affiliations = null;

        if (maxAffiliations > 0) {

            affiliations = dao.getAffiliations(maxAffiliations);

        } else {

            affiliations = dao.getAffiliations();

        }

        buildAffiliationList(affiliations, out);

        affiliations = null;
    }

    protected void buildAffiliationList(List affiliations,
            OutputStreamWriter out) throws IOException {

        gen.writeAffiliationListOpen(out);
        /*
         * A large number of Affiliations makes us run out of memory when
         * Velocity does a .toArray on the list, so we write this list in chunks
         * of 500.
         */

        logger.debug("Looping through AffiliationList");
        int loopLimit = 500;

        List shortList = new ArrayList();

        while (affiliations.size() > 0) {

            for (int i = 0; i < loopLimit; i++) {

                if (affiliations.size() <= i) {

                    break;

                } else {

                    shortList.add(affiliations.get(i));
                    affiliations.remove(i);
                }
            }

            logger.debug("Writing AffiliationList");
            gen.writeProgramAffiliations(out, shortList);

            shortList.clear();

            logger.debug(affiliations.size() + " affiliations remaining");
        }

        gen.writeAffiliationListClose(out);

        shortList = null;
    }

    protected void buildErSiteList(DataSource ds, OutputStreamWriter out,
            int maxErSites) throws IOException {

        ErSiteDao dao = new ErSiteDao();
        dao.setDataSource(ds);

        List sites = null;

        if (maxErSites > 0) {

            sites = dao.getMinimalErSitesWithSiteId(maxErSites);

        } else {

            sites = dao.getMinimalErSitesWithSiteId();
        }

        buildErSiteList(sites, out);

        sites = null;
    }

    protected void buildErSiteList(List sites, OutputStreamWriter out)
            throws IOException {

        gen.writeErSiteListOpen(out);

        gen.writeErSites(out, sites);

        gen.writeErSiteListClose(out);

    }

    protected void buildGeographicLocList(DataSource ds,
            OutputStreamWriter out, int maxGeoLocs) throws IOException {

        ProgramGeoLocDao dao = new ProgramGeoLocDao();
        dao.setDataSource(ds);

        List locations = null;

        if (maxGeoLocs > 0) {

            locations = dao.getProgramGeoLocs(maxGeoLocs);

        } else {

            locations = dao.getProgramGeoLocs();
        }

        buildGeographicLocList(locations, out);

        locations = null;
    }

    protected void buildGeographicLocList(List locations, OutputStreamWriter out)
            throws IOException {

        gen.writeGeographicLocListOpen(out);

        gen.writeProgramGeoLocs(out, locations);

        gen.writeGeographicLocListClose(out);
    }
}