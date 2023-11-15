//
//  SignUpViewModel.swift
//  SeSACRxThreads
//
//  Created by 홍수만 on 2023/11/13.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpViewModel: ViewModelType {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let email: ControlProperty<String>
        let validationButtonClicked: ControlEvent<Void>
        let nextButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let validationButtonEnabled: Observable<Bool>
        let nextButtonEnabled: Observable<Bool>
//        let buttonColor: Observable<UIColor>
    }
    
    func transform(input: Input) -> Output {
        
        let validationButtonEnabled = input.email
            .map { $0.isValidEmail() }
        
//        var nextButtonEnabled = BehaviorRelay(value: false)
//        
//        input.validationButtonClicked
//            .throttle(.seconds(1), scheduler: MainScheduler.instance)
//            .withLatestFrom(input.email) { void, email in
//                return email
//            }
//            .flatMap {
//                APIManager.shared.emailValid(email: $0) { <#Int#> in
//                    <#code#>
//                }
//            }
            
        let nextButtonEnabled = input.validationButtonClicked
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.email) { void, email in
                return email
            }
            .flatMapLatest { email in
                return Observable.create { observer in
                    APIManager.shared.emailValid(email: email) { statusCode in
                        switch statusCode {
                        case 200:
                            observer.onNext(true)
                            observer.onCompleted()
                        case 409, 500:
                            observer.onNext(false)
                            observer.onCompleted()
                        default:
                            observer.onNext(false)
                            observer.onCompleted()
                        }
                    }
                    return Disposables.create()
                }
            }
        
        
        return Output(validationButtonEnabled: validationButtonEnabled, nextButtonEnabled: nextButtonEnabled)
    }
    
}
