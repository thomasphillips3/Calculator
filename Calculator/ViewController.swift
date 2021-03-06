//
//  ViewController.swift
//  Calculator
//
//  Created by Thomas Phillips on 5/14/17.
//  Copyright © 2017 Aspire. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    var userIsTyping = false
    var decimalCount = 0
    
    var displayValue: Double {
        get {
            return Double (display.text!)!
        } set {
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsTyping {
            brain.setOperand(displayValue)
            userIsTyping = false
            decimalCount = 0
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        if let result = brain.result{
            displayValue = result
        }
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if (userIsTyping) {
            if digit == "." {
                decimalCount += 1
                if (decimalCount > 1){
                    return
                }
            }
            let displayText = display.text!
            display.text = displayText + digit
        } else {
            display.text = digit
            userIsTyping = true
        }
    }
    
    @IBAction func clearInput(_ sender: UIButton) {
        userIsTyping = false
        decimalCount = 0
        display.text = "0"
    }
}

