//
//  Entry.swift
//  newnewCoreDataImages
//
//  Created by Cesar on 12/12/16.
//  Copyright © 2016 Cesar. All rights reserved.
//

import Foundation


class Entry : NSObject{
    var sentence : String
    
    init(sentence : String) {
        self.sentence = sentence
    }
    
    override init (){
        self.sentence = "woops"
    }
    
}
