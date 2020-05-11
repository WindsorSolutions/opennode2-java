package com.windsor.node.plugin.rcra58.converter;

import com.windsor.node.plugin.rcra58.domain.StatusDataType;

import javax.persistence.AttributeConverter;
import javax.persistence.Converter;

@Converter(autoApply = true)
public class StatusDataTypeConverter implements AttributeConverter<StatusDataType, String> {

    @Override
    public String convertToDatabaseColumn(StatusDataType statusDataType) {
        String s = null;
        if (statusDataType != null) {
            s = statusDataType.value();
        }
        return s;
    }

    @Override
    public StatusDataType convertToEntityAttribute(String s) {
        return StatusDataType.fromValue(s);
    }
}
