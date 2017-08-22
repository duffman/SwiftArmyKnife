import Foundation

var jsonString = "{\"glossary\":{\"title\":\"example glossary\",\"GlossDiv\":{\"atitle\":12,\"GlossList\":{\"GlossEntry\":{\"ID\":\"SGML\",\"SortAs\":\"SGML\",\"GlossTerm\":\"Standard Generalized Markup Language\",\"Acronym\":\"SGML\",\"Abbrev\":\"ISO 8879:1986\",\"GlossDef\":{\"para\":\"A meta-markup language, used to create markup languages such as DocBook.\",\"GlossSeeAlso\":[\"GML\",\"XML\"]},\"GlossSee\":\"markup\"}}}}}"
var simpleJsonString = "{\"firstName\":\"Patrik\",\"lastName\":\"Forsberg\",\"age\":35,\"tags\":[\"King\",\"Programmer\",\"Bulle\"]}"

public class IgniterJSONDeserializer {
	class var instance: IgniterJSONDeserializer {
		struct Singleton {
			static let instance = IgniterJSONDeserializer()
		}
		return Singleton.instance
	}
	
	var jsonParser = JSONParser()
	
	typealias JSONProperty = (String, Any)
	typealias JSONArray = Array<Any>
	
	public init() {
	}
	
	// TODO: Look into the "reviver" browser functionality
	// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/JSON/parse
	//
	public func parse(_ text: String) {
		jsonParser.parseJsonString(text, completion: { (data, error) in
				print("Parse")
				if let error = error {
					print(error.message)
				}
				else if let data = data {
					print("Data")
					parseJSONObject(data)
			
				} else {
					// Should never occur, but both data and error is nil
				}
			})
	}

	func parseArray(_ data: Array<Any>) {
		for value in data {
			print("**** Parse Array: ")
		}
	}
	
	// TODO: Figure out what types to use!!! the types:
	// JSONPropertyCollection AND JSONDataArray ARE THE SAME TYPE
	public func parseJSONObject(_ propertyCollection: JSONPropertyCollection) {

		for (name, value) in propertyCollection {
			let propertyType = getPropertyType(value)
		
			// DEBUG
			debugPrintProperty(name, value, propertyType)
	
			switch propertyType {
			case JSONPropertyType.Array:
				//parseJSONArray(value as! Array<Any>)
				
				break
			case JSONPropertyType.PropertyCollection:
				parseJSONObject(value as! JSONPropertyCollection)
				break
			default: break
			}
			
		}
	}

	func debugPrintProperty(_ name: String, _ value: Any, _ propertyType: JSONPropertyType) {
		print(name + " - " + propertyTypeToString(propertyType) )

		if name == "GlossSeeAlso" {
			let mirror = Mirror(reflecting: value)
			var objectType = mirror.subjectType
			let typeOfArray = type(of: value)
		}
	}
	
	// MARK: - Helper Methods
	
} // end class
