package com.windsor.node.plugin.common.file;

import com.windsor.node.plugin.common.file.FileCreator;
import java.io.File;
import java.io.IOException;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

abstract class AbstractFileCreator implements FileCreator {
   private static final String DEFAULT_EXTENSION = "";
   private static final Logger LOG = LoggerFactory.getLogger(AbstractFileCreator.class);

   protected abstract String getFileName();

   protected abstract String getDirectoryAbsolutePath();

   protected abstract String getExtension();

   public File createFile() throws IOException {
      return this.getFile();
   }

   private File getFile() throws IOException {
      FileUtils.forceMkdir(new File(this.directoryAbsolutePath()));
      return new File(this.documentAbsolutePath());
   }

   private String documentAbsolutePath() {
      return this.directoryAbsolutePath() + File.separator + this.fileName() + this.extension();
   }

   private String fileName() {
      String f = this.getFileName();
      return StringUtils.isNotEmpty(f)?f:"";
   }

   private String directoryAbsolutePath() {
      String d = this.getDirectoryAbsolutePath();
      return StringUtils.isNotEmpty(d)?d:"";
   }

   private String extension() {
      String ext = this.getExtension();
      return StringUtils.isNotEmpty(ext)?"." + ext:"";
   }

   private void error(Throwable t) {
      LOG.error("", t);
   }
}
