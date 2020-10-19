#!/usr/bin/swift

//
//  main.swift
//  GetConfigFromTestD
//
//  Created by Ivan Khau on 8/16/18.
//  Copyright © 2018 Ivan Khau. All rights reserved.
//

import Foundation

var input = "/Users/ivankhau/Desktop/Logs-N00GK84Q-2018-08-14-16-27-15/macos/AppleInternal/Diagnostics/Logs/testd.log"

if CommandLine.arguments.count > 1 {
    input = CommandLine.arguments[1]
}

var contents = try? String(contentsOfFile: input, encoding: String.Encoding.utf8)
var contentsBreakdown = contents?.components(separatedBy: "\n")

var ram: Int = 0
var storage: String = ""
var processor: [String] = ["","",""]

for (i, line) in contentsBreakdown!.enumerated() {
    //print(line)
    if ram == 0 {
        if line.contains("\"type\" : \"DIMM\",") {
            //print(line)
            let start:Int = i - 25
            let end:Int = i + 150
            
            for n in start...end {
                let tempLine = contentsBreakdown![n]
                if tempLine.contains("\"size\" : \"") {
                    
                    //print(tempLine)
                    
                    var tempLineSplit = tempLine.components(separatedBy: "\"size\" : \"")
                    var tempLineSplitSplit = tempLineSplit[1].components(separatedBy: " ")
                    if let ramSize = Int(tempLineSplitSplit[0]) {
                        ram = ram + ramSize
                    }
                }
            }
            continue
        }
    }
    
    if storage == "" {
        if line.contains("\"volumeName\" : ") {
            storage = line.components(separatedBy: "\"volumeName\" : ")[1]
        }
    }
    
    if processor == ["","",""] {
        if line.contains("type\" : \"Processor\",") {
            let start = i - 20
            let end = i + 20
            
            for n in start...end {
                let tempLine = contentsBreakdown![n]
                if tempLine.contains("\"frequency\" : ") {
                    var freqTemp = tempLine.components(separatedBy: "\"frequency\" : ")
                    var freqTempTemp = freqTemp[1]
                    if freqTempTemp.last == "," {
                        freqTempTemp.removeLast()
                    }
                    processor[0] = freqTempTemp
                }
                
                if tempLine.contains("\"physicalCores\" : ") {
                    var freqTemp = tempLine.components(separatedBy: "\"physicalCores\" : ")
                    var freqTempTemp = freqTemp[1]
                    if freqTempTemp.last == "," {
                        freqTempTemp.removeLast()
                    }
                    processor[1] = freqTempTemp
                }
                
                if tempLine.contains("\"logicalCores\" : ") {
                    var freqTemp = tempLine.components(separatedBy: "\"logicalCores\" : ")
                    var freqTempTemp = freqTemp[1]
                    if freqTempTemp.last == "," {
                        freqTempTemp.removeLast()
                    }
                    processor[2] = freqTempTemp
                }
                
            }
            continue
        }
    }
    
    if ram != 0 && storage != "" && processor != ["","",""] {
        break
    }
    
}

print("Processor: \(processor[0]) MHz, \(processor[1]) Physical Cores, \(processor[2]) Logical Cores")
print("Memory: \(ram)gb")
print("Storage: \(storage)")
