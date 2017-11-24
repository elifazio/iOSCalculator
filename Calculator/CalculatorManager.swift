//
//  CalculatorManager.swift
//  Calculator
//
//  Created by Rafagan Abreu on 17/11/17.
//  Copyright © 2017 CINQ. All rights reserved.
//

import Foundation

struct CalculatorManager {
    enum Operation {
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
        case unknown
    }
    
    private struct PreviousBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
        
    }
    
    private var accumulator: Double = 0.0
    private var previousOperand: Double = 0.0
    private var binaryOperationMemory: PreviousBinaryOperation?
    private let operations: [String: Operation] = [
        "+": Operation.binaryOperation({ $0 + $1 }),
        "-": Operation.binaryOperation({ $0 - $1 }),
        "⨉": Operation.binaryOperation({ $0 * $1 }),
        "÷": Operation.binaryOperation({ $0 / $1 }),
        "=": Operation.equals,
        "±": Operation.unaryOperation({ $0 == 0 ? $0 : -$0 }),
        "%": Operation.binaryOperation({ $0 * ($1 / 100) }),
        "√": Operation.unaryOperation(sqrt)
    ]
    
    var result: Double {
        get {
            return accumulator
        }
    }
    
    mutating func performOperation(_ symbol: String) {
        guard let operation = self.operations[symbol] else { return }
        
        switch operation {
        case .unaryOperation(let op):
            self.accumulator = op(self.accumulator)
        case .binaryOperation(let op):
            if symbol.elementsEqual("%") {
                self.binaryOperationMemory = PreviousBinaryOperation(function: op, firstOperand: self.binaryOperationMemory?.firstOperand ?? 0)
                doPreviousBinaryOperation()
            } else {
                self.binaryOperationMemory = PreviousBinaryOperation(function: op, firstOperand: self.accumulator)
            }
        case .equals:
            doPreviousBinaryOperation()
        default:
            break
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
        previousOperand = operand
    }
    
    mutating func doPreviousBinaryOperation() {
        guard let op = self.binaryOperationMemory else { return }
        self.binaryOperationMemory = PreviousBinaryOperation(function: self.binaryOperationMemory!.function, firstOperand: self.previousOperand)
        self.accumulator = op.perform(with: self.accumulator)
    }
    
    mutating func clearMemory() {
        self.accumulator = 0
        self.binaryOperationMemory = nil
    }
}
