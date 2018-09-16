//
//  AppDelegate.swift
//  touchbarfarjan
//
//  Created by Johan Halin on 16/09/2018.
//  Copyright © 2018 Aero Deko. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var window: NSWindow!

    let demo = TouchBarFarjan()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.demo.start()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

