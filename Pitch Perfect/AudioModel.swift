//
//  AudioModel.swift
//  Pitch Perfect
//
//  Created by howard.lee on 7/22/15.
//  Copyright (c) 2015 howard.lee. All rights reserved.
//

import Foundation

/// A model that represent an audio file
class AudioModel: NSObject {
    
    var filePathUrl: NSURL!
    var title: String!

    init(filePathUrl: NSURL!, title: String!) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}
