//
//  Aria2cLogViewController.swift
//  Aria2D
//
//  Created by xjbeta on 2019/3/23.
//  Copyright © 2019 xjbeta. All rights reserved.
//

import Cocoa

class Aria2cLogViewController: NSViewController {

    @objc let logPath = Aria2.shared.aria2c.logPath
    
    @IBAction func showLogFile(_ sender: Any) {
        NSWorkspace.shared.activateFileViewerSelecting([URL(fileURLWithPath: logPath)])
    }
    
    @IBAction func closeWindow(_ sender: Any) {
        self.view.window?.close()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
