import Foundation

public func propertyTypeToString(_ propertyType: JSONPropertyType) -> String {
	var typeString = ""
	
	switch propertyType {
	case JSONPropertyType.String:
		typeString = "String"
	case JSONPropertyType.Number:
		typeString = "Number"
	case JSONPropertyType.PropertyCollection:
		typeString = "PropertyCollection"
	case JSONPropertyType.Array:
		typeString = "Array"
	default:
		typeString = "Unknown"
	}
	
	return typeString
}

public func getPropertyType(_ value: Any) -> JSONPropertyType {
	var valueType = JSONPropertyType.Unknown
	
	if value is String {
		valueType = JSONPropertyType.String
	}
	if value is Int {
		valueType = JSONPropertyType.Number
	}
	else if value is JSONPropertyCollection {
		valueType = JSONPropertyType.PropertyCollection
	}
	else if value is Array<Any> {
		valueType = JSONPropertyType.Array
	}
	
	return valueType
}
