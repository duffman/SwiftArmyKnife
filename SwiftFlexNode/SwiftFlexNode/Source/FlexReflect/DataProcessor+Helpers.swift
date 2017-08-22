import Foundation

public func echo(_ data: Any, _ second: Any? = nil) {
	if (second != nil) {
		print(data, second)
	} else {
		print(data)
	}
}

/**
get the type of a property

- parameter propertyName: The property key
- parameter mirror:       The mirror of this object

- returns: The type of the property
*/
fileprivate func typeForKey(_ propertyName: String, mirror: Mirror) -> Any.Type? {
	for (label, value) in mirror.children {
		if propertyName == label {
			return Mirror(reflecting: value).subjectType
		}
	}
	
	guard let superclassMirror = mirror.superclassMirror else {
		return nil
	}
	
	return typeForKey(propertyName, mirror: superclassMirror)
}

public func isObjectType(object: Any) -> Bool {
	var result = false
	let valueMirror = Mirror(reflecting: object)
	
	// We map the display style as well as the optional first child,
	switch (valueMirror.displayStyle, valueMirror.children.first) {
	// Support for optional parameters
	case (.optional?, let child?):
		let optionalMirror = Mirror(reflecting: child.value)
		result = optionalMirror.isClassOrStruct()
		break
	default:
		//print("Fail in \"isObjectType\"")
		break
	}
	
	return result
}

public class PropertyValue {
	var value: ValueType = ValueType.Unknown
	
	public var propertyType: ValueType {
		get {
			return self.value
		}
	}
	
	public init(withObject object: Any) {
		self.value = getValueType(object)
	}
	
	public func toString() -> String {
		return valueTypeToString(self.value)
	}
}

public func getValueType(_ value: Any) -> ValueType {
	var valueType = ValueType.Unknown
	
	if value is String {
		valueType = ValueType.String
	}
	else if value is Array<Any> {
		valueType = ValueType.Array
	}
	else if value is Int {
		valueType = ValueType.Int
	}
	else if value is Double {
		valueType = ValueType.Double
	}
	else if value is Bool {
		valueType = ValueType.Bool
	}
	
	// Perform the object check last since it involves
	// reflection which requires heavier operations that
	// we want to avoid performing if the value type
	// already have been determined
	if valueType == ValueType.Unknown
		&& isObjectType(object: value) {
		valueType = ValueType.Object
	}
	
	return valueType
}


public func valueTypeToString(_ value: ValueType) -> String {
	var result = String()
	switch value {
	case ValueType.Array	: result = "Array"
	case ValueType.Int	: result = "Int"
	case ValueType.Double	: result = "Double"
	case ValueType.Bool	: result = "Bool"
	case ValueType.Object	: result = "Object"
	case ValueType.String	: result = "String"
	default: result = "Unknown"
	}
	
	return result
}

/// Converts an Any object to string by first
/// looking at the type to determine if a cast
/// is possible
///
/// - parameter value: Any Object to be converted
///
/// - returns: String value when cast is possible, empty string otherwise.
///
public func anyValueToString(_ value: Any?) -> String {
	var result: String = ""

	let valueType = getValueType(value)
	if validStringValueTypes.contains(valueType) {
		result = String(describing: value!)
	}
	
	return result
}

public func unwrap(_ any:Any) -> Any {
	let mi = Mirror(reflecting: any)
	if mi.displayStyle != .optional {
		return any
	}
	
	if mi.children.count == 0 {
		return NSNull()
	}
	
	let (_, some) = mi.children.first!
	return some
}
