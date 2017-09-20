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

import java.io.File;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.StringWriter;
import java.util.Date;
import java.util.List;

import com.windsor.node.plugin.common.VelocityXmlGenerator;
import com.windsor.node.plugin.nysitesspills.domain.Control;
import com.windsor.node.plugin.nysitesspills.domain.DerProgram;
import com.windsor.node.plugin.nysitesspills.domain.ErAdjacentProperty;
import com.windsor.node.plugin.nysitesspills.domain.ErOpUnit;
import com.windsor.node.plugin.nysitesspills.domain.ErSite;
import com.windsor.node.plugin.nysitesspills.domain.Spill;

public class SitesSpillsXmlGenerator extends VelocityXmlGenerator {

    public static final String DOCUMENT_OPEN = "<UISExchange schemaVersion=\"3.\" xmlns=\"http://www.exchangenetwork.net/schema/UIS/1\">";
    public static final String DOCUMENT_CLOSE = "</UISExchange>";

    public static final String DER_PROGRAMS_LIST_OPEN = "<DERProgramsList>";
    public static final String DER_PROGRAMS_LIST_CLOSE = "</DERProgramsList>";

    public static final String MATERIAL_CODES_LIST_OPEN = "<MaterialCodesList>";
    public static final String MATERIAL_CODES_LIST_CLOSE = "</MaterialCodesList>";

    public static final String ER_MATERIAL_LIST_OPEN = "<ERMaterialList>";
    public static final String ER_MATERIAL_LIST_CLOSE = "</ERMaterialList>";

    public static final String AFFILIATION_LIST_OPEN = "<AffiliationList>";
    public static final String AFFILIATION_LIST_CLOSE = "</AffiliationList>";

    public static final String ER_SITE_LIST_OPEN = "<ERSiteList>";
    public static final String ER_SITE_LIST_CLOSE = "</ERSiteList>";

    public static final String GEO_LOC_LIST_OPEN = "<GeographicLocList>";
    public static final String GEO_LOC_LIST_CLOSE = "</GeographicLocList>";

    public static final String TEMPLATE_PATH = File.separator + "templates";

    public SitesSpillsXmlGenerator(String templatePath) {

        super(templatePath + TEMPLATE_PATH);

    }

    public void writeDocumentOpen(OutputStreamWriter out) throws IOException {

        Date now = new Date();
        out.write(XML_DECLARATION + LINE_SEP);
        out.write("<!-- Remediation Sites and Spills Exchange -->" + LINE_SEP);
        out.write("<!-- Created on " + now.toString() + " -->" + LINE_SEP);
        out.write(DOCUMENT_OPEN + LINE_SEP);
    }

    public void writeDocumentClose(OutputStreamWriter out) throws IOException {

        out.write(DOCUMENT_CLOSE + LINE_SEP);
    }

    public void writeDerProgramsListOpen(OutputStreamWriter out)
            throws IOException {

        out.write(TAB + DER_PROGRAMS_LIST_OPEN);
        out.write(LINE_SEP);
        out.flush();
    }

    public void writeDerProgramsListClose(OutputStreamWriter out)
            throws IOException {

        out.write(TAB + DER_PROGRAMS_LIST_CLOSE);
        out.write(LINE_SEP);
        out.flush();
    }

    public void writeMaterialCodesListOpen(OutputStreamWriter out)
            throws IOException {

        out.write(TAB + MATERIAL_CODES_LIST_OPEN);
        out.write(LINE_SEP);
        out.flush();
    }

    public void writeMaterialCodesListClose(OutputStreamWriter out)
            throws IOException {

        out.write(TAB + MATERIAL_CODES_LIST_CLOSE);
        out.write(LINE_SEP);
        out.flush();
    }

    public void writeErMaterialListOpen(OutputStreamWriter out)
            throws IOException {

        out.write(TAB + ER_MATERIAL_LIST_OPEN);
        out.write(LINE_SEP);
        out.flush();
    }

    public void writeErMaterialListClose(OutputStreamWriter out)
            throws IOException {

        out.write(TAB + ER_MATERIAL_LIST_CLOSE);
        out.write(LINE_SEP);
        out.flush();
    }

    public void writeAffiliationListOpen(OutputStreamWriter out)
            throws IOException {

        out.write(TAB + AFFILIATION_LIST_OPEN);
        out.write(LINE_SEP);
        out.flush();
    }

    public void writeAffiliationListClose(OutputStreamWriter out)
            throws IOException {

        out.write(TAB + AFFILIATION_LIST_CLOSE);
        out.write(LINE_SEP);
        out.flush();
    }

    public void writeErSiteListOpen(OutputStreamWriter out) throws IOException {

        out.write(TAB + ER_SITE_LIST_OPEN);
        out.write(LINE_SEP);
        out.flush();
    }

    public void writeErSiteListClose(OutputStreamWriter out) throws IOException {

        out.write(TAB + ER_SITE_LIST_CLOSE);
        out.write(LINE_SEP);
        out.flush();
    }

    public void writeGeographicLocListOpen(OutputStreamWriter out)
            throws IOException {

        out.write(TAB + GEO_LOC_LIST_OPEN);
        out.write(LINE_SEP);
        out.flush();
    }

    public void writeGeographicLocListClose(OutputStreamWriter out)
            throws IOException {

        out.write(TAB + GEO_LOC_LIST_CLOSE);
        out.write(LINE_SEP);
        out.flush();
    }

    public StringWriter genDerProgramBody(Object templateData) {

        return genItem("program", "DerProgram_body.vm", templateData);
    }

    public StringWriter genDerProgramClose(Object templateData) {

        return genItem("program", "DerProgram_end.vm", templateData);
    }

    public void writeDerProgramBody(OutputStreamWriter out, DerProgram dp)
            throws IOException {

        out.write(genDerProgramBody(dp).toString());
        out.flush();
    }

    public void writeDerProgramClose(OutputStreamWriter out, DerProgram dp)
            throws IOException {

        out.write(genDerProgramClose(dp).toString());
        out.flush();
    }

    public StringWriter genProgramAffiliations(List templateData) {

        return genList("affiliations", "ProgramAffiliation.vm", templateData);
    }

    public void writeProgramAffiliations(OutputStreamWriter out, List paList)
            throws IOException {

        out.write(genProgramAffiliations(paList).toString());
        out.flush();
    }

    public StringWriter genErOpUnitBody(Object templateData) {

        return genItem("unit", "ErOpUnit_body.vm", templateData);
    }

    public void writeErOpUnitBody(OutputStreamWriter out, ErOpUnit unit)
            throws IOException {

        out.write(genErOpUnitBody(unit).toString());
        out.flush();
    }

    public StringWriter genErOpUnitClose(Object templateData) {

        return genItem("unit", "ErOpUnit_end.vm", templateData);
    }

    public void writeErOpUnitClose(OutputStreamWriter out, ErOpUnit unit)
            throws IOException {

        out.write(genErOpUnitClose(unit).toString());
        out.flush();
    }

    public StringWriter genErRemedies(List templateData) {

        return genList("remedies", "ErRemedy.vm", templateData);
    }

    public void writeErRemedies(OutputStreamWriter out, List remedyList)
            throws IOException {

        out.write(genErRemedies(remedyList).toString());
        out.flush();
    }

    public StringWriter genErProjects(List templateData) {

        return genList("projects", "ErProject.vm", templateData);
    }

    public void writeErProjects(OutputStreamWriter out, List projectList)
            throws IOException {

        out.write(genErProjects(projectList).toString());
        out.flush();
    }

    public StringWriter genErMaterialBody(Object templateData) {

        return genItem("material", "ErMaterial_body.vm", templateData);
    }

    public void writeErMaterialBody(OutputStreamWriter out, Object material)
            throws IOException {

        out.write(genErMaterialBody(material).toString());
        out.flush();
    }

    public StringWriter genErMaterialClose(Object templateData) {

        return genItem("material", "ErMaterial_end.vm", templateData);
    }

    public void writeErMaterialClose(OutputStreamWriter out, Object material)
            throws IOException {

        out.write(genErMaterialClose(material).toString());
        out.flush();
    }

    public StringWriter genMediaAffected(List templateData) {

        return genList("media", "MediaAffected.vm", templateData);
    }

    public void writeMediaAffected(OutputStreamWriter out, List mediaList)
            throws IOException {

        out.write(genMediaAffected(mediaList).toString());
        out.flush();
    }

    public StringWriter genProgramGeoLocs(List templateData) {

        return genList("locations", "ProgramGeoLoc.vm", templateData);
    }

    public void writeProgramGeoLocs(OutputStreamWriter out, List locationsList)
            throws IOException {

        out.write(genProgramGeoLocs(locationsList).toString());
        out.flush();
    }

    public StringWriter genErSiteBody(Object templateData) {

        return genItem("site", "ErSite_body.vm", templateData);
    }

    public StringWriter genErSiteClose(Object templateData) {

        return genItem("site", "ErSite_end.vm", templateData);
    }

    public void writeErSiteBody(OutputStreamWriter out, ErSite site)
            throws IOException {

        out.write(genErSiteBody(site).toString());
        out.flush();
    }

    public void writeErSiteClose(OutputStreamWriter out, ErSite site)
            throws IOException {

        out.write(genErSiteClose(site).toString());
        out.flush();
    }

    public void writeErSites(OutputStreamWriter out, List sites)
            throws IOException {

        for (int i = 0; i < sites.size(); i++) {

            ErSite site = (ErSite) sites.get(i);
            writeErSiteBody(out, site);
            writeErSiteClose(out, site);

        }
    }

    public StringWriter genErAdjacentPropertyBody(Object templateData) {

        return genItem("property", "ErAdjacentProperty_body.vm", templateData);
    }

    public StringWriter genErAdjacentPropertyClose(Object templateData) {

        return genItem("property", "ErAdjacentProperty_end.vm", templateData);
    }

    public void writeErAdjacentPropertyBody(OutputStreamWriter out,
            ErAdjacentProperty property) throws IOException {

        out.write(genErAdjacentPropertyBody(property).toString());
        out.flush();
    }

    public void writeErAdjacentPropertyClose(OutputStreamWriter out,
            ErAdjacentProperty property) throws IOException {

        out.write(genErAdjacentPropertyClose(property).toString());
        out.flush();
    }

    public StringWriter genControlBody(Object templateData) {

        return genItem("control", "Control_body.vm", templateData);
    }

    public StringWriter genControlClose(Object templateData) {

        return genItem("control", "Control_end.vm", templateData);
    }

    public void writeControlBody(OutputStreamWriter out, Control control)
            throws IOException {

        out.write(genControlBody(control).toString());
        out.flush();
    }

    public void writeControlClose(OutputStreamWriter out, Control control)
            throws IOException {

        out.write(genControlClose(control).toString());
        out.flush();
    }

    public StringWriter genControlElements(List templateData) {

        return genList("elements", "ControlElement.vm", templateData);
    }

    public void writeControlElements(OutputStreamWriter out, List elementsList)
            throws IOException {

        out.write(genControlElements(elementsList).toString());
        out.flush();
    }

    public StringWriter genErClassHistories(List templateData) {

        return genList("histories", "ErClassHistory.vm", templateData);
    }

    public void writeErClassHistories(OutputStreamWriter out, List historyList)
            throws IOException {

        out.write(genErClassHistories(historyList).toString());
        out.flush();
    }

    public StringWriter genErClassChanges(List templateData) {

        return genList("changes", "ErClassChange.vm", templateData);
    }

    public void writeErClassChanges(OutputStreamWriter out, List changeList)
            throws IOException {

        out.write(genErClassChanges(changeList).toString());
        out.flush();
    }

    public StringWriter genErPetitionsFiled(List templateData) {

        return genList("petitions", "ErPetitionsFiled.vm", templateData);
    }

    public void writeErPetitionsFiled(OutputStreamWriter out, List petitionList)
            throws IOException {

        out.write(genErPetitionsFiled(petitionList).toString());
        out.flush();
    }

    public StringWriter genSpillBody(Object templateData) {

        return genItem("spill", "Spill_body.vm", templateData);
    }

    public StringWriter genSpillClose(Object templateData) {

        return genItem("spill", "Spill_end.vm", templateData);
    }

    public void writeSpillBody(OutputStreamWriter out, Spill spill)
            throws IOException {

        out.write(genSpillBody(spill).toString());
        out.flush();
    }

    public void writeSpillClose(OutputStreamWriter out, Spill spill)
            throws IOException {

        out.write(genSpillClose(spill).toString());
        out.flush();
    }

    public StringWriter genSpTankTests(List templateData) {

        return genList("tankTests", "SpTankTest.vm", templateData);
    }

    public void writeSpTankTests(OutputStreamWriter out, List tankTestList)
            throws IOException {

        out.write(genSpTankTests(tankTestList).toString());
        out.flush();
    }

    public StringWriter genMaterialCodes(List templateData) {

        return genList("materials", "MaterialCode.vm", templateData);
    }

    public void writeMaterialCodes(OutputStreamWriter out,
            List materialCodesList) throws IOException {

        out.write(genMaterialCodes(materialCodesList).toString());
        out.flush();
    }

    public StringWriter genMaterialFamilyCodes(List templateData) {

        return genList("materialFamilies", "MaterialFamilyCode.vm",
                templateData);
    }

    public void writeMaterialFamilyCodes(OutputStreamWriter out,
            List materialFamilyCodesList) throws IOException {

        out.write(genMaterialFamilyCodes(materialFamilyCodesList).toString());
        out.flush();
    }

    public StringWriter genMediaAffectedCodes(List templateData) {

        return genList("mediaCodes", "MediaAffectedCode.vm", templateData);
    }

    public void writeMediaAffectedCodes(OutputStreamWriter out,
            List mediaAffectedCodesList) throws IOException {

        out.write(genMediaAffectedCodes(mediaAffectedCodesList).toString());
        out.flush();
    }
}