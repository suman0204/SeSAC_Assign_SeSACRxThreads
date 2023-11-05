//
//  SearchViewModel.swift
//  SeSACRxThreads
//
//  Created by 홍수만 on 2023/11/03.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel {
    
    var data = ["A", "B", "C", "AB", "D", "ABC"]
    
    lazy var items = BehaviorSubject(value: data)
    
    let disposeBag = DisposeBag()

    init() {
        
        
    }
}
