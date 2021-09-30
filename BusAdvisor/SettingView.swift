//
//  SettingView.swift
//  Demo1
//
//  Created by Qiyao Zuo on 19/04/2018.
//  Copyright © 2018 COMP208. All rights reserved.
//

import UIKit
import MediaPlayer

class SettingView: UIViewController {
    //distance
    @IBOutlet weak var distanceController: UISegmentedControl!
    @IBAction func indexChanged(_ sender: Any) {
        switch distanceController.selectedSegmentIndex{
        case 0:
            ViewController.settingValue.constrainDistance=100.0
            
        case 1:
            ViewController.settingValue.constrainDistance=200.0
        case 2:
            ViewController.settingValue.constrainDistance=300.0
        case 3:
            ViewController.settingValue.constrainDistance=400.0
        case 4:
            ViewController.settingValue.constrainDistance=500.0
        case 5:
            ViewController.settingValue.constrainDistance=600.0
        default:
            break
            
        }
    }
    
    //Volume
    
    @IBOutlet weak var VolumeController: UISlider!
    @IBAction func handleVolum(_ sender: Any) {
        
        do{
            try AVAudioSession.sharedInstance().setActive(true)
        }catch let error as NSError{
            print("\(error)")
        }
        //获取并赋值
        VolumeController.value = AVAudioSession.sharedInstance().outputVolume
        
        //添加监听
        NotificationCenter.default.addObserver(self, selector: #selector(getter: self.VolumeController), name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"), object: nil)
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        
    }
    
    
    //vibration
    
    @IBOutlet weak var VibSwitch: UISwitch!
    @IBAction func switchVib(_ sender: UISwitch) {
        let openStatus = sender.isOn
        if openStatus
        {
            ViewController.settingValue.isVibration=true
        }
        else
        {
            ViewController.settingValue.isVibration=false
        }
    }
    
    //change the alert itself
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.black.withAlphaComponent(0.8);
        self.navigationItem.title = "Setting"
        
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.view.removeFromSuperview();
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
