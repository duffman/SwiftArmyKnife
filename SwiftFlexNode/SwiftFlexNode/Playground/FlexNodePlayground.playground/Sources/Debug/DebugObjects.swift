import Foundation


public struct MyColor {
	public var FaveColor: String = "Blå"
}


public struct UserInterests {
	public var FavouriteHobby: String = "Folding Paper Airplanes"
	public var OtherHobbies: Array<String> = ["Soccer", "Football", "Mastrubating"]
	public var Color: MyColor = MyColor()
	public init() {
	}
}

public struct UserProfile {
	public var Presentation: String = "Detta är min presentation"
	public var FreeForChat: Bool = false
	public var Interests: UserInterests = UserInterests()
	public var Slagord: String = "Ge dom vad dom tål"
	public init() {
	}
}


public struct IgniterMessage {
	public var FirstName: String = "Patrik"
	public var LastName: String = "Forsberg"
	public var Age: Int = 35
	public var Profile: UserProfile? = UserProfile()
	public var Tags: Array<String> = ["King", "Programmer", "Bulle"]
	
	func toJSON() throws -> String {
		return ""
	}
	
	public init() {
		self.Profile = UserProfile()
	}
}

/// XML

public func createXmlDebugNode() -> FlexNode {
	let topNode = FlexNode("root")
	let chNode1 = topNode.newChild("Frukt")
		var bananNod = chNode1.newChild("Banan")
			bananNod.putProperty(name: "numer", value: "1")
		bananNod.putProperty(name: "origin", value: "Angola")
		bananNod.data = "Apor äter dessa"
		var bananBarn = bananNod.newChild("Bananbarn").putProperty(name: "testprop", value: "kul")
		bananBarn.data = "Bananbarn är vi allihopa"
		var jag = bananBarn.newChild("jag")
			jag.putProperty(name: "ful", value: "ja")
			jag.data = "just det"
		let chSubNode2 = chNode1.newChild("Äpple").data = "Gott i fruktsallad"
		let chSubNode3 = chNode1.newChild("Kiwi").data = "Växer på Nya Zeeland"
	let chNode2 = topNode.newChild("User").putProperty(name: "name", value: "Patrik Forsberg")
		.putProperty(name: "age", value: 35).putProperty(name: "profession", value: "programmer")
	let chNode3 = topNode.newChild("Djur")
		let achSubNode3 = chNode3.newChild("Fisk").data = "Simmar i havet"
		let achSubNode4 = chNode3.newChild("Antilop").data = "Springer fort som fan"
		let achSubNode5 = chNode3.newChild("Lejon").data = "Är mitt stjärntecken"
		let achSubNode6 = chNode3.newChild("Hare")
			let achSubSubNode6 = achSubNode6.newChild("Vildhare")
			let achSubSubNode7 = achSubNode6.newChild("Fulhare")
			let achSubNode7 = chNode3.newChild("Zebra")
	
	let chNode4 = topNode.newChild("Nod1").putProperty(name: "color", value: "blue")
		.putProperty(name: "age", value: 54)
	let chNode5 = topNode.newChild("Nod2")
	_ = topNode.newChild("Nod3")
	
	return topNode
}
