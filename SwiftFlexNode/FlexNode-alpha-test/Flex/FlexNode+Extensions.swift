//
//  ZynapticNode+Extensions.swift
//
//  This file if part of the
//  Zynaptic Node Framework
//
//  Created by Patrik Forsberg on 05/01/17.
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

// MARK: - String Extensions
public extension String {
	subscript (i: Int) -> String? {
		let index = self.index(self.startIndex, offsetBy: 1)
		return self.substring(to: index)
	}
	
	func firstChar() -> String {
		return self[1]!
	}
	
	func firstCharAsString() -> Character {
		return Character(firstChar())
	}
	
	public func quote() -> String {
		var quotedString: String = CharConst.quotationMark
		quotedString.append(self)
		quotedString.append(CharConst.quotationMark)
		return quotedString
	}
	
	func lowerFirstChar() -> String {
		var result = self.firstChar().lowercased()
		
		// Cut out the first char from the string
		let index = self.index(self.startIndex, offsetBy: 1)
		result.append(self.substring(from: index))
		
		return result
	}
	
	mutating func addChunks(_ chunks: String...) -> String {
		for part in chunks { self.append(part) }
		return self
	}
}

// MARK: - Mirror Extensions
public extension Mirror {
	/// Builds an array with properties from given class and super class
	///
	/// - returns: array of tuples with label -> value OF each property
	public func getAllProperties() -> [(label: String?, value: Any)] {
		var children: [(label: String?, value: Any)] = []
		for element in self.children {
			children.append(element)
		}
		
		children.append(contentsOf: self.superclassMirror?.getAllProperties() ?? [])
		
		return children
	}
	
	public func isClassOrStruct() -> Bool {
		return objectMirrorStyles.contains(self.displayStyle!)
	}
}
