package com.windsor.node.plugin.rcra.outbound.converter;

import com.windsor.node.plugin.rcra.outbound.domain.AlternateDesignatedFacilityTypeDataType;

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
