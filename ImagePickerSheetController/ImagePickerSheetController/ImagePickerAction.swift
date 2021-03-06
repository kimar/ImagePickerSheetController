//
//  ImagePickerAction.swift
//  ImagePickerSheet
//
//  Created by Laurin Brandner on 24/05/15.
//  Copyright (c) 2015 Laurin Brandner. All rights reserved.
//

import Foundation

@objc public enum ImagePickerActionStyle : Int {
    case Default
    case Cancel
}

public class ImagePickerAction : NSObject {
    
    public typealias Title = Int -> String
    public typealias Handler = (ImagePickerAction) -> ()
    public typealias SecondaryHandler = (ImagePickerAction, Int) -> ()
    
    /// The title of the action's button.
    public let title: String
    
    /// The title of the action's button when more than one image is selected.
    public let secondaryTitle: String
    
    /// The style of the action. This is used to call a cancel handler when dismissing the controller by tapping the background.
    public let style: ImagePickerActionStyle
    
    let handler: Handler
    let secondaryHandler: SecondaryHandler
    
    /// Initializes a new ImagePickerAction. The secondary title and handler are used when at least 1 image has been selected.
    /// Secondary title defaults to title if not specified. Use the closure to format a title according to the selection.
    /// Secondary handler defaults to handler if not specified
    public init(title: String, secondaryTitle: String!, style: ImagePickerActionStyle = .Default, handler: Handler, var secondaryHandler: SecondaryHandler! = nil) {
        if secondaryHandler == nil {
            secondaryHandler = { action, _ in
                handler(action)
            }
        }
        
        self.title = title
        self.secondaryTitle = secondaryTitle ?? title
        self.style = style
        self.handler = handler
        self.secondaryHandler = secondaryHandler
    }
    
    func handle(numberOfImages: Int = 0) {
        if numberOfImages > 0 {
            secondaryHandler(self, numberOfImages)
        }
        else {
            handler(self)
        }
    }
    
}

func ?? (left: ImagePickerAction.Title?, right: ImagePickerAction.Title) -> ImagePickerAction.Title {
    if let left = left {
        return left
    }
    
    return right
}
