package com.windsor.node.plugin.rcra58;

import com.windsor.node.plugin.common.ValidXmlReader;
import com.windsor.node.plugin.rcra58.domain.EmanifestDataType;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBElement;
import javax.xml.bind.Unmarshaller;
import javax.xml.bind.ValidationEvent;
import javax.xml.bind.ValidationEventHandler;
import javax.xml.stream.XMLEventReader;
import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.events.XMLEvent;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;

public class ParserTest {

    public static void main(String[] args) throws Exception {
        System.out.println("hi");
        InputStream inputStream = new FileInputStream(new File("d:/temp/ffb7efcf-2b36-4fea-b64c-d112bcfff67d8628320926147647309.xml"));
        //Reader reader = new FileReader(new File("d:/temp/ffb7efcf-2b36-4fea-b64c-d112bcfff67d8628320926147647309.xml"));
        Reader reader = new ValidXmlReader(new InputStreamReader(inputStream, StandardCharsets.UTF_8), ' ');
        //processData(result, new ValidXmlReader(new InputStreamReader(inputStream, StandardCharsets.UTF_8), ' '), type);
        XMLInputFactory xif = XMLInputFactory.newFactory();
        XMLEventReader xer = xif.createXMLEventReader(reader);
        JAXBContext jc = JAXBContext.newInstance("com.windsor.node.plugin.rcra58.domain",
                EmanifestDataType.class.getClassLoader());
        Unmarshaller unmarshaller = jc.createUnmarshaller();
        unmarshaller.setEventHandler(new ValidationEventHandler() {

            @Override
            public boolean handleEvent(ValidationEvent event) {

                StringBuilder builderError = new StringBuilder();
                builderError.append("Could not parse the received XML data!\n");
                builderError.append("  SEVERITY:  " + event.getSeverity() + "\n");
                builderError.append("  MESSAGE:  " + event.getMessage() + "\n");
                builderError.append("  LINKED EXCEPTION:  " +
                        event.getLinkedException() + "\n");
                builderError.append("  LOCATOR" + "\n");
                builderError.append("      LINE NUMBER:  " +
                        event.getLocator().getLineNumber() + "\n");
                builderError.append("      COLUMN NUMBER:  " +
                        event.getLocator().getColumnNumber() + "\n");
                builderError.append("      OFFSET:  " +
                        event.getLocator().getOffset() + "\n");
                builderError.append("      OBJECT:  " +
                        event.getLocator().getObject() + "\n");
                builderError.append("      NODE:  " +
                        event.getLocator().getNode() + "\n");
                builderError.append("      URL:  " +
                        event.getLocator().getURL());
                return true;
            }
        });
        for (int i = 0; xer.hasNext(); i++) {
            XMLEvent peek = xer.peek();
            if (peek.isStartElement() && peek.asStartElement().getName().getLocalPart().equals("Emanifest")) {
                JAXBElement<?> element = (JAXBElement<?>) unmarshaller.unmarshal(xer);
                Object value = element.getValue();
                //Object objToPersist = dbInfo.getPrePersistHandler().prePersist(value, parent);
                //em.persist(objToPersist);
                System.out.println("value=" + value);
            } else {
                xer.nextEvent();
                System.out.println("here");
            }
        }
    }

}
