enum SerializationError: Error {
	case StructRequired
	case UnknownEntity(name: String)
	// The provided type cannot be serialized
	case UnsupportedSubType(label: String?)
}

public struct CharConst {
	public static let beginObject = "{"
	public static let endObject = "}"
	public static let quotationMark = "\""
	public static let beginArray = "["
	public static let endArray = "]"
	public static let CR = "\r"
	public static let LF = "\n"
	public static let CRLF = CR + LF
	public static let newLine = LF
	public static let comma = ","
	public static let colon = ":"
	public static let semiColon = ";"
	public static let tab = "\t"
}

public enum ValueType {
	case Unknown
	case String
	case Int
	case Double
	case Bool
	case Array
	case Object
}

public let objectMirrorStyles: Array<Mirror.DisplayStyle> = [
	Mirror.DisplayStyle.class, Mirror.DisplayStyle.struct
]
public let validStringValueTypes: Array<ValueType> = [
	ValueType.String, ValueType.Int, ValueType.Double
]


//??????????????????????? eeeeeh
public struct ReflectedType: OptionSet {
	public let rawValue: Int
	
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
}
