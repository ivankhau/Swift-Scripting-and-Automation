#!/usr/bin/swift

//
//  main.swift
//  MemoryTestStripper
//
//  Created by Ivan Khau on 8/3/18.
//  Copyright © 2018 Ivan Khau. All rights reserved.
//

import Foundation

var summaryLocation: String = ""

print(CommandLine.arguments.count)

if CommandLine.arguments.count > 1 {
    summaryLocation = CommandLine.arguments[1]
} else {
    summaryLocation = "/Users/ivankhau/Desktop/Earthbound-main-2018-07-31_12-48-48/EarthboundLogs/private/var/logs/Earthbound/summary.csv"
}

var csvContents = try String(contentsOfFile: summaryLocation, encoding: String.Encoding.utf8)
var csvContentsSplit = csvContents.components(separatedBy: "\n")
var start = 0
var parsedArray: [[String]] = []

for line in csvContentsSplit {
    if start == 0 && !line.contains("macefi_enable_ncm") {
        continue
    } else {
        start = 1
    }
    
    if line.contains("IGNORE") {
        if line.contains("macefi_cleanup/Reset") {
            break
        }
        continue
    }
    
    var lineContents = line.components(separatedBy: ",")
    parsedArray.append([lineContents[0] as! String, lineContents[1] as! String, lineContents[13] as! String, lineContents[14] as! String, lineContents[15] as! String])
    
    if line.contains("macefi_cleanup/Reset") {
        break
    }
    
}
var formattedString = ""
for line in parsedArray {
    let combined = line.joined(separator: ",")
    if formattedString == "" {
        formattedString = combined
    } else {
        formattedString = "\(formattedString)\n\(combined)"
    }
}

print("MacEFI Cycle Times:")
print(formattedString)
print("==================================================================================")

var macEFITotalSeconds: Int = 0
for line in parsedArray {
    var time = line[4]
    var timeSplit = time.components(separatedBy: ":")
    
    var hour = Int(timeSplit[0])
    var minute = Int(timeSplit[1])
    var second = Int(timeSplit[2])
    
    var totalInSeconds = (hour! * 60 * 60) + (minute! * 60) + (second)!
    
    macEFITotalSeconds += totalInSeconds
}

func secondsToHoursMinutesSeconds (seconds : Int) -> (String) {
    return "\((seconds / 3600)):\((seconds % 3600) / 60):\((seconds % 3600) % 60)"
}

print("MacEFI Total Cycle Time:\n\(secondsToHoursMinutesSeconds(seconds: macEFITotalSeconds))")
print("==================================================================================")

var memory_tests_3x: Int = 0
var last_memory_test_line: Int = 0

for (i, line) in parsedArray.enumerated() {
    if line[1].contains("memory_tests") {
        var time = line[4]
        var timeSplit = time.components(separatedBy: ":")
        
        var hour = Int(timeSplit[0])
        var minute = Int(timeSplit[1])
        var second = Int(timeSplit[2])
        
        var totalInSeconds = (hour! * 60 * 60) + (minute! * 60) + (second)!
        
        memory_tests_3x += totalInSeconds
        last_memory_test_line = i
    }
}

print("memory_tests_3x Cycle Time: \n\(secondsToHoursMinutesSeconds(seconds: memory_tests_3x))")
print("memory_tests_1x Cycle Time: \n\(secondsToHoursMinutesSeconds(seconds: memory_tests_3x / 3))")
print("==================================================================================")

var test_2198 = parsedArray[last_memory_test_line + 1][4]
var test_2199 = parsedArray[last_memory_test_line + 2][4]
var test_2201 = parsedArray[last_memory_test_line + 3][4]

print("Test 2198 Cycle Time: \n\(test_2198)")
print("Test 2199 Cycle Time: \n\(test_2199)")
print("Test 2201 Cycle Time: \n\(test_2201)")

"""
"PASS","macefi/Memory 2198 Sequential Byte Block Test (MP/1",2018-08-01 01:49:23,2018-08-01 01:58:39,00:09:16
"PASS","macefi/Memory 2199 Walking Bit Flip Test (MP)/1",2018-08-01 01:58:39,2018-08-01 02:03:38,00:04:59
"PASS","macefi/Memory 2201 Walking Spread Bits Test (MP)/1",2018-08-01 02:03:38,2018-08-01 02:08:37,00:04:59
"""
