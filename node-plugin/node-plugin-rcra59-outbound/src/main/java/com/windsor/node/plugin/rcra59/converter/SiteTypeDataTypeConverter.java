package com.windsor.node.plugin.rcra59.converter;

import com.windsor.node.plugin.rcra59.domain.SiteTypeDataType;

import javax.persistence.AttributeConverter;
import javax.persistence.Converter;

@Converter(autoApply = true)
public class SiteTypeDataTypeConverter implements AttributeConverter<SiteTypeDataType, String> {

    @Override
    public String convertToDatabaseColumn(SiteTypeDataType siteTypeDataType) {
        String s = null;
        if (siteTypeDataType != null) {
            s = siteTypeDataType.value();
        }
        return s;
    }

    @Override
    public SiteTypeDataType convertToEntityAttribute(String s) {
        return SiteTypeDataType.fromValue(s);
    }
}
