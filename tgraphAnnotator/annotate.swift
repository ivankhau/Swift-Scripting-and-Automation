#!/usr/bin/swift

//
//  annotate.swift
//  iWatchToolScript
//
//  Created by Ivan Khau on 9/6/18.
//  Copyright © 2018 Ivan Khau. All rights reserved.
//


// Invocation: annotate.swift <.viz> <earthbound.txt> <tgraph.csv>


import Foundation

///// INPUTS /////

var testLevel: Int = 3
var vizPath: String = "/Users/ivankhau/Desktop/D92X2014KW50/AppleInternal/Diags/Earthbound/Worlds/N141b/fatp.viz.txt"
var earthboundPath: String = "/Users/ivankhau/Desktop/D92X2014KW50/Earthbound-fatp-2018-08-16_13-46-55/Earthbound.txt"
var tgraph:String = "/Users/ivankhau/Desktop/D92X2014KW50/Earthbound-fatp-2018-08-16_13-46-55/EarthboundLogs/private/var/logs/BurnIn/tgraph.csv"

if CommandLine.arguments.count == 3 {
    vizPath = CommandLine.arguments[1]
    earthboundPath = CommandLine.arguments[2]
}
if CommandLine.arguments.count == 4 {
    tgraph = CommandLine.arguments[3]
}

//var vizPath: String = "/Users/ivankhau/Desktop/D92X800FKYDK/AppleInternal/Diags/Earthbound/Worlds/N144s/fatp.viz.txt"
//var earthboundPath: String = "/Users/ivankhau/Desktop/D92X800FKYDK/2018-09-06_08-19-56/MobileMediaFactoryLogs/LogCollector/Earthbound-fatp-2018-09-05_06-22-18/Earthbound.txt"

     // ===================== //

///// functions /////

func earthboundTimeStampToDate(_ str:String) -> Date? {
    let outFormat = DateFormatter()
    outFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
    if let dateo = outFormat.date(from: str) {
        return dateo
        print(dateo)
    } else {
        return nil
    }
}

extension Date {
    func offsetFrom(date : Date) -> String {
        
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: date, to: self);
        
        let seconds = "\(difference.second ?? 0)s"
        let minutes = "\(difference.minute ?? 0)m" + " " + seconds
        let hours = "\(difference.hour ?? 0)h" + " " + minutes
        let days = "\(difference.day ?? 0)d" + " " + hours
        
        if let day = difference.day, day          > 0 { return days }
        if let hour = difference.hour, hour       > 0 { return hours }
        if let minute = difference.minute, minute > 0 { return minutes }
        if let second = difference.second, second > 0 { return seconds }
        return ""
    }
}
////////////////////////

var tests: [String] = []
var testsAndTestTimes: [[Any]] = []

var vizContents = try? String(contentsOfFile: vizPath, encoding: String.Encoding.utf8)
var vizSplit = vizContents?.components(separatedBy: "\n")

///////////////////////////////////////
// get tests per selected levelLevel //
///////////////////////////////////////
var leftOffset = ""
for i in 1...testLevel {
    leftOffset = "\(leftOffset). "
}

print("========================================")
print("Selected Offset:")
print(leftOffset)
print("========================================")

var offsetViz: Int = 0
for line in vizSplit! {
    if line.contains("=====================================") {
        offsetViz += 1
    }
    if offsetViz == 2 {
        break
    }
    var lineSplit = line.components(separatedBy: leftOffset)
    guard lineSplit.count > 0 else { continue }
    guard lineSplit[0] == "" else {
        continue
    }
    guard lineSplit.count > 1 else { continue }
    guard lineSplit[1] != "" else {
        continue
    }
    guard lineSplit[1].count > 0 else { continue }
    guard lineSplit[1].first != "." && lineSplit[1].first != " " else { continue }
    
    var testName = lineSplit[1]
    if testName.last == " " {
        testName.removeLast()
    }
    if testName.contains(" [x") {
        var testNameSplit = testName.components(separatedBy: " [x")
        tests.append(testNameSplit[0])
        continue
    }
    tests.append(testName)
}

print("========================================")
print("Found tests:")
print(tests)
print("========================================")

////////////////////////////////////////
// get test times from earthbound.txt //
////////////////////////////////////////

var earthboundContents = try? String(contentsOfFile: earthboundPath, encoding: String.Encoding.utf8)
var earthboundSplit = earthboundContents?.components(separatedBy: "\n")
var earthboundSplitFiltered: [String] = []
for line in earthboundSplit! {
    if line.contains(" <Earthbound> [") {
        earthboundSplitFiltered.append(line)
    }
}

print("========================================")
print("Tests and test times:")
print(tests)
print("========================================")

var offset:Int = 0
for (i, test) in tests.enumerated() {
    
    var start:String = ""
    var end:String = ""
    
    for n in offset..<(earthboundSplitFiltered.count) {
        if earthboundSplitFiltered[n].contains(test) {
            if start == "" {
                start = earthboundSplitFiltered[n]
            }
            end = earthboundSplitFiltered[n]
            
        }
        
        /*if start != "" && !earthboundSplitFiltered[n].contains(test) {
            offset = n
            break
        }*/
        
        if i != (tests.count - 1) {
            if earthboundSplitFiltered[n].contains(tests[i + 1]) {
                offset = n
                break
            }
            
        }
        
        
    }

    var startAsDate = earthboundTimeStampToDate(start.components(separatedBy: " <Earthbound> ")[0])
    var endAsDate = earthboundTimeStampToDate(end.components(separatedBy: " <Earthbound> ")[0])
    
    guard startAsDate != nil && endAsDate != nil else { continue }
    
    var timeDelta = endAsDate!.offsetFrom(date: startAsDate!)
    if timeDelta == "" {
        timeDelta = "0s"
    }
    print([test, timeDelta, startAsDate!, endAsDate!])
    testsAndTestTimes.append([test, timeDelta, startAsDate!, endAsDate!])
}










