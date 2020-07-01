//
//  Constant.swift
//  SimpleToDo
//
//  Created by Pavel Parshin on 01.07.2020.
//  Copyright © 2020 Pavel Parshin. All rights reserved.
//

import UIKit

class Constant {
    static let shared = Constant()
    private init() {}
    
    let mainColor = UIColor(red: 68/255,
                             green: 178/255,
                             blue: 233/255,
                             alpha: 210/255)
    
    let editColor = UIColor(red: 66/255,
                            green: 233/255,
                            blue: 163/255,
                            alpha: 1)
    
    let deleteColor = UIColor(red: 233/255,
                             green: 82/255,
                             blue: 68/255,
                             alpha: 194/255)
    
}
