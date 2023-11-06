//
//  BoxOfiiceViewModel.swift
//  SeSACRxThreads
//
//  Created by 홍수만 on 2023/11/06.
//

import Foundation
import RxSwift

class BoxOfiiceViewModel {
    
    var data: [DailyBoxOfficeList] = []
    lazy var items = BehaviorSubject(value: data)
    
    let disposeBag = DisposeBag()
    
    
    
}
