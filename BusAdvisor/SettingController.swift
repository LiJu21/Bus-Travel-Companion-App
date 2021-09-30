//
//  SettingController.swift
//  Demo1
//
//  Created by Harry Wang on 20/04/2018.
//  Copyright © 2018 COMP208. All rights reserved.
//

import UIKit
import MediaPlayer

class SettingController: UIViewController {
	
	@IBOutlet var lowPower: UISwitch!
	@IBOutlet var VibSwitch: UISwitch!  // vibration
	@IBAction func switchVib(_ sender: UISwitch) {
		// set vibration on/off
		let openStatus = sender.isOn
		if openStatus {
			ViewController.settingValue.isVibration = true
		}
		else {
			ViewController.settingValue.isVibration = false
		}
	}
	
	@IBOutlet var distanceController: UISegmentedControl!
	
	@IBAction func switchPowerMode(_ sender: UISwitch) {
		let openStatus = sender.isOn
		if openStatus {
			ViewController.settingValue.isPowerSave = true
		} else {
			ViewController.settingValue.isPowerSave = false
		}
	}
	@IBAction func indexChanged(_ sender: UISegmentedControl) {
		// choose constrain distance
		switch distanceController.selectedSegmentIndex {
		case 0:
			ViewController.settingValue.constrainDistance = 100.0
		case 1:
			ViewController.settingValue.constrainDistance = 200.0
		case 2:
			ViewController.settingValue.constrainDistance = 300.0
		case 3:
			ViewController.settingValue.constrainDistance = 400.0
		case 4:
			ViewController.settingValue.constrainDistance = 500.0
		case 5:
			ViewController.settingValue.constrainDistance = 600.0
		default:
			break
		}
	}
	
	@IBAction func popInsturciton(_ sender: UIButton) {
		// pop up the instruction view as a sub view
		let VC = UIStoryboard(name: "Main", bundle: Bundle(identifier: "COMP208GroupProjectFinal.Demo1")).instantiateViewController(withIdentifier: "SettingViewController")
		VC.performSegue(withIdentifier: "ToInstructionTwo", sender: self)
	}
	
	@IBAction func popPolicy(_ sender: Any) {
		// pop up the policy view as a sub view
		let popUpVC = UIStoryboard(name: "Main", bundle: Bundle(identifier: "COMP208GroupProjectFinal.Demo1")).instantiateViewController(withIdentifier: "policyID") as! PolicyViewController
		self.addChildViewController(popUpVC)
		popUpVC.view.frame = self.view.frame
		popUpVC.view.layer.cornerRadius = 5
		self.view.addSubview(popUpVC.view)
		popUpVC.didMove(toParentViewController: self)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = NSLocalizedString("Setting", comment: "")
		self.navigationItem.title = NSLocalizedString("Setting", comment: "")
		
		switch ViewController.settingValue.constrainDistance {
		// the value user set before
		case 100.0:
			distanceController.selectedSegmentIndex = 0
		case 200.0:
			distanceController.selectedSegmentIndex = 1
		case 300.0:
			distanceController.selectedSegmentIndex = 2
		case 400.0:
			distanceController.selectedSegmentIndex = 3
		case 500.0:
			distanceController.selectedSegmentIndex = 4
		case 600.0:
			distanceController.selectedSegmentIndex = 5
		default:
			break
		}
		if (ViewController.settingValue.isVibration) {
			// the value user set before
			VibSwitch.isOn = true
		}else{
			VibSwitch.isOn = false
		}
		if (ViewController.settingValue.isPowerSave) {
			lowPower.isOn = true
		} else {
			lowPower.isOn = false
		}
		
	}
	
	
}

