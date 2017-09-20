package com.windsor.node.plugin.common;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.Iterator;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.windsor.node.plugin.common.staging.XmlStaging;

public class XmlFileToClobProcessor {
    protected Logger logger = LoggerFactory.getLogger(getClass());
    private XmlStaging xmlStaging;
    private static final String XML_PREAMBLE = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>";

    public XmlFileToClobProcessor(XmlStaging xmlStaging) {
        this.xmlStaging = xmlStaging;
    }

    public void processXmlFile(String filename) {
        String listName = null;
        try {
            FileReader fr = new FileReader(filename);
            BufferedReader br = new BufferedReader(fr);
            StringBuffer xmlBuf = null;
            Iterator listNameIter = this.xmlStaging.getListNames().iterator();
            while (listNameIter.hasNext()) {
                xmlBuf = newBufferIfNull(xmlBuf);
                listName = (String) listNameIter.next();
                if (this.xmlStaging.getListElementMap().get(listName) == null) {
                    copyList(br, listName);
                } else {
                    copyListWithSizeLimit(br, listName);
                }
            }
        } catch (FileNotFoundException fnfe) {
            String msg = "File " + filename + " not found";
            this.logger.error(msg);
            throw new RuntimeException(msg, fnfe);
        } catch (IOException ioe) {
            String msg = "Problem reading file " + filename;
            this.logger.error(msg);
            throw new RuntimeException(msg, ioe);
        }
    }

    private StringBuffer newBufferIfNull(StringBuffer xmlBuf) {
        if (xmlBuf == null) {
            xmlBuf = new StringBuffer();
            this.logger.debug("initialized xmlBuf");
        }
        return xmlBuf;
    }

    private void bufferLine(StringBuffer xmlBuf, String line) {
        this.logger.trace("buffering line: " + line);
        xmlBuf.append(line.trim());
    }

    private void copyList(BufferedReader br, String listName) throws IOException {
        String line = null;
        String listStart = this.xmlStaging.getStartTag(listName);
        String listEnd = this.xmlStaging.getEndTag(listName);
        this.logger.debug("Copying list " + listName + " verbatim");
        StringBuffer xmlBuf = null;
        boolean continueList = false;
        while ((line = br.readLine()) != null) {
            xmlBuf = newBufferIfNull(xmlBuf);
            if (StringUtils.contains(line, listStart)) {
                this.logger.debug("found list starting tag " + listStart + " in file");
                continueList = true;
            }
            if (continueList) {
                bufferLine(xmlBuf, line);
            }
            if (StringUtils.contains(line, listEnd)) {
                this.logger.debug("found list ending tag " + listEnd + " in file");
                continueList = false;
                this.xmlStaging.execute(xmlBuf, false);
                xmlBuf = null;
            }
        }
    }

    private void copyListWithSizeLimit(BufferedReader br, String listName) throws IOException {
        String line = null;
        String listStart = this.xmlStaging.getStartTag(listName);
        String listEnd = this.xmlStaging.getEndTag(listName);
        this.logger.debug("Copying list " + listName + " with batchSize = " + this.xmlStaging.getBatchSize());
        StringBuffer xmlBuf = null;
        List elementsToCount = (List) this.xmlStaging.getListElementMap().get(listName);
        Iterator elementIter = elementsToCount.iterator();
        while (elementIter.hasNext()) {
            String elementName = (String) elementIter.next();
            String elementEnd = this.xmlStaging.getEndTag(elementName);
            int listItemCount = 0;
            boolean continueList = false;
            while ((line = br.readLine()) != null) {
                if ((StringUtils.contains(line, "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"))
                        || (StringUtils.contains(line, this.xmlStaging.getDocumentOpen()))) {
                    line = br.readLine();
                }
                if (xmlBuf == null) {
                    xmlBuf = newBufferIfNull(xmlBuf);
                    if (!continueList) {
                        this.logger.debug("(re)starting list " + listName);
                        bufferLine(xmlBuf, listStart);
                        continueList = true;
                    }
                }
                if (StringUtils.contains(line, listStart)) {
                    this.logger.debug("found list starting tag " + listStart + " in file");
                    continueList = true;
                } else {
                    if (StringUtils.contains(line, listEnd)) {
                        this.logger.debug("found list ending tag " + listEnd + " in file");
                        continueList = false;
                        listItemCount = 0;
                        bufferLine(xmlBuf, line);
                        this.xmlStaging.execute(xmlBuf, true);
                        xmlBuf = null;
                        break;
                    }
                    if (StringUtils.contains(line, elementEnd)) {
                        listItemCount++;
                        boolean isFinal = false;
                        if ((this.xmlStaging.getBatchSize() > 0) && (listItemCount == this.xmlStaging.getBatchSize())) {
                            this.logger.debug("reached batchSize of " + this.xmlStaging.getBatchSize());
                            continueList = false;
                            listItemCount = 0;
                            bufferLine(xmlBuf, line);
                            bufferLine(xmlBuf, listEnd);
                            isFinal = true;
                        } else {
                            bufferLine(xmlBuf, line);
                            continueList = true;
                        }
                        this.xmlStaging.execute(xmlBuf, isFinal);
                        xmlBuf = null;
                    } else {
                        bufferLine(xmlBuf, line);
                    }
                }
            }
        }
    }
}
