//
//  FlexNode.swift
//
//  This file if part of the
//  Flex Node Framework
//
//  Created by Patrik Forsberg on 05/01/17.
//  Copyright © 2017 Coldmind, Ltd. All rights reserved.
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

public typealias FlexNodeList = [FlexNode]
public typealias FlexNodePropertyList = Array<FlexNodeProperty>

public class FlexNodeProperty {
	public var name: String
	public var value: Any?
	public var stringValue: String {
		get {
			return anyValueToString(value)
		}
	}
	public init(_ name: String, _ value: Any?) {
		self.name = name
		self.value = value
	}
}

public class FlexNode {
	var parentNode: FlexNode?
	public var parent: FlexNode? {
		get {
			return self.parentNode
		}
	}
	public var name: String = String()
	public var data: Any?
	public var dataString: String {
		get {
			return anyValueToString(data)
		}
	}
	public var properties: FlexNodePropertyList = FlexNodePropertyList()
	public var childNodes: FlexNodeList = FlexNodeList()
	public var childCount: Int {
		get {
			return childNodes.count
		}
	}
	
	public init(_ name: String? = String()) {
		self.name = name!
	}
	
	public func setParent(node: FlexNode) {
		self.parentNode = node
	}
	
	public func set(value: Any?) -> FlexNode {
		self.data = value
		return self
	}
	
	public func set(value: String) -> FlexNode {
		self.data = value
		return self
	}
	
	/// Adds a node instance to the child node array
	/// The child node array remains uninirialized until
	/// it is needed in order to avoid unnessesary overhead
	///
	/// - Returns: The newly created node
	///
	public func addChildNode(_ node: FlexNode) -> FlexNode {
		node.setParent(node: self)
		self.childNodes.append(node)
		return node
	}
	
	public func newChild(_ name: String, nodeValue: Any? = "") -> FlexNode {
		let node = FlexNode(name)
		node.parentNode = self
		node.data = nodeValue
		return self.addChildNode(node)
	}
	
	public func getFirstChild() -> FlexNode! {
		var node: FlexNode? = nil
		if self.haveChildren() {
			node = self.childNodes.first
		}
		return node
	}
	
	public func hasData() -> Bool {
		return self.dataString != ""
	}
	
	public func haveParent() -> Bool {
		return self.parentNode != nil
	}
	
	public func haveChildren() -> Bool {
		return self.childCount > 0
	}
	
	public func haveProperties() -> Bool {
		return self.properties.count > 0
	}
	
	/// Gets the value of a property with a given name
	///
	/// - parameter name:         property name
	/// - parameter defaultValue: the returned value if no property is found
	///
	/// - returns: property value
	func getPropertyValue(withName name: String, defaultValue: String = "") -> String {
		func anyValueToString(_ value: Any?) -> String {
			return value != nil ? value as! String : String()
		}
		
		let property = self.getProperty(byName: name)
		let propertyValue = property != nil ? anyValueToString(property?.value) : defaultValue
		return propertyValue
	}
	
	
	/// Gets index position of a child node
	///
	/// - parameter child: child node to find index position of
	///
	/// - returns: index of the node
	///
	/// - TODO: replace linear "brute force" with binary lookup
	///
	public func getChildIndex(_ child: FlexNode) -> Int {
		var index = -1
		if self.haveChildren() {
			index = self.childNodes.index{$0 === child}!
		}
		return index
	}
	
	/// Gets a child node at a given position
	///
	/// - parameter index: index of the node
	///
	/// - returns: node at given index position
	public func getChildByPos(_ index: Int) -> FlexNode? {
		var node: FlexNode? = nil
		if index <= self.childCount {
			node = self.childNodes[index]
		}
		return node
	}
	
	public func getNextSibling() -> FlexNode? {
		var sibling: FlexNode? = nil
		if self.haveParent() {
			var index = self.parent!.getChildIndex(self)
			let count = self.parent!.childCount
			index = index.advanced(by: 1)
			if index < count {
				sibling = self.parent!.getChildByPos(index)
			}
		}
		return sibling
	}
	
	public func firstChild() -> FlexNode? {
		var node: FlexNode? = nil
		if self.haveChildren() {
			node = self.childNodes.first
		}
		return node
	}
	
	public func hasProperty(withName name: String) -> Bool {
		return self.getProperty(byName: name) != nil
	}
	
	// TODO: FIX THIS - really ugly code
	public func putProperty(name: String, value: Any) -> FlexNode {
		var property = self.getProperty(byName: name)
		
		if (property == nil) {
			property = FlexNodeProperty(name, value)
			self.properties.append(property!)
		}
		else {
			property!.value = value
		}
		
		return self
	}
	
	/// TODO: Move to extension and map function
	func getProperty(byName name: String) -> FlexNodeProperty? {
		for property in self.properties {
			if property.name == name {
				return property
			}
		}
		return nil
	}
	
	
	/// Returns a string representation of a node object
	///
	/// - returns: string
	///
	public func toFormattedString() -> String {
		func processNode(_ node: FlexNode, _ level: Int, _ output: inout String, includeProperties: Bool = true) {
			var prefix = String(repeating: CharConst.tab, count: level)
			output.append(prefix)
			output.append(node.name)
			
			//+-- Properties --------------+//
			if node.haveChildren() && includeProperties {
				prefix.append("\t")
			
				for property in node.properties {
					output.append(prefix)
					output.append(property.name)
					output.append(":")
					output.append(property.stringValue)
					output.append("\n")
				}
			}
			//+----------------------------+/ */
			
			output.append("\n")
			
			for child in node.childNodes {
				let newLevel = level.advanced(by: 1)
				processNode(child, newLevel, &output)
			}
		}
		var output: String = String()
		processNode(self, 0, &output)
		return output
	}
}
