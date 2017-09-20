package com.windsor.node.plugin.common.xml;

import java.io.File;
import java.io.IOException;

import javax.xml.transform.Source;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.InitializingBean;
import org.xml.sax.ErrorHandler;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;


public class XmlValidator implements InitializingBean {
    protected static Logger logger = LoggerFactory.getLogger(XmlValidator.class);
    private String schemaFilename;

    public XmlValidator() {
    }

    public XmlValidator(String schemaFileName) {
        this.schemaFilename = schemaFileName;
    }

    public boolean validate(String filename) {
        validateLenient(filename);
        return validateHarsh(filename);
    }

    public boolean validateHarsh(String filename) {
        logger.debug("Validating xml file " + filename);
        SchemaFactory factory = SchemaFactory.newInstance("http://www.w3.org/2001/XMLSchema");
        boolean isValid = false;
        try {
            File schemaLocation = new File(this.schemaFilename);
            Schema schema = factory.newSchema(schemaLocation);
            Validator validator = schema.newValidator();
            Source source = new StreamSource(filename);
            validator.validate(source);
            isValid = true;
            logger.info(filename + " is valid.");
        } catch (SAXParseException spe) {
            isValid = false;
            logger.info(filename + " is not valid.");
        } catch (SAXException ex) {
            logger.error(errMsg(filename) + ex.getMessage());
            throw new RuntimeException(errMsg(filename) + ex.getMessage(), ex);
        } catch (IOException e) {
            logger.error(e.getMessage());
            throw new RuntimeException(e);
        }
        return isValid;
    }

    public boolean validateLenient(String filename) {
        logger.debug("Gently validating xml file " + filename);
        SchemaFactory factory = SchemaFactory.newInstance("http://www.w3.org/2001/XMLSchema");
        boolean isValid = false;
        try {
            File schemaLocation = new File(this.schemaFilename);
            Schema schema = factory.newSchema(schemaLocation);
            Validator validator = schema.newValidator();
            logger.debug("validator implementation: " + validator.getClass());
            ErrorHandler lenient = new ForgivingErrorHandler();
            validator.setErrorHandler(lenient);
            Source source = new StreamSource(filename);
            validator.validate(source);
            isValid = true;
            logger.info(filename + " may or may not be valid.");
        } catch (SAXException ex) {
            logger.error(errMsg(filename) + ex.getMessage());
            throw new RuntimeException(errMsg(filename) + ex.getMessage(), ex);
        } catch (IOException e) {
            logger.error(e.getMessage());
            throw new RuntimeException(e);
        }
        return isValid;
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

    private class ForgivingErrorHandler implements ErrorHandler {
        private ForgivingErrorHandler() {
        }

        @Override
        public void warning(SAXParseException ex) {
            XmlValidator.logger.warn("Warning: " + XmlValidator.this.saxParseExceptionMsg(ex));
        }

        @Override
        public void error(SAXParseException ex) {
            XmlValidator.logger.error("Error: " + XmlValidator.this.saxParseExceptionMsg(ex));
        }

        @Override
        public void fatalError(SAXParseException ex) throws SAXException {
            XmlValidator.logger.error("Fatal error: " + XmlValidator.this.saxParseExceptionMsg(ex));
            throw ex;
        }
    }

    @Override
    public void afterPropertiesSet() throws Exception {
        if (StringUtils.isBlank(this.schemaFilename)) {
            throw new RuntimeException("schemaFilename is null or empty");
        }
    }
}
