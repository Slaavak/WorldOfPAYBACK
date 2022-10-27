//
//  DispatchQueueExtension.swift
//  WorldOfPAYBACK
//
//  Created by Slava Korolevich on 27.10.22.
//

import Foundation

public extension DispatchQueue {

    static func performOnMainThread(_ action: VoidBlock) {
        if Thread.isMainThread {
            action()
        } else {
            DispatchQueue.main.sync {
                action()
            }
        }
    }
}
