//
//  SettingsViewController.swift
//  Tip.io
//
//  Created by Luke B on 12/29/16.
//  Copyright © 2016 Luke. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var settingsViewBackground: UIView!
    @IBOutlet weak var defaultTipControl: UISegmentedControl!
    @IBOutlet weak var colorPicker: UIPickerView!
    
    let colorPickerData = ["Blue", "Red", "Purple", "Orange", "Green", "Yellow"]
    

    
    let defaults = UserDefaults.standard
    let customColors = [
        UIColor.init(red: 0/255, green: 122/255, blue: 255/255, alpha: 1),//Blue (0)
        UIColor.init(red: 255/255, green: 59/255, blue: 48/255, alpha: 1),//Red (1)
        UIColor.init(red: 88/255, green: 86/255, blue: 214/255, alpha: 1),//Purple (2)
        UIColor.init(red: 255/255, green: 149/255, blue: 0/255, alpha: 1),//Orange (3)
        UIColor.init(red: 76/255, green: 217/255, blue: 100/255, alpha: 1),//Green (4)
        UIColor.init(red: 255/255, green: 204/255, blue: 0/255, alpha: 1)//Yellow(5)
    ]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colorPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = colorPickerData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSForegroundColorAttributeName:UIColor.white])
        
        return myTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        defaults.set(row, forKey: "customColorsIndex")
        defaults.synchronize()
        
        settingsViewBackground.backgroundColor = customColors[defaults.integer(forKey: "customColorsIndex")]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        // Do any additional setup after loading the view.
        defaultTipControl.selectedSegmentIndex = (defaults.integer(forKey: "defaultTipValue"))
        settingsViewBackground.backgroundColor = customColors[defaults.integer(forKey: "customColorsIndex")]
        
        self.colorPicker.dataSource = self;
        self.colorPicker.delegate = self;
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    @IBAction func setDefaultPercentage(_ sender: Any) {
    defaults.set(defaultTipControl.selectedSegmentIndex, forKey: "defaultTipValue")
        defaults.synchronize()
        
        print(defaults.integer(forKey: "defaultTipValue"))
    }
    
    
    

}
