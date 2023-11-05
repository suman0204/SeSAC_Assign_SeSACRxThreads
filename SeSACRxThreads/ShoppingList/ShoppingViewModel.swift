//
//  ShoppingViewModel.swift
//  SeSACRxThreads
//
//  Created by 홍수만 on 2023/11/05.
//

import Foundation
import RxSwift

class ShoppingViewModel {
    
    var items: [ShoppingItem] = [ShoppingItem(title: "dfsf"), ShoppingItem(title: "안녕")]
    
    lazy var observableItems = BehaviorSubject(value: items)
    
    
    
}
