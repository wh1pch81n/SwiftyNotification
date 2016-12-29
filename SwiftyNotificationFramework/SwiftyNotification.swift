//
//  SwiftyNotification.swift
//  SwiftyNotificationFramework
//
//  Created by Derrick Ho on 12/29/16.
//  Copyright © 2016 Derrick Ho. All rights reserved.
//

import Foundation

fileprivate struct WeakHolder <KEYTYPE: Hashable, VALUETYPE, RETURNTYPE> {
	weak var subscriber: AnyObject?
	var callback: ((_ info: [KEYTYPE:VALUETYPE], _ response: inout RETURNTYPE?) -> ())?
}

public class SwiftyNotification <KEYTYPE: Hashable, VALUETYPE, RETURNTYPE> {
	private var subscribers = [WeakHolder<KEYTYPE, VALUETYPE, RETURNTYPE>]()
	
	/**
	Will broadcast and send info to all subscribers of this notification and return objects if any.
	- parameter info: This dictionary will be sent to all subscribers
	- returns: The responses from each subscriber
	*/
	@discardableResult
	public func broadcastNotification(with info: [KEYTYPE:VALUETYPE]) -> [RETURNTYPE] {
		flushDeallocatedSubscribers()
		return subscribers.flatMap {
			var returnedObj: RETURNTYPE? = nil
			$0.callback?(info, &returnedObj)
			return returnedObj
		}
	}
	
	/**
	Add a subscriber to this notification
	- parameter subscriber: The object that wants to subscribe to this notification
	- parameter callback: This block will get called when this notification is broadcasted
	- parameter info: A dictionary object that the broadcaster might send
	- parameter response: The subscriber has the option to respond back to the broadcaster with an object.
	*/
	public func add(subscriber: AnyObject, with callback: @escaping (_ info: [KEYTYPE:VALUETYPE], _ response: inout RETURNTYPE?) -> ()) {
		flushDeallocatedSubscribers()
		subscribers.append(WeakHolder(subscriber: subscriber, callback: callback))
	}
	
	/**
	Removes subscriber from this notification
	*/
	public func remove(subscriber: AnyObject) {
		flushDeallocatedSubscribers()
		subscribers = subscribers.filter { $0.subscriber !== subscriber }
	}
	
	/**
	removes all nil'ed subscribers from the subscribers array
	*/
	private func flushDeallocatedSubscribers() {
		subscribers = subscribers.filter { $0.subscriber != nil }
	}
}
