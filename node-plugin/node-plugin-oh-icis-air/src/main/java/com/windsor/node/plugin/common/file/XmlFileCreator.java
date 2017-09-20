package com.windsor.node.plugin.common.file;

import com.windsor.node.plugin.common.file.AbstractFileCreator;

public class XmlFileCreator extends AbstractFileCreator {
   private static final String EXT_XML = "xml";
   private final String directoryAbsolutePath;
   private final String fileName;

   public XmlFileCreator(String directoryAbsolutePath, String filename) {
      this.directoryAbsolutePath = directoryAbsolutePath;
      this.fileName = filename;
   }

   protected final String getExtension() {
      return "xml";
   }

   protected String getDirectoryAbsolutePath() {
      return this.directoryAbsolutePath;
   }

   protected String getFileName() {
      return this.fileName;
   }
}
