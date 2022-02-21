package com.windsor.node.plugin.rcra.outbound.converter;

import com.windsor.node.plugin.rcra.outbound.domain.QuantityUOMDescriptionDataType;

import javax.persistence.AttributeConverter;
import javax.persistence.Converter;

@Converter(autoApply = true)
public class QuantityUOMDescriptionDataTypeConverter implements AttributeConverter<QuantityUOMDescriptionDataType, String> {

    @Override
    public String convertToDatabaseColumn(QuantityUOMDescriptionDataType quantityUOMDescriptionDataType) {
        String s = null;
        if (quantityUOMDescriptionDataType != null) {
            s = quantityUOMDescriptionDataType.value();
        }
        return s;
    }

    @Override
    public QuantityUOMDescriptionDataType convertToEntityAttribute(String s) {
        return s == null ? null : QuantityUOMDescriptionDataType.fromValue(s);
    }
}
