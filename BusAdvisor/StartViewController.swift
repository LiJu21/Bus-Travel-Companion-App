//
//  StartViewController.swift
//  Demo1
//
//  Created by Harry Wang on 26/04/2018.
//  Copyright © 2018 COMP208. All rights reserved.
//

import UIKit

class StartViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

//	@IBAction func LaunchProgram(_ sender: UIButton) {
//		let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
//		if (launchedBefore) {
//			self.performSegue(withIdentifier: "NavigationViewController", sender: sender)
//		} else {
//			self.performSegue(withIdentifier: "InstructionViewController", sender: sender)
//		}
//	}
	
	override func viewDidAppear(_ animated: Bool) {
		let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
		if (launchedBefore) {
			self.performSegue(withIdentifier: "NavigationViewController", sender: self)
		} else {
			self.performSegue(withIdentifier: "InstructionViewController", sender: self)
		}
	}
	override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
	

//		let storyBoard = UIStoryboard(name: "Main", bundle: Bundle(identifier: "COMP208GroupProjectFinal.Demo1"))
//		// Override point for customization after application launch.
//		let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
//		if launchedBefore
//		{
//			print("Has launched before")
//			let VC = storyBoard.instantiateViewController(withIdentifier: "ViewController")
//			self.window?.rootViewController = VC
//		}
//		else
//		{
//			print("First launch")
//			UserDefaults.standard.set(true, forKey: "launchedBefore")
//			let VC = storyBoard.instantiateViewController(withIdentifier: "InstructionViewController")
//			self.window?.rootViewController = VC
//		}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
