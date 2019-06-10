package com.windsor.node.plugin.rcra57.converter;

import com.windsor.node.plugin.rcra57.domain.AlternateDesignatedFacilityTypeDataType;

import javax.persistence.AttributeConverter;
import javax.persistence.Converter;

@Converter(autoApply = true)
public class AlternateDesignatedFacilityTypeDataTypeConverter implements AttributeConverter<AlternateDesignatedFacilityTypeDataType, String> {

    @Override
    public String convertToDatabaseColumn(AlternateDesignatedFacilityTypeDataType alternateDesignatedFacilityTypeDataType) {
        String s = null;
        if (alternateDesignatedFacilityTypeDataType != null) {
            s = alternateDesignatedFacilityTypeDataType.value();
        }
        return s;
    }

    @Override
    public AlternateDesignatedFacilityTypeDataType convertToEntityAttribute(String s) {
        return AlternateDesignatedFacilityTypeDataType.fromValue(s);
    }
}
