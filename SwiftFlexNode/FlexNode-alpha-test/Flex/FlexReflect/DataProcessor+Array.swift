import Foundation

public func processArray(_ array: Array<Any>, _ node: inout FlexNode) throws {
	for index in 0..<array.count {
		let isLastItem = (index + 1 >= array.count)
		let element = array[index]
		
		if element is String {
			let value = String(element as! String)!
			_ = node.newChild(value)
			print(">> processArray> " + value)

			if !isLastItem {
				//DUFFMAN: json.append(CharConst.comma)
			}
		}
	} // end for
} // end class
