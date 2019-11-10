package dk.efe.example.demo.database.entities;

import javax.persistence.AttributeConverter;
import javax.persistence.Converter;

@Converter(autoApply = true)
public class BooleanConverter implements AttributeConverter<Boolean, String> {

    @Override
    public String convertToDatabaseColumn(Boolean attribute) {
        String stringValue = null;
        if(Boolean.TRUE.equals(attribute)) {
            stringValue = "Y";
        }
        if(Boolean.FALSE.equals(attribute)) {
            stringValue = "N";
        }
        return stringValue;
    }

    @Override
    public Boolean convertToEntityAttribute(String dbData) {
        Boolean bool = null;
        if("Y".equals(dbData)) {
            bool = Boolean.TRUE;
        }
        if("N".equals(dbData)) {
            bool = Boolean.FALSE;
        }
        return bool;
    }

}