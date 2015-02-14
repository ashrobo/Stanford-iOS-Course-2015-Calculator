//
//  ViewController.swift
//  Calculator
//
//  Created by Ash Robinson on 01/02/2015.
//  Copyright (c) 2015 Ash Robinson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var historyLabel: UILabel!
    @IBOutlet weak var decimalButton: UIButton!
    
    var userIsInTheMiddleOfTypingANumber = false;
    let decimalSeparator = NSNumberFormatter().decimalSeparator!
    
    var brain = CalculatorBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        decimalButton.setTitle(decimalSeparator, forState: UIControlState.Normal)
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber {
            if (digit == decimalSeparator) && (display.text!.rangeOfString(decimalSeparator) != nil) { return }
            if (digit == "0") && ((display.text == "0") || (display.text == "-0")) { return }
            if (digit != decimalSeparator) && ((display.text == "0") || (display.text == "-0")) {
                if (display.text == "0") {
                    display.text = digit
                } else {
                    display.text = "-" + digit
                }
            } else {
                display.text = display.text! + digit
            }
        } else {
            if digit == decimalSeparator {
                display.text = "0" + decimalSeparator
            } else {
                display.text = digit
            }
            userIsInTheMiddleOfTypingANumber = true
            historyLabel.text = brain.showStack()
        }
    }
    
    @IBAction func operate(sender: UIButton!) {
        if let operation = sender.currentTitle {
            if userIsInTheMiddleOfTypingANumber {
                if operation == "±" {
                    let displayText = display.text!
                    if (displayText.rangeOfString("-") != nil) {
                        display.text = dropFirst(displayText)
                    } else {
                        display.text = "-" + displayText
                    }
                    return
                }
                enter()
            }
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = nil
            }
        }
    }

    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if displayValue != nil {
            if let result = brain.pushOperand(displayValue!) {
                displayValue = result
            } else {
                displayValue = nil
            }
        }
    }
    
    @IBAction func clear(sender: UIButton) {
        brain = CalculatorBrain()
        displayValue = nil
        historyLabel.text = ""
    }
    
    @IBAction func undoTapped(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            let displayText = display.text!
            if countElements(displayText) > 1 {
                display.text = dropLast(displayText)
                if (countElements(displayText) == 2) && (display.text?.rangeOfString("-") != nil) {
                    display.text = "-0"
                }
            } else {
                display.text = "0"
            }
        }
    }
    
    var displayValue: Double? {
        get {
            return NSNumberFormatter().numberFromString(display.text!)?.doubleValue
        }
        set {
            if (newValue != nil) {
                let numberFormatter = NSNumberFormatter()
                numberFormatter.numberStyle = .DecimalStyle
                numberFormatter.maximumFractionDigits = 10
                display.text = numberFormatter.stringFromNumber(newValue!)
            } else {
                display.text = "0"
            }
            userIsInTheMiddleOfTypingANumber = false
            let stack = brain.showStack()
            if !stack!.isEmpty {
                historyLabel.text = join(decimalSeparator, stack!.componentsSeparatedByString(".")) + " ="
            }
        }
    }
}

