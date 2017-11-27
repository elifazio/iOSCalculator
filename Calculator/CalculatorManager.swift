//
//  CalculatorManager.swift
//  Calculator
//
//  Created by Rafagan Abreu on 17/11/17.
//  Copyright © 2017 CINQ. All rights reserved.
//

import Foundation

struct CalculatorManager {
    private var accumulator: Double?
    private var binaryOperationMemory: PreviousBinaryOperation?
    
    private enum Operation {
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
        case undefined
    }
    
    private struct PreviousBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    private let operations: Dictionary<String, Operation> = [
        "√": Operation.unaryOperation(sqrt),
        "±": Operation.unaryOperation({ -$0 }),
        "+": Operation.binaryOperation({ (v1, v2) in v1 + v2 }),
        "–": Operation.binaryOperation({ (v1: Double, v2: Double) -> Double in return v1 - v2 }),
        "⨉": Operation.binaryOperation({ $0 * $1 }),
        "÷": Operation.binaryOperation({ $0 / $1 }),
        "=": Operation.equals,
        //"%": Operation.binaryOperation(???)
    ]
    
    var result: Double? {
        get {
            return accumulator
        }
    }
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .unaryOperation(let op):
                accumulator = (accumulator != nil ? op(accumulator!) : accumulator)
            case .binaryOperation(let op):
                if accumulator != nil {
                    binaryOperationMemory = PreviousBinaryOperation(function: op, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                doPreviousBinaryOperation()
            default:
                break
            }
        }
    }
    
    mutating func doPreviousBinaryOperation() {
        if binaryOperationMemory != nil && accumulator != nil {
            accumulator = binaryOperationMemory!.perform(with: accumulator!)
            binaryOperationMemory = nil
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
}
