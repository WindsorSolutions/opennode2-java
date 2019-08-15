package com.windsor.node.plugin.common;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.CharArrayWriter;
import java.io.FilterReader;
import java.io.IOException;
import java.io.Reader;
import java.util.Arrays;

/**
 * Removes illegal XML characters from the wrapped InputStream.
 * <p>
 * This class is not trying to handle invalid UTF-8 characters, only valid UTF-8 characters that are not valid _XML_
 * characters.
 *
 * @see https://stackoverflow.com/questions/4237625/removing-invalid-xml-characters-from-a-string-in-java
 */
public class ValidXmlReader extends FilterReader {

    private static final Logger LOGGER = LoggerFactory.getLogger(ValidXmlReader.class);

    /**
     * The character to substitute for the illegal character. May be null.
     */
    private Character replacement;

    public ValidXmlReader(Reader reader, Character replacement) {
        super(reader);
        this.replacement = replacement;
    }

    @Override
    public int read(char[] cbuf, int off, int len) throws IOException {
        char[] charBuffer = new char[len];
        int charsInBuffer = 0;
        int charsRead;
        LOGGER.debug("off=" + off + ", len=" + len);
        try (CharArrayWriter writer = new CharArrayWriter(len)) {
            while (writer.size() < len && (charsRead = in.read(charBuffer, 0, len - charsInBuffer)) > 0) {
                LOGGER.debug("charsRead=" + charsRead);
                String s = String.valueOf(Arrays.copyOfRange(charBuffer, 0, charsRead));
                for (int i = 0; i < s.length(); i++) {
                    int codePoint = s.codePointAt(i);
                    if (codePoint > 0xFFFF) {
                        LOGGER.debug("Codepoint > 0xFFFF - " + codePoint);
                        i++;
                    }
                    if (codePoint == 0x9 || codePoint == 0xA || codePoint == 0xD
                            || codePoint >= 0x20 && codePoint <= 0xD7FF
                            || codePoint >= 0xE000 && codePoint <= 0xFFFD
                            || codePoint >= 0x10000 && codePoint <= 0x10FFFF
                    ) {
                        writer.write(codePoint);
                    } else {
                        if (replacement != null) {
                            LOGGER.warn("Replacing illegal XML code point " + codePoint + " with char '" + replacement + "'");
                            writer.write(replacement);
                        } else {
                            LOGGER.warn("No replacement specified");
                        }
                    }
                }
                LOGGER.debug("charsRead=" + charsRead + ", writer.size()=" + writer.size());
            }
            char[] result = writer.toCharArray();
            LOGGER.debug("result.length=" + result.length);
            if (writer.size() > 0) {
                System.arraycopy(result, 0, cbuf, off, result.length);
            }
            return result.length <= 0 ? -1 : result.length;
        }
    }

}
