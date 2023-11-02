//
//  NicknameViewModel.swift
//  SeSACRxThreads
//
//  Created by 홍수만 on 2023/11/03.
//

import Foundation
import RxSwift

class NicknameViewModel {
    
    let nickname = PublishSubject<String>()
    let nextButtonEnabled = BehaviorSubject(value: false)
    let buttonColor = BehaviorSubject(value: ButtonColor.red)
    
    let disposeBag = DisposeBag()
    
    init() {
        
        nickname
            .map { $0.count >= 2 && $0.count < 6}
            .subscribe(with: self) { owner, value in
                let color = value ? ButtonColor.blue : ButtonColor.red
                owner.buttonColor.onNext(color)
                
                owner.nextButtonEnabled.onNext(value)
            }
            .disposed(by: disposeBag)
    }
}
