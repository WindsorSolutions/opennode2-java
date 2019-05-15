package com.windsor.node.plugin.common.xml;

import java.io.File;
import java.io.IOException;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.InitializingBean;
import org.xml.sax.ErrorHandler;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

/** @deprecated */
@Deprecated
public class XmlValidator implements InitializingBean {
   protected static Logger logger = LoggerFactory.getLogger(XmlValidator.class);
   private String schemaFilename;

   public XmlValidator() {
   }

   public XmlValidator(String schemaFileName) {
      this.schemaFilename = schemaFileName;
   }

   public boolean validate(String filename) {
      this.validateLenient(filename);
      return this.validateHarsh(filename);
   }

   public boolean validateHarsh(String filename) {
      logger.debug("Validating xml file " + filename);
      SchemaFactory factory = SchemaFactory.newInstance("http://www.w3.org/2001/XMLSchema");
      boolean isValid = false;

      try {
         File e = new File(this.schemaFilename);
         Schema schema = factory.newSchema(e);
         Validator validator = schema.newValidator();
         StreamSource source = new StreamSource(filename);
         validator.validate(source);
         isValid = true;
         logger.info(filename + " is valid.");
      } catch (SAXParseException var8) {
         isValid = false;
         logger.info(filename + " is not valid.");
      } catch (SAXException var9) {
         logger.error(this.errMsg(filename) + var9.getMessage());
         throw new RuntimeException(this.errMsg(filename) + var9.getMessage(), var9);
      } catch (IOException var10) {
         logger.error(var10.getMessage());
         throw new RuntimeException(var10);
      }

      return isValid;
   }

   public boolean validateLenient(String filename) {
      logger.debug("Gently validating xml file " + filename);
      SchemaFactory factory = SchemaFactory.newInstance("http://www.w3.org/2001/XMLSchema");
      boolean isValid = false;

      try {
         File e = new File(this.schemaFilename);
         Schema schema = factory.newSchema(e);
         Validator validator = schema.newValidator();
         logger.debug("validator implementation: " + validator.getClass());
         XmlValidator.ForgivingErrorHandler lenient = new XmlValidator.ForgivingErrorHandler();
         validator.setErrorHandler(lenient);
         StreamSource source = new StreamSource(filename);
         validator.validate(source);
         isValid = true;
         logger.info(filename + " may or may not be valid.");
         return isValid;
      } catch (SAXException var9) {
         logger.error(this.errMsg(filename) + var9.getMessage());
         throw new RuntimeException(this.errMsg(filename) + var9.getMessage(), var9);
      } catch (IOException var10) {
         logger.error(var10.getMessage());
         throw new RuntimeException(var10);
      }
   }

   private String errMsg(String filename) {
      return filename + " is not valid, message: ";
   }

   private String saxParseExceptionMsg(SAXParseException ex) {
      return ex.getMessage() + " at line " + ex.getLineNumber() + ", column " + ex.getColumnNumber();
   }

   public String getSchemaFilename() {
      return this.schemaFilename;
   }

   public void setSchemaFilename(String schemaFilename) {
      this.schemaFilename = schemaFilename;
   }

   public void afterPropertiesSet() throws Exception {
      if(StringUtils.isBlank(this.schemaFilename)) {
         throw new RuntimeException("schemaFilename is null or empty");
      }
   }

   // $FF: synthetic class
   static class SyntheticClass_1 {
   }

   private class ForgivingErrorHandler implements ErrorHandler {
      private ForgivingErrorHandler() {
      }

      public void warning(SAXParseException ex) {
         XmlValidator.logger.warn("Warning: " + XmlValidator.this.saxParseExceptionMsg(ex));
      }

      public void error(SAXParseException ex) {
         XmlValidator.logger.error("Error: " + XmlValidator.this.saxParseExceptionMsg(ex));
      }

      public void fatalError(SAXParseException ex) throws SAXException {
         XmlValidator.logger.error("Fatal error: " + XmlValidator.this.saxParseExceptionMsg(ex));
         throw ex;
      }

      // $FF: synthetic method
      ForgivingErrorHandler(XmlValidator.SyntheticClass_1 x1) {
         this();
      }
   }
}
