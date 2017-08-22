//===----------------------------------------------------------------------===//
//
//	This source file is part of the IgniterJSON Library
//
//	JSON Serializer
//	Author: Patrik Forsberg <patrik.forsberg@coldmind.com>
//	Date: 2017-01-03
//
//	Copyright (c) 2014 - 2016 Coldmind Ltd.
//	Licensed under Apache License v2.0 with Runtime Library Exception
//
//	See http://www.coldmind.com for more information and usage docs
//
//===----------------------------------------------------------------------===//

import Foundation

protocol JSONDecodable {
	func toJSON() throws -> String
}

public enum JSONPropertyType {
	case Unknown
	case String
	case Number
	case Boolean
	case PropertyCollection
	case Array
}

public typealias JSONData = [String: Any]
public typealias JSONPropertyCollection = Dictionary<String, Any>

public class ParserError {
	public var message: String = ""
	
	public init(errorMessage: String?) {
		self.message = errorMessage!
	}
}

public struct JSONSerializerOptions: OptionSet {
	public let rawValue: Int
	
	public static var convertToCamelCase			= JSONSerializerOptions(rawValue: 1 << 0)
	public static var excludeNullValueProperties	= JSONSerializerOptions(rawValue: 1 << 1)
	
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
}
