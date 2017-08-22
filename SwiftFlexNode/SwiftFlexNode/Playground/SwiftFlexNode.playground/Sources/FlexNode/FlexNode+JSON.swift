//
//  ZynapticNode+JSON.swift
//
//  This file if part of the
//  Zynaptic Node Framework
//
//  Created by Patrik Forsberg on 03/12/16.
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

public class FlexNodeJSON {
	var rootNode: FlexNode
	
	
	let compileString: (String...) -> (String) = { parts in
		var result = String()
		for part in parts { result.append(part) }
		return result
	}

	
	init(rootName: String) {
		self.rootNode = FlexNode()
	}
	
	fileprivate func processNode(node: inout FlexNode, json: inout String) {
	
		let compileString: (String...) -> (String) = { parts in
			var result = String()
			for part in parts { result.append(part) }
			return result
		}

	}
	
	///
	/// This function serializes a FlexNode object
	///
	/// Returns: JSON String representation
	///
	func toJSON(node: FlexNode) -> String {
		var json = String(CharConst.beginObject)

	
		json?.append(CharConst.endObject)
		return json!
	}
}
