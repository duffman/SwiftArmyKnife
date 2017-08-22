import UIKit

// return String(data: data, encoding: .utf8)

var xmlSerializer = XMLSerializer()
var testNode = createXmlDebugNode()
var xmlString = xmlSerializer.serialize(rootNode: testNode)

/*
let data = try JSONSerialization.data(withJSONObject: OBJECT, options: [JSONSerialization.WritingOptions.prettyPrinted])
let jsonString = String(data: data, encoding: .utf8)
*/

/*
print(
xmlNode.toString()
)
*/

//---------------------------------------------------------------------------
//
//		Process Object
//
//---------------------------------------------------------------------------
func echo(_ tag: String, _ data: Any? = nil) {
	if (data != nil) {
		print(tag, data)
	} else {
		print(tag)
	}
}

func getClassName(_ instance: Any) -> String {
	let objectClass = unwrap(instance)
	let className = String(describing: type(of: objectClass))
	return className
}

func log(_ prefix: String, _ data: Any) {
	print("processOject> " + prefix + ": ", data)
}

// TODO: Move to a bool property in the property class
func valueTypeIsProperty(_ valueType: ValueType) -> Bool {
	let types: Array<ValueType> = [ValueType.Object, ValueType.Unknown]
	return !types.contains(valueType)
}

func mirrorIsObject(mirror: Mirror) -> Bool {
	var result: Bool = false
	let styles: Array<Mirror.DisplayStyle> = [Mirror.DisplayStyle.class, Mirror.DisplayStyle.struct]
	
	if mirror.displayStyle != nil {
		result = styles.contains(mirror.displayStyle!)
	}
	
	return result
}

func parseChildObject(_ node: inout ZynNode, _ objectMirror: Mirror, level: Int) throws {
	
	for case let (childLabel?, valueMaybe) in objectMirror.children {
		let prefix = String(repeating: "\t", count: level)
		let childMirror = Mirror(reflecting: valueMaybe)
		
		// Get the property type
		let propValue = PropertyValue(withObject: valueMaybe)
		let valueType = propValue.propertyType
		let valueTypeStr = propValue.toString()
		
		if valueTypeIsProperty(valueType) {
			node.putProperty(name: childLabel, value: "")
			print("### (SUB) ## -> " + prefix + childLabel + ":" , valueTypeStr)
		}
		
		if mirrorIsObject(mirror: childMirror) {
			//print(childMirror)
			let newLevel = level.advanced(by: 1)
			//print("RE-LOOPING")
			let className = getClassName(instance: valueMaybe)
			print("### (SUB) ## -> " + prefix + className)
			
			try parseChildObject(&node, childMirror, level: newLevel)
		}
	}
}


func processRootOject(_ object: Any, _ node: inout ZynNode, level: Int) throws -> ZynNode {
	var className = getClassName(instance: object)
	
	print("First loop (ClassName): " + className)
	
	if level == 0 {
		node.name = className
	}
	
	let mirror: Mirror = Mirror.init(reflecting: object)
	
	for case let (label?, valueMaybe) in mirror.children {
		let valueMirror: Mirror = Mirror.init(reflecting: valueMaybe)
		className = getClassName(valueMaybe)
		
		let propValue = PropertyValue(withObject: valueMaybe)
		let valueType = propValue.propertyType
		let valueTypeStr = propValue.toString()
		
		if valueTypeIsProperty(valueType) {
			print("### (MAIN) ## -> " + label + " : " + anyValueToString(valueMaybe))
		}
		else if valueType == ValueType.Object {
			let newLevel = level.advanced(by: 1)
			try parseChildObject(&node, valueMirror, level: newLevel)
		}
	}
	
	return node
}

func serialize(object: Any, options: JSONSerializerOptions = []) throws -> ZynNode {
	let className = getClassName(object)
	var node: ZynNode = ZynNode()
	
	print("Serializing object \"" + className + "\"")
	
	try processRootOject(object, &node, level: 0)
	
	return node
}

do {
	var profile = UserProfile()
	var message = IgniterMessage()
	
	var options: JSONSerializerOptions = [.convertToCamelCase]
	var node = try serialize(object: message, options: options)
	
	print("----------------------------------------------------")
	print(node.toString())
	
	
	echo(CharConst.CRLF)
}
catch {
	
}
