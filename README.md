# Swift-Scripting-and-Automation
Purpose of this repo is to display unique uses of Swift for scripting and automation purposes. These are old deprecated examples where I chose Swift as a scripting and automation language over Python. 

- Pixel Test: Example of hardware testing through Swift scripting.
- Lab Automator: Swift app used to automate hardware testing lab. 
- Cycle Time Wizard: Swift App and Scripts used for unit test log analysis.
- tgraphAnnotator: Swift App and Scripts used for unit test log analysis.

*Note source code for the UI apps are ommitted due to proprietary reasons. I did include some POC Swift scripts I used for the proposals before the full UI App inception.*

## Pixel Test
Swift version of a python factory display test. Scripts draws a NSWindow with a colored background for 5 seconds, followed by a NSWindow with a solid black background for 5 seconds. During these 5 seconds the factory operator checks to see if there are any defective pixels. An NSAlert then pops up asking the factory operator if there were any defective pixels.

```bash
PixelTest.swift <red>(optional) <green>(optional) <blue>(optional) <red2>(optional) <green2>(optional) <blue2>(optional)
```

![Screenshot](https://github.com/ivankhau/Swift-Scripting-and-Automation/blob/main/PixelTest/Screenshot.png?raw=true)

## Lab Automator
MacOS Swift app used to automate hardware testing lab. Features include:
- Restore multiple devices with specified software bundle
- Install software patches onto specified devices
- Kick off hardware testing sequence on devices
- File bug reports
- Status tracking table (Table on the top right)
- Status tracking through Website

Before technicians were restoring test units one-by-one, patching these units one-by-one, and kicking off test sequences one-by-one. This app enabled a technicians to operate a whole lab by themselves.

![Screenshot](https://github.com/ivankhau/Swift-Scripting-and-Automation/blob/main/LabAutomator/Interface.png?raw=true)

## Cycle Time Wizard
Downloads unit test logs from bug reporting API, and does test time analysis. Allows input from local test logs as well.

### Included are 2 Proof of Concept parsing scripts:
- parseMemoryTests.swift: Parses cycle time from Memory tests
- parseSystemConfigs.swift: Parses device hardware configs.

These Swift scripts we're used as a POC before developing the full UI app. 

### App Screenshot:
This is a screenshot of the App interface. The app allows you to drag in local test logs for analysis or to input multiple bug report ID's to download logs and then perform cycle time analysis.

![Screenshot](https://github.com/ivankhau/Swift-Scripting-and-Automation/blob/main/CycleTimeWizard/Interface.png?raw=true)

### Output:
The app then outputs 2 CSV files with test times as seen below.

![Cycle Time CSV Output](https://github.com/ivankhau/Swift-Scripting-and-Automation/blob/main/CycleTimeWizard/CycleTime.png?raw=true)
![EFI CSV Output](https://github.com/ivankhau/Swift-Scripting-and-Automation/blob/main/CycleTimeWizard/EFITime.png?raw=true)


## tgraphAnnotator
Downloads unit test logs from bug reporting API, does test time analysis, and annotates T-Graph.

### Included is a POC parsing script
- annotate.swift

This Swift script was used as a POC before developing the full UI App.

### App Screenshot:

Screenshot before analysis

![Screenshot](https://github.com/ivankhau/Swift-Scripting-and-Automation/blob/main/tgraphAnnotator/Interface.png?raw=true)

Screenshot after analysis

![Screenshot](https://github.com/ivankhau/Swift-Scripting-and-Automation/blob/main/tgraphAnnotator/InterfaceParsed.png?raw=true)

Screenshot of annotated t-graph. Annotations are seen on the top. These annotations saved hours of analysis time.

![Screenshot](https://github.com/ivankhau/Swift-Scripting-and-Automation/blob/main/tgraphAnnotator/AnnotatedGraph.png?raw=true)

