//
//  Kain.swift
//  kainmanager
//
//  Created by Buyaka on 1/22/15.
//  Copyright (c) 2015 demo. All rights reserved.
//

import Foundation

class Kain : DynasObject {
    var name : String = String()
    var position : String = String()
    
    override init() {
        super.init()
        self.entity_name = "kain"
    }
    
}
