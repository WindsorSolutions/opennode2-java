package com.windsor.node.plugin.rcra57.converter;

import com.windsor.node.plugin.rcra57.domain.OriginTypeDataType;

import javax.persistence.AttributeConverter;
import javax.persistence.Converter;

@Converter(autoApply = true)
public class OriginTypeDataTypeConverter implements AttributeConverter<OriginTypeDataType, String> {

    @Override
    public String convertToDatabaseColumn(OriginTypeDataType originTypeDataType) {
        String s = null;
        if (originTypeDataType != null) {
            s = originTypeDataType.value();
        }
        return s;
    }

    @Override
    public OriginTypeDataType convertToEntityAttribute(String s) {
        return OriginTypeDataType.fromValue(s);
    }
}
