//
//  ViewController.swift
//  Tip.io
//
//  Created by Luke B on 12/29/16.
//  Copyright © 2016 Luke. All rights reserved.
//

import UIKit

extension UITextField {
    
    func useUnderline() {
        let border = CALayer()
        let borderWidth = CGFloat(1.0)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(origin: CGPoint(x: 0,y :self.frame.size.height - borderWidth), size: CGSize(width: self.frame.size.width, height: self.frame.size.height))
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var numberPicker: UIPickerView!
    
    @IBOutlet weak var currencySymbolLabel: UILabel!
   //split pay stuff
    @IBOutlet weak var personLabel: UILabel!
    @IBOutlet weak var costPerPersonLabel: UILabel!
    
    var peopleCount:Double = 1
    let currencyFormatter = NumberFormatter()
    @IBOutlet weak var resultsCard: UIView!
    @IBOutlet weak var backgroundView: UIView!
    
    //customcolors
    
    let customColors = [
        UIColor.init(red: 0/255, green: 122/255, blue: 255/255, alpha: 1),//Blue (0)
        UIColor.init(red: 255/255, green: 59/255, blue: 48/255, alpha: 1),//Red (1)
        UIColor.init(red: 88/255, green: 86/255, blue: 214/255, alpha: 1),//Purple (2)
        UIColor.init(red: 255/255, green: 149/255, blue: 0/255, alpha: 1),//Orange (3)
        UIColor.init(red: 76/255, green: 217/255, blue: 100/255, alpha: 1),//Green (4)
        UIColor.init(red: 255/255, green: 204/255, blue: 0/255, alpha: 1)//Yellow(5)
    ]
    
    //I probably could've used a dictionary up there, but eh.
    
    
    let defaults = UserDefaults.standard
    
    //picker view shenanigans
    
    var numberPickerData = [String]()
    
    //for determining when to vibrate
    
    var cardIsUp = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Tip Calculator"
        
        
        for index in 1...30 {
            numberPickerData.append(String(index))
        }
        
        print(numberPickerData)
        
        self.numberPicker.dataSource = self;
        self.numberPicker.delegate = self;
    
        tipControl.selectedSegmentIndex = defaults.integer(forKey:"defaultTipValue")
        resultsCard.layer.cornerRadius = 10
        billField.useUnderline()

        backgroundView.backgroundColor = customColors[defaults.integer(forKey: "customColorsIndex")]
        billField.becomeFirstResponder()
        
        billField.attributedPlaceholder = NSAttributedString(string: "Bill Amount", attributes: [NSForegroundColorAttributeName: UIColor.white])
        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tipControl.selectedSegmentIndex = defaults.integer(forKey:"defaultTipValue")
        calculateTip(defaults)
        backgroundView.backgroundColor = customColors[defaults.integer(forKey: "customColorsIndex")]
        resultsCard.transform = CGAffineTransform(translationX: 0, y: 400)
        
        
        print(NSLocale.Key.self)
        
        let locale = NSLocale.current
        
        currencySymbolLabel.text = locale.currencySymbol
        
        
        
        if(defaults.object(forKey: "lastTimeUsed") != nil ){
        
        let tempDate = defaults.object(forKey: "lastTimeUsed") as! NSDate
        let intervalDifference = tempDate.timeIntervalSinceNow
        
        if(intervalDifference < -600){
            billField.text = ""
            defaults.set("", forKey: "billFieldDefaults")
            defaults.synchronize()
            }
        }
        
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = NumberFormatter.Style.currency
        currencyFormatter.locale = NSLocale.current
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        billField.text = defaults.string(forKey:"billFieldDefaults")
        if(billField.text != ""){calculateTip(self)}

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if(billField.text != ""){
        defaults.set(billField.text, forKey: "billFieldDefaults")
        defaults.set(NSDate.init(), forKey: "lastTimeUsed")
        defaults.synchronize()
        }
        print("View unloaded")
    }
    
    @IBAction func onTap(_ sender: Any) {
        //view.endEditing(true)
        print(defaults.integer(forKey: "defaultTipValue" ))
        tipControl.selectedSegmentIndex = defaults.integer(forKey:"defaultTipValue")
        

    }

    @IBAction func calculateTip(_ sender: AnyObject) {
        
        let tipPercentages = [0.18,0.2,0.25]
        
        
        //locale code, but I don't think I'll get it working in time. Least of my priorities.
        let tempBillDouble = Double(billField.text!) ?? 0
        let tempBillNSNumber = NSNumber(value:tempBillDouble)
        let convertedInput = currencyFormatter.string(from: tempBillNSNumber)
        
        print(convertedInput!)
        
        
        let bill = Double(billField.text!) ?? 0
        let tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
        let total = bill + tip
        
        
        /*
        tipLabel.text =  "With a tip of " + String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
        
 */
        
        tipLabel.text = "With a tip of " + currencyFormatter.string(from:NSNumber(value:tip))!
        totalLabel.text = currencyFormatter.string(from:NSNumber(value:total))!
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.4, options: [], animations: {
            self.resultsCard.transform = CGAffineTransform(translationX: 0, y: 0)
            
        }, completion: nil)
        
        //this should be placed elsewhere
        let generator = UINotificationFeedbackGenerator()
        if(cardIsUp<2){
            generator.notificationOccurred(.success)
            cardIsUp += 1
        }
        
        
        let costPerPerson = total / peopleCount
        costPerPersonLabel.text = currencyFormatter.string(from:NSNumber(value:costPerPerson))! + " Per Person"
        
        defaults.set(billField.text, forKey: "billFieldDefaults")
        defaults.synchronize()
        
        
    }
    
    
    func setDefaultPercentage(tempIndex:Int){
        
    }
    
    
    //picker view functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numberPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print("loading number picker data")
        return numberPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(row>0){personLabel.text = "people"}
        peopleCount = Double(row) + 1
        calculateTip(self)
    }
    
    func changePercentSelection(index:Int) {
        tipControl.selectedSegmentIndex = index
        print(index)
    }

}

