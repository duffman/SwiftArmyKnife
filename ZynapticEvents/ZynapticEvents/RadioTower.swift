//
//  RadioTower.swift
//  IgniterMobileTest
//
//  Created by Patrik Forsberg on 11/01/17.
//  Copyright © 2017 Patrik Forsberg. All rights reserved.
//

import Foundation

public let callSign = "com.coldmind.RadioTower"

extension Notification.Name {
	static let towerSignal = Notification.Name(callSign)
}


/**********************************************************************
**********************************************************************/

public protocol SignalReceiver {
	func signalEvent()
}

/// Hashtable keys for the notofication object
struct SignalData {
	static let Id = "EVENT_TYPE"
	static let Data = "EVENT_DATA"
}

public enum SignalType {
	case Unknown
	case SocketData
	case Message
}

typealias SignalEvent = [AnyHashable: Any]
typealias SignalReceiverList = [SignalReceiver]

public class RadioTower {
	public class var control: RadioTower {
		struct Singleton {
			static let control = RadioTower()
		}
		return Singleton.control
	}

	var receivers: SignalReceiverList
	var receiverCount: Int {
		get {
			return self.receivers.count
		}
	}

	public init() {
		self.receivers = SignalReceiverList()
	}

	public func register(receiver: SignalReceiver) {
		//var index = self.receivers.index{$0 === receiver}!

		
		//return index
	}

	public func broadcastSignal() {
		let signalData: SignalEvent = [
				AnyHashable(SignalData.Id): SignalType.Message,
				AnyHashable(SignalData.Data): [String]()
			]
		
		NotificationCenter.default.post(
			name: .towerSignal,
			object: self,
			userInfo: signalData
		)
	}
}
