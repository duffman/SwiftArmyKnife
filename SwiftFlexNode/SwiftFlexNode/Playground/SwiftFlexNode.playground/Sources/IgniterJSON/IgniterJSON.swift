//===----------------------------------------------------------------------===//
//
// This source file is part of the IgniterJSON Library
//
// Copyright (c) 2014 - 2016 Coldmind Ltd.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://www.coldmind.com for more information and usage docs
//
//===----------------------------------------------------------------------===//

import Foundation

public class JSONParser {
	public init() {
	}
	
	public func parseJsonString(_ jsonString: String, completion: (JSONData?, ParserError?) -> Void) {
		var parsingError: ParserError?
		var jsonDataArray: JSONData?
		
		do {
			let jsonData = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: false)
			
			jsonDataArray = try JSONSerialization.jsonObject(with: jsonData!, options:
				JSONSerialization.ReadingOptions.mutableContainers
				) as? JSONData
			
		} catch {
			parsingError = ParserError(errorMessage: "JSON Processing Failed")
		}
		
		completion(jsonDataArray, parsingError)
	}
	
	public func parseMessage(jsonString: String) -> Bool {
		self.parseJsonString(jsonString, completion: { (data, error) in
			if let error = error {
				print(error.message)
			} else {
				for item in data!  {
					debugPrint(item.key)
				}
				
			}
		})
		
		return true
	}
}
