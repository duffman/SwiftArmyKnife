//
//  EventHub.swift
//  ZynapticEvents
//
//  Created by Patrik Forsberg on 20/01/17.
//  Copyright © 2017 Patrik Forsberg. All rights reserved.
//

import Foundation

public class ZynapticEvent {
	public class var hub: ZynapticEventHub {
		struct Singleton {
			static let hub = ZynapticEventHub()
		}
		return Singleton.hub
	}
}

public class ZynapticEventHub {
	private var eventListeners = EventListenerList()
	
	public func connectListener(receiver: @escaping EventReceiver) -> EventListener {
		let listener = EventListener(receiver)
		eventListeners.append(listener)
		return listener
	}
	
	public func dispatch(_ data: EventData) {
		//et notifyListeners: (EventData) -> () = { data in
		//}
		
		for listener in eventListeners {
			listener.receiver(data)
		}
	}
}
