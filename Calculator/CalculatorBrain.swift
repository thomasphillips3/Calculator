//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Thomas Phillips on 6/20/17.
//  Copyright © 2017 Aspire. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    private var accumulator: (Double, String)?
    
    mutating func setOperand(_ operand: Double) {
        accumulator = (operand, "\(operand)")
    }

    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt, { "√" + $0 }),
        "±" : Operation.unaryOperation({ -$0 }, { "-(" + $0 + ")" }),
        "×" : Operation.binaryOperation({ $0 * $1 }, { $0 + " × " + $1 }),
        "+" : Operation.binaryOperation({ $0 + $1 }, { $0 + " + " + $1 }),
        "-" : Operation.binaryOperation({ $0 - $1 }, { $0 + " - " + $1 }),
        "÷" : Operation.binaryOperation({ $0 / $1 }, { $0 + " ÷ " + $1 }),
        "cos" : Operation.unaryOperation(cos, { "cos(" + $0 + ")" }),
        "sin" : Operation.unaryOperation(sin, { "sin(" + $0 + ")" }),
        "=" : Operation.equals
    ]
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double, (String) -> String)
        case binaryOperation((Double, Double) -> Double, (String, String) -> String)
        case equals
    }
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = (value, symbol)
            case .unaryOperation(let function, let description):
                if accumulator != nil {
                    accumulator = (function(accumulator!.0), description(accumulator!.1))
                }
            case .binaryOperation(let function, let description):
                if nil != accumulator {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, description: description, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if (pendingBinaryOperation != nil) && (accumulator != nil) {
            accumulator = (pendingBinaryOperation!.perform(with: accumulator!))
            pendingBinaryOperation = nil
        }
    }

    private var pendingBinaryOperation: PendingBinaryOperation?
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let description: (String, String) -> String
        let firstOperand: (Double, String)
        
        func perform(with secondOperand: (Double, String)) -> (Double, String) {
            return (function(firstOperand.0, secondOperand.0), description(firstOperand.1, secondOperand.1))
        }
    }
    

    var result: Double? {
        get {
            if nil != accumulator {
                return accumulator!.0
            }
            return nil
        }
    }
    
    var resultIsPending: Bool {
        get {
            return nil != pendingBinaryOperation
        }
    }
    
    var description: String? {
        get {
            if resultIsPending {
                return pendingBinaryOperation!.description(pendingBinaryOperation!.firstOperand.1, accumulator?.1 ?? "")
            } else {
                return accumulator?.1
            }
        }
    }
}
