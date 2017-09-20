package com.windsor.node.plugin.common.xml.validation.jaxb;

import com.windsor.node.plugin.common.xml.validation.ValidationException;
import com.windsor.node.plugin.common.xml.validation.ValidationResult;
import com.windsor.node.plugin.common.xml.validation.Validator;
import com.windsor.node.plugin.common.xml.validation.jaxb.JaxbValidationResult;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import org.xml.sax.ErrorHandler;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

public class JaxbXmlValidator implements Validator {
   private URL schemaFile;

   public JaxbXmlValidator(URL schemaFile) {
      this.setSchemaUrl(schemaFile);
   }

   public JaxbXmlValidator(String schemaFilePath) {
      try {
         this.setSchemaUrl((new File(schemaFilePath)).toURI().toURL());
      } catch (MalformedURLException var3) {
         throw new ValidationException(var3.getLocalizedMessage(), var3);
      }
   }

   public ValidationResult validate(InputStream xmlInputStream) throws ValidationException {
      final JaxbValidationResult results = new JaxbValidationResult();

      try {
         SchemaFactory e = SchemaFactory.newInstance("http://www.w3.org/2001/XMLSchema");
         Schema schema = e.newSchema(this.schemaFile);
         javax.xml.validation.Validator jaxbValidator = schema.newValidator();
         jaxbValidator.setErrorHandler(new ErrorHandler() {
            public void warning(SAXParseException exception) throws SAXException {
            }

            public void fatalError(SAXParseException exception) throws SAXException {
               results.error(exception.getLocalizedMessage());
            }

            public void error(SAXParseException exception) throws SAXException {
               results.error(exception.getLocalizedMessage());
            }
         });
         StreamSource xmlFile = new StreamSource(xmlInputStream);

         try {
            jaxbValidator.validate(xmlFile);
         } catch (SAXException var8) {
            results.error(var8.getLocalizedMessage());
         } catch (IOException var9) {
            ;
         }

         return results;
      } catch (SAXException var10) {
         throw new ValidationException(var10.getLocalizedMessage(), var10);
      }
   }

   public void setSchemaUrl(URL schemaUrl) {
      this.schemaFile = schemaUrl;
   }
}
