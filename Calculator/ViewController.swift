//
//  ViewController.swift
//  Calculator
//
//  Created by Rafagan Abreu on 13/11/17.
//  Copyright © 2017 CINQ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    
    var userIsTyping: Bool = false
    var manager = CalculatorManager()
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    @IBAction func touchClear(_ sender: UIButton) {
        if !self.userIsTyping {
            self.manager.clearMemory()
        }
        display.text = "0"
        userIsTyping = false
        self.clearButton.setTitle("AC", for: .normal)
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsTyping {
            let textDisplay = display.text ?? ""
            display.text = textDisplay == "0" && digit == "0" ? textDisplay : textDisplay + digit
        } else {
            display.text = digit
            userIsTyping = true
            self.clearButton.setTitle("C", for: .normal)
        }
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsTyping {
            self.userIsTyping = false
            self.manager.setOperand(displayValue)
        }
        if let mathSymbol = sender.currentTitle {
            self.manager.performOperation(mathSymbol)
        }
        self.displayValue = self.manager.result
        
    }
}
