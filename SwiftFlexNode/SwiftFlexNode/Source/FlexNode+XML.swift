//
//  ZynapticNode+XML.swift
//
//  This file if part of the
//  Zynaptic Node Framework
//
//  Created by Patrik Forsberg on 08/01/17.
//  Copyright © 2017 Coldmind, LTD. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

/* Entity references
&lt;		<	less than
&gt;		>	greater than
&amp;	&	ampersand
&apos;	'	apostrophe
&quot;	"	quotation mark



Name	Character	Unicode code point (decimal)	Standard	Description
quot	"	U+0022 (34)	XML 1.0	double quotation mark
amp	&	U+0026 (38)	XML 1.0	ampersand
apos	'	U+0027 (39)	XML 1.0	apostrophe (apostrophe-quote)
lt	<	U+003C (60)	XML 1.0	less-than sign
gt	>	U+003E (62)	XML 1.0	greater-than sign


*/




/*


	TODO: CData Support
*/

public struct XMLFormattingOptions: OptionSet {
	public let rawValue: Int
	
	public static var prettyPrint		= XMLFormattingOptions(rawValue: 1 << 0)
	
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
}

public class XMLSerializer {
	public init() {
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

	func isEmptyNode(_ node: FlexNode) -> Bool {
		return !node.haveChildren() && !node.hasData()
	}
	
	func compile(properties: FlexNodePropertyList) -> String {
		var result = String()
		
		for property in properties {
			let stringValue = anyValueToString(property.value)
			result.append(" ")
			result.append(property.name)
			result.append("=\"")
			result.append(stringValue)
			result.append("\"")
		}
		return result
	}
	
	func processNode(_ node: FlexNode, _ level: Int, _ output: inout String,
	                 _ options: XMLFormattingOptions = []) {
		let prettyPrint = options.contains(.prettyPrint)
		let indent = prettyPrint ? String(repeating: "\t", count: level) : String()
		
		var prevNode: FlexNode? = nil
		
		var tmp = String()
		
		tmp.append("<")
		tmp.append(node.name)
		
		/// Compile Properties
		tmp.append(compile(properties: node.properties))

		if (!node.haveChildren() && node.hasData()) {
			//var tmpStr = compileString(">", node.dataString, "</", node.name, ">")
			tmp.append(">" + node.dataString + "</" + node.name + ">");
		} else if (node.haveChildren()) {
			tmp.append(">");
		} else if isEmptyNode(node) {
			tmp.append(" />");
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
		
		/// Close parent tag
		if (prevNode != nil && prevNode!.parent != nil) {
			output.append(indent)
			output.append(endTag(prevNode!.parent!.name))
			if prettyPrint {
				output.append(CharConst.LF)
			}
		}
	}
	
	public func serialize(rootNode: FlexNode, options: XMLFormattingOptions = []) -> String {
		var output: String = String("<?xml version=\"1.0\" standalone=\"yes\" ?>")
		processNode(rootNode, 0, &output, [.prettyPrint])
		return output
	}
}
