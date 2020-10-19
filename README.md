# Swift-Scripting-and-Automation
Examples of Swift automation and scripting I've done in the workplace. Purpose of this repo is to display unique uses of Swift for scripting and automation purposes. 

- Pixel Test: Example of hardware testing through Swift scripting
- Lab Automator: Swift app used to automate hardware testing lab. 
- Cycle Time Wizard: Swift App and Scripts used for unit log analysis.
- tgraphAnnotator: Swift App and Scripts used for unit log analysis.

## Pixel Test
Swift version of a python factory display test. Scripts draws a NSWindow with a colored background for 5 seconds, followed by a NSWindow with a solid black background for 5 seconds. During these 5 seconds the factory operator checks to see if there are any defective pixels. An NSAlert then pops up asking the factory operator if there were any defective pixels.

```bash
PixelTest.swift <red>(optional) <green>(optional) <blue>(optional) <red2>(optional) <green2>(optional) <blue2>(optional)
```

![Screenshot](https://github.com/ivankhau/Swift-Scripting-and-Automation/blob/main/PixelTest/Screenshot.png?raw=true)

## Lab Automator
MacOS Swift app used to automate hardware testing lab. Features include:
- Restore devices with software bundle
- Install software patches onto devices
- Kick off hardware testing sequence
- File bug reports
- Status tracking

![Screenshot](https://github.com/ivankhau/Swift-Scripting-and-Automation/blob/main/LabAutomator/Interface.png?raw=true)

## Cycle Time Wizard
Downloads unit test logs from bug reporting API, parses unit test logs, and does test time analysis. Allows input from local test logs as well.

## tgraphAnnotator
Downloads unit test logs from bug reporting API, does test time anaylsis, and annotates T-Graph.
