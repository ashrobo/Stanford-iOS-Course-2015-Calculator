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
    
    var userIsInTheMiddleOfTypingANumber = false;
    
    @IBAction func appendDigit(sender: UIButton) {
        var digit = sender.currentTitle!
        
        if digit == "." && display.text!.rangeOfString(".") != nil {
            return;
        }
        
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
        
        appendToHistoryLabel(digit)
    }
    
    @IBAction func operate(sender: UIButton!) {
        var operation = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        
        switch operation {
        case "x": performOperation { $0 * $1 }
        case "-": performOperation { $1 - $0 }
        case "/": performOperation { $1 / $0 }
        case "+": performOperation { $0 + $1 }
        case "√": performOperation { sqrt($0) }
        case "SIN": performOperation { sin($0) }
        case "COS": performOperation { cos($0) }
        case "π": performOperation { $0 * M_PI }
        default: break
        }
        
        appendToHistoryLabel(" " + operation + " ")
    }
    
    func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    func appendToHistoryLabel(text: String) {
        historyLabel.text = historyLabel.text! + text;
    }
    
    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
    }
    
    @IBAction func clear(sender: UIButton) {
        operandStack.removeAll(keepCapacity: false)
        display.text = ""
        historyLabel.text = ""
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = true
        }
    }
}

