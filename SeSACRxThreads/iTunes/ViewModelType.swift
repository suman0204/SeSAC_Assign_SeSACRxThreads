//
//  ViewModelType.swift
//  SeSACRxThreads
//
//  Created by 홍수만 on 2023/11/09.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
