package com.windsor.node.plugin.common.xml.document;

import com.windsor.node.plugin.common.file.FileCreator;
import com.windsor.node.plugin.common.xml.document.DocumentGenerator;
import com.windsor.node.plugin.common.xml.document.ElementWriteHandler;
import com.windsor.node.plugin.common.xml.document.ElementsDataProvider;
import com.windsor.node.plugin.common.xml.stream.ElementWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Iterator;

public class StreamXmlFileGenerator<T> implements DocumentGenerator {
   private final FileCreator fileCreator;
   private final ElementsDataProvider<T> dataProvider;
   private final ElementWriter writer;
   private final ElementWriteHandler<T> writeHandler;

   public StreamXmlFileGenerator(FileCreator fileCreator, ElementsDataProvider<T> dataProvider, ElementWriteHandler<T> writeHandler, ElementWriter writer) {
      this.fileCreator = fileCreator;
      this.dataProvider = dataProvider;
      this.writeHandler = writeHandler;
      this.writer = writer;
   }

   public File generate() throws IOException {
      File file = this.fileCreator.createFile();
      FileOutputStream fos = null;

      try {
         fos = new FileOutputStream(file);
         this.writer.open(fos);
         Iterable e = this.dataProvider.elements();
         Iterator i$ = e.iterator();

         while(i$.hasNext()) {
            Object t = i$.next();
            this.writeHandler.handle(this.writer, (T) t);
         }
      } catch (Exception var13) {
         throw new IOException(var13.getLocalizedMessage(), var13);
      } finally {
         if(this.writer != null) {
            this.writer.close();
         }

         if(fos != null) {
            try {
               fos.close();
            } catch (IOException var12) {
               throw var12;
            }
         }

      }

      return file;
   }
}
