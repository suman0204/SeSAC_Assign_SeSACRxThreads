//
//  ShoppingItem.swift
//  SeSACRxThreads
//
//  Created by 홍수만 on 2023/11/06.
//

import Foundation

class ShoppingItem {
    var checked: Bool = false
    var title: String
    var liked: Bool = false
    
    init(title: String) {
        self.title = title
    }
}
