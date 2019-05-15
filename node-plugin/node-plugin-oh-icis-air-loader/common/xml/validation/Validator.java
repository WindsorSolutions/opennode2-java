package com.windsor.node.plugin.common.xml.validation;

import com.windsor.node.plugin.common.xml.validation.ValidationException;
import com.windsor.node.plugin.common.xml.validation.ValidationResult;
import java.io.InputStream;

public interface Validator {
   ValidationResult validate(InputStream var1) throws ValidationException;
}
