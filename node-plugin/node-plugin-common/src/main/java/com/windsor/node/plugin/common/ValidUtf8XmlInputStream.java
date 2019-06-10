package com.windsor.node.plugin.common;

import java.io.FilterInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;

/**
 * Removes illegal XML characters from the wrapped InputStream.
 *
 * This class is not trying to handle invalid UTF-8 characters, only valid UTF-8 characters that are not valid _XML_
 * characters.
 *
 * @see https://stackoverflow.com/questions/4237625/removing-invalid-xml-characters-from-a-string-in-java
 */
public class ValidUtf8XmlInputStream extends FilterInputStream {

    /**
     * The character to substitute for the illegal character. May be null.
     */
    private Character replacement;

    public ValidUtf8XmlInputStream(InputStream in, Character replacement) {
        super(in);
        this.replacement = replacement;
    }

    @Override
    public int read(byte[] cbuf, int off, int len) throws IOException {
        int j = 0;
        int bytesRead = 0;
        byte[] b = new byte[cbuf.length];
        StringBuilder sb = new StringBuilder();
        do {
            bytesRead = in.read(b, 0, len - j);
            if (bytesRead < 0) {
                break;
            }
            String text = new String(Arrays.copyOfRange(b, 0, len-j));
            for (int i = 0; i < text.length(); i++) {
                int codePoint = text.codePointAt(i);
                if (codePoint > 0xFFFF) {
                    i++;
                }
                if (codePoint == 0x9 || codePoint == 0xA || codePoint == 0xD
                        || codePoint >= 0x20 && codePoint <= 0xD7FF
                        || codePoint >= 0xE000 && codePoint <= 0xFFFD
                        || codePoint >= 0x10000 && codePoint <= 0x10FFFF
                ) {
                    sb.appendCodePoint(codePoint);
                    j++;
                } else {
                    if (replacement != null) {
                        sb.append(replacement);
                        j++;
                    }
                }
            }
        } while (bytesRead > 0 && j < len);
        if (j > 0) {
            System.arraycopy(sb.toString().getBytes(), 0, cbuf, off, j);
        }
        return j == 0 ? -1 : j;
    }

}
