//
//  SignInViewModel.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import Foundation
import RxSwift

class SignInViewModel {
    
    let email = BehaviorSubject(value: "")//PublishSubject<String>()
    let password = BehaviorSubject(value: "") //PublishSubject<String>()
    let textfieldButtonColor: BehaviorSubject<ColorType> = BehaviorSubject(value: .red)
    
    let validation: Observable<Bool>
    
    let disposeBag = DisposeBag()
    
    init() {
        
        validation = Observable.combineLatest(email, password, resultSelector: { email, password in
            return email.count > 8 && password.count > 6
        })
        
        validation
            .subscribe(with: self) { owner, value in
                let color = value ? ColorType.blue : ColorType.red
                owner.textfieldButtonColor.onNext(color)
            }
            .disposed(by: disposeBag)
        
    }
}
