package com.windsor.node.plugin.rcra58.converter;

import com.windsor.node.plugin.rcra58.domain.RejectionTypeDataType;

import javax.persistence.AttributeConverter;
import javax.persistence.Converter;

@Converter(autoApply = true)
public class RejectionTypeDataTypeConverter implements AttributeConverter<RejectionTypeDataType, String> {

    @Override
    public String convertToDatabaseColumn(RejectionTypeDataType rejectionTypeDataType) {
        String s = null;
        if (rejectionTypeDataType != null) {
            s = rejectionTypeDataType.value();
        }
        return s;
    }

    @Override
    public RejectionTypeDataType convertToEntityAttribute(String s) {
        return RejectionTypeDataType.fromValue(s);
    }
}
