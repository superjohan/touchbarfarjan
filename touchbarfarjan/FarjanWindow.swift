//
//  FarjanWindows.swift
//  touchbarfarjan
//
//  Created by Johan Halin on 16/09/2018.
//  Copyright © 2018 Aero Deko. All rights reserved.
//

import Cocoa

class FarjanWindow: NSWindow, NSTouchBarDelegate {
    let farjanIdentifier = NSTouchBarItem.Identifier("faerjanview")
    
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = "faerjan"
        
        touchBar.defaultItemIdentifiers = [self.farjanIdentifier]

        return touchBar
    }

    // MARK: - NSTouchBarDelegate
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        if identifier == self.farjanIdentifier {
            let item = NSCustomTouchBarItem(identifier: identifier)
            let view = TouchBarFarjanView(frame: NSRect(x: 0, y: 0, width: 1, height: 1))
            item.view = view
            
            view.setup()
            
            return item
        } else {
            return nil
        }
    }
}
