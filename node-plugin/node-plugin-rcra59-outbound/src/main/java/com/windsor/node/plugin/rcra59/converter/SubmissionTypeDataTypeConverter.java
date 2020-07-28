package com.windsor.node.plugin.rcra59.converter;

import com.windsor.node.plugin.rcra59.domain.SubmissionTypeDataType;

import javax.persistence.AttributeConverter;
import javax.persistence.Converter;

@Converter(autoApply = true)
public class SubmissionTypeDataTypeConverter implements AttributeConverter<SubmissionTypeDataType, String> {

    @Override
    public String convertToDatabaseColumn(SubmissionTypeDataType submissionTypeDataType) {
        String s = null;
        if (submissionTypeDataType != null) {
            s = submissionTypeDataType.value();
        }
        return s;
    }

    @Override
    public SubmissionTypeDataType convertToEntityAttribute(String s) {
        return SubmissionTypeDataType.fromValue(s);
    }
}
