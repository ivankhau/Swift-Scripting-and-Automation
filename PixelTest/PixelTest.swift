#!/usr/bin/swift

// Invocation: PixelTest.swift <red>(optional) <green>(optional) <blue>(optional) <red2>(optional) <green2>(optional) <blue2>(optional)
/*
 Factory Defective Pixel Test:
 Launches NSWindow with solid colored pattern for 5 seconds. (You may need programatically draw addistional shapes/patterns depending on use case.)
 Followed by a solid black pattern for 5 seconds. CM to check display for defective pixels.
 Decision window then pops up and CM inputs "Yes" if there is a pixel defect (exit: 1), and "No" if there is no defect (exit: 0). Hitting return returns "No" (exit: 0).
*/

import Cocoa

var red: Int = 1
var green: Int = 255
var blue: Int = 1

var red2: Int = 255
var green2: Int = 255
var blue2: Int = 255

let screenFrame = NSScreen.main?.frame
let screenHeight = screenFrame!.height
let screenWidth = screenFrame!.width

for (i, argument) in CommandLine.arguments.enumerated() {
    switch i {
        case 1:
            red = Int(argument) ?? 1
        case 2:
            green = Int(argument) ?? 1
        case 3:
            blue = Int(argument) ?? 1
        case 4:
            red2 = Int(argument) ?? 1
        case 5:
            green2 = Int(argument) ?? 1
        case 6:
            blue2 = Int(argument) ?? 1
        default:
            continue
    }
}

// Hide Menu Bar and Dock
NSMenu.setMenuBarVisible(false)

let app = NSApplication.shared
app.setActivationPolicy(.regular)

// Init pattern window
let window = NSWindow.init(
    contentRect: NSRect(x: 0, y: 0, width: screenWidth, height: screenHeight),
    styleMask:   [
        NSWindow.StyleMask.borderless
    ],
    backing:     NSWindow.BackingStoreType.buffered,
    defer:       false
)
window.makeKeyAndOrderFront(nil)
window.backgroundColor = NSColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1)
window.titleVisibility = .hidden
window.titlebarAppearsTransparent = true
window.acceptsMouseMovedEvents = false
window.collectionBehavior = NSWindow.CollectionBehavior.fullScreenPrimary
window.setFrame(screenFrame!, display: false)
window.toggleFullScreen(nil)

// MARK: Draw additional shapes/patterns here if needed.

func decisionWindow(question: String, text: String) -> Bool {
    let alert = NSAlert()
    alert.messageText = question
    alert.informativeText = text
    alert.alertStyle = .critical
    alert.addButton(withTitle: "No")
    alert.addButton(withTitle: "Yes")

    return alert.runModal() == .alertSecondButtonReturn
}

DispatchQueue.global(qos: .background).async {
    // Sleep for 5 seconds
    usleep(5000000)
    
    DispatchQueue.main.async {
        // Change background color and remove shapes
        window.backgroundColor = NSColor(red: CGFloat(red2), green: CGFloat(green2), blue: CGFloat(blue2), alpha: 1)
        window.contentView?.subviews.removeAll()
    }
    
    // Sleep for 5 seconds
    usleep(5000000)
    
    DispatchQueue.main.async {
        let answer = decisionWindow(question: "Do you see any defective pixels?", text: "有没有缺陷")
        print(answer)
        //app.terminate(nil)
        if answer {
            print("Exit Code: 1")
            print("Display has defects, need FA")
            exit(1)
        }
        // No screen defects
        print("Exit Code: 0")
        print("No defects, yay!")
        exit(0)
    }
}

app.run()

