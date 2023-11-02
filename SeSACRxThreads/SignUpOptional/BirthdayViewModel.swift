//
//  BirthdayViewModel.swift
//  SeSACRxThreads
//
//  Created by 홍수만 on 2023/11/02.
//

import Foundation
import RxSwift

class BirthdayViewModel {
    
    let birthday = BehaviorSubject(value: Date.now)
    let year = BehaviorSubject(value: 2020)
    let month = BehaviorSubject(value: 10)
    let day = BehaviorSubject(value: 12)
    
    let buttonColor: BehaviorSubject<ButtonColor> = BehaviorSubject(value: .red)
//    let buttonColor = BehaviorSubject(value: UIColor.red)
    let buttonEnabled = BehaviorSubject(value: false)
    
    let disposeBag = DisposeBag()
    
    init() {
        
        birthday
            .subscribe(with: self) { owner, date in
                let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
                
                guard let year = component.year, let month = component.month, let day = component.day else {return}
                
                owner.year.onNext(year)
                owner.month.onNext(month)
                owner.day.onNext(day)
                
            }
            .disposed(by: disposeBag)
        
        birthday
            .map{ date in
                let ageComponent = Calendar.current.dateComponents([.year], from: date, to: Date())
                return ageComponent.year ?? 0 >= 17
            }
            .subscribe(with: self) { owner, value in
                let color = value ? ButtonColor.blue : ButtonColor.red
                owner.buttonColor.onNext(color)
                owner.buttonEnabled.onNext(value)
            }
            .disposed(by: disposeBag)
    }
    
}
