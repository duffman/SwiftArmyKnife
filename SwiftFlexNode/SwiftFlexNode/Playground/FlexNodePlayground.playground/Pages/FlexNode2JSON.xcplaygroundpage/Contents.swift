
public struct XMLFormattingOptions: OptionSet {
	public let rawValue: Int
	
	public static var prettyPrint		= XMLFormattingOptions(rawValue: 1 << 0)
	
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
}



func endTag(_ name: String) -> String {
	var tag = String()
	tag.append("</")
	tag.append(name)
	tag.append(">")
	return tag
}

func singleTag(_ name: String) -> String {
	var tag = String()
	tag.append("<")
	tag.append(name)
	tag.append(" />")
	return tag
}

func isEmptyNode(_ node: ZynNode) -> Bool {
	return !node.haveChildren() && !node.hasData()
}

let compileString: (String...) -> (String) = { parts in
	var result = String()
	for part in parts { result.append(part) }
	return result
}


enum State {
	case InName
	case InValue
	case InObject
}


func processNode(_ node: ZynNode, _ level: Int, _ output: inout String,
                 _ options: XMLFormattingOptions = []) {
	let prettyPrint = options.contains(.prettyPrint)
	let indent = prettyPrint ? String(repeating: CharConst.tab, count: level) : String()
	
	
	// TMP WAY OF SOLVING THIS bläää
	let extraIndent = indent + CharConst.tab
	
	var prevNode: ZynNode? = nil
	
	var tmp = String()
	
	tmp.append(node.name.quote())
	tmp.append(": ")
	
	// Fix documentation
	// If we have properties, the node value shall
	// be added after the properties "#node value"
	//node.properties.inser
	//node.properties.  += ("kalle", "kalle")
	if node.haveProperties() || node.haveChildren() {
		tmp.append("{")
		tmp.append(CharConst.LF)
	}
	
	for property in node.properties {
		let stringValue = anyValueToString(property.value)
		let propName = extraIndent + "@" + property.key
		tmp.append(propName)
		tmp.append(": " + stringValue.quote())
		tmp.append(CharConst.LF)
	}
	
	if !node.haveProperties() && !node.haveChildren() && node.hasData() {
		let stringValue = anyValueToString(node.data)
		tmp.append(node.name.quote() + ": " + stringValue.quote())
		
	}
	
	// WE HAVE OPENED FOR PROPS AND HAVE VALUE, ADD IT AS #TEXT
	if node.haveProperties() && node.hasData() {
		let stringValue = anyValueToString(node.data)
		tmp.append(extraIndent)
		tmp.append("#text: " + stringValue.quote())
		
		if !node.haveChildren() {
			tmp.append(CharConst.LF)
			tmp.append(indent)
			tmp.append("}")
		}
	}
	
	
	
	/// #END_REFACTOR#
	output.append(indent)
	output.append(tmp)
	
	if prettyPrint {
		output.append(CharConst.LF)
	}
	
	for child in node.childNodes {
		let newLevel = level.advanced(by: 1)
		processNode(child, newLevel, &output, options)
		prevNode = child
	}
	
	if (prevNode != nil) {
		output.append(indent)
		output.append("}")
		output.append(CharConst.LF)
	}
	/*
	
	/// Close parent tag
	if (prevNode != nil && prevNode!.parent != nil) {
	output.append(indent)
	output.append("}")
	
	//output.append(endTag(prevNode!.parent!.name))
	if prettyPrint {
	output.append(CharConst.LF)
	}
	}
	*/
}

////
func serialize(rootNode: ZynNode, options: XMLFormattingOptions = []) -> String {
	var output: String = String("{\n")
	processNode(rootNode, 1, &output, [.prettyPrint])
	output.append("}")
	return output
}


var debugNode = createXmlDebugNode()


print("------------------------")
var xml = XMLSerializer()
//var xmlString = xml.serialize(rootNode: debugNode, options: .prettyPrint)
//print(xmlString)

var json = serialize(rootNode: debugNode)
var dPrint = false

if dPrint {
	debugPrint(json)
} else {
	print(json)
}






//print(debugNode.toFormattedString())
//print("-----------------------------------------------")


/*
print("------------------------")
var xml = XMLSerializer()
var xmlString = xml.serialize(rootNode: debugNode, options: .prettyPrint)
print(xmlString)
*/
