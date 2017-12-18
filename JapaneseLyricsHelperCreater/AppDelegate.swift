//
//  AppDelegate.swift
//  JapaneseLyricsHelperCreater
//
//  Created by  on Dec/17/2017.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var filePath = ""
    var rowNum:Int!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @IBAction func openDocument(_ sender: Any) {
        let openDialog = NSOpenPanel()
        openDialog.canChooseFiles = true
        openDialog.canChooseDirectories = false
        openDialog.allowsMultipleSelection = false
        openDialog.allowsOtherFileTypes = false
        openDialog.allowedFileTypes = ["plist"]
        openDialog.runModal()
        if let filename = openDialog.urls.first {
            filePath = filename.path
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "plistName"), object: nil)
        }
    }
    

}

