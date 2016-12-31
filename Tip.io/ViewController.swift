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

class ViewController: UIViewController {
    
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!
    
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Tip Calculator"
        tipControl.selectedSegmentIndex = defaults.integer(forKey:"defaultTipValue")
        resultsCard.layer.cornerRadius = 20
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
    
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
        print(defaults.integer(forKey: "defaultTipValue" ))
        tipControl.selectedSegmentIndex = defaults.integer(forKey:"defaultTipValue")
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
            self.resultsCard.transform = CGAffineTransform(translationX: 0, y: 0)
            
        }, completion: nil)
    }

    @IBAction func calculateTip(_ sender: AnyObject) {
        
        let tipPercentages = [0.18,0.2,0.25]
        
        let bill = Double(billField.text!) ?? 0
        let tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
        let total = bill + tip
        
        tipLabel.text =  String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
        
       
    }
    
    func setDefaultPercentage(tempIndex:Int){
        
    }
}

