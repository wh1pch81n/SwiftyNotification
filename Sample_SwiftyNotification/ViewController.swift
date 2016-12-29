//
//  ViewController.swift
//  Sample_SwiftyNotification
//
//  Created by Derrick Ho on 12/29/16.
//  Copyright © 2016 Derrick Ho. All rights reserved.
//

import UIKit
import Foundation
import SwiftyNotificationFramework

extension SwiftyNotificationCenter {
	static var buttonNotification = SwiftyNotification<String, String, Int>()
}

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		SwiftyNotificationCenter.buttonNotification.add(subscriber: self) { (info, n) in
			print(info)
			n = 8
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		let a = SwiftyNotificationCenter.buttonNotification.broadcastNotification(with: ["hello": "world"])
		print(a)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

