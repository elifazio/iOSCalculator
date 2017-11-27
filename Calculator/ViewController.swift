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
    
    private var userIsTyping: Bool = false
    private var manager = CalculatorManager()
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    @IBAction func touchClear(_ sender: UIButton) {
        userIsTyping = false
        display.text = "0"
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsTyping {
            let textDisplay = display.text ?? ""
            display.text = textDisplay + digit
        } else {
            display.text = digit
            userIsTyping = true
        }
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsTyping {
            userIsTyping = false
            manager.setOperand(displayValue)
        }

        if let mathSymbol = sender.currentTitle {
            manager.performOperation(mathSymbol)
        }
        
        if let result = manager.result {
            displayValue = result
        }
    }
}
