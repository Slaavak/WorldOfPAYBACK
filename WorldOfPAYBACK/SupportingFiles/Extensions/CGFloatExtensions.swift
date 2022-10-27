//
//  CGFloatExtensions.swift
//  WorldOfPAYBACK
//
//  Created by Slava Korolevich on 27.10.22.
//

import Foundation

extension CGFloat {
    static var random: CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
