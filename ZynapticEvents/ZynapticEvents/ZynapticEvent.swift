import Foundation

// let queue = DispatchQueue(label: "com.coldmind.ZynapticEvent", attributes: [])

public protocol ZynapticEventDispatcher {
}

public struct EventData {
	public var eventData: Any?
	public init(_ data: Any? = nil) {
		self.eventData = data
	}
}

public typealias EventReceiver = (EventData) -> ()
public typealias EventListenerList = [EventListener]

/*
The event listener acts as a wrapper around the receiver
closure, it´s implemented as a value type so that it will
nil when going off the stack, that way we can both dispose
the value typed receiver and remove the listener from the hub
*/
public struct EventListener {
	var receiver: EventReceiver
	
	public init(_ receiver: @escaping EventReceiver) {
		self.receiver = receiver
	}
}
