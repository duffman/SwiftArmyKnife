//
//  ZynapticNode.swift
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

/*
	Zynaptic Node
	TODO: DUFFMAN!!! Se till att properties är noder utan collection
	www.coldmind.com
*/

import Foundation

public typealias ZynNodeList = [ZynNode]
public typealias ZynNodeProperty = (name: String, value: Any?)
public typealias ZynNodePropertyList = Array<ZynNodeProperty> //[String: Any?] //[(String, Any?)]

public class ZynNode {
	var parentNode: ZynNode?
	public var parent: ZynNode? {
		get {
			return self.parentNode
		}
	}
	public var name: String = String()
	public var data: Any?
	public var dataString: String {
		get {
			return data != nil ? data as! String : ""
		}
	}
	public var properties: ZynNodePropertyList = ZynNodePropertyList()
	public var childNodes: ZynNodeList = ZynNodeList()
	public var childCount: Int {
		get {
			return childNodes.count
		}
	}

	public init(_ name: String? = String()) {
		self.name = name!
	}
	
	public func setParent(node: ZynNode) {
		self.parentNode = node
	}
	
	public func set(value: Any?) -> ZynNode {
		self.data = value
		return self
	}

	public func set(value: String) -> ZynNode {
		self.data = value
		return self
	}
	
	/// Adds a node instance to the child node array
	/// The child node array remains uninirialized until
	/// it is needed in order to avoid unnessesary overhead
	///
	/// - Returns: The newly created node
	///
	public func addChildNode(_ node: ZynNode) -> ZynNode {
		node.setParent(node: self)
		self.childNodes.append(node)
		return node
	}

	public func newChild(_ name: String, nodeValue: Any? = "") -> ZynNode {
		let node = ZynNode(name)
		node.parentNode = self
		node.data = nodeValue
		return self.addChildNode(node)
	}
	
	public func getFirstChild() -> ZynNode! {
		var node: ZynNode? = nil
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

	func addProperty(name: String, withValue: Any?) -> ZynNode {
		self.properties[name] = withValue
		return self
	}
	
	/// TODO: Write Descriptions
	/// Determine whether values in the boxes are equivalent.
	///
	/// - Returns: `nil` to indicate that the boxes store different types, so
	///   no comparison is possible. Otherwise, contains the result of `==`.
	func getProperty(withName name: String) -> ZynNodeProperty? {
		return self.properties[name] as! ZynNodeProperty?
	}
	
	func getPropertyValue(withName name: String, defaultValue: String = "") -> String {
		func anyValueToString(_ value: Any?) -> String {
			return value != nil ? value as! String : String()
		}

		let property = self.getProperty(withName: name)
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
	public func getChildIndex(_ child: ZynNode) -> Int {
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
	public func getChildByPos(_ index: Int) -> ZynNode? {
		var node: ZynNode? = nil
		if index <= self.childCount {
			node = self.childNodes[index]
		}
		return node
	}

	public func getNextSibling() -> ZynNode? {
		var sibling: ZynNode? = nil
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
	
	public func firstChild() -> ZynNode? {
		var node: ZynNode? = nil
		if self.haveChildren() {
			node = self.childNodes.first
		}
		return node
	}
	
	public func putProperty(name: String, value: Any) -> ZynNode {
		self.properties[name] = value
		return self
	}
	
	public func hasProperty(withName: String) -> Bool {
		return self.properties[name] != nil
	}
	
	public func getProperty(key: String) -> Any {
		return self.properties[key];
	}
	
	/// Returns a string representation of a node object
	///
	/// - returns: string
	///
	public func toFormattedString() -> String {
		func processNode(_ node: ZynNode, _ level: Int, _ output: inout String, includeProperties: Bool = true) {
			var prefix = String(repeating: "\t", count: level)
			output.append(prefix)
			output.append(node.name)
			
			/*/+-- Properties --------------+//
			if node.haveChildren() && includeProperties {
				prefix.append("\t")

				for property in node.properties {
					output.append(prefix)
				
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
