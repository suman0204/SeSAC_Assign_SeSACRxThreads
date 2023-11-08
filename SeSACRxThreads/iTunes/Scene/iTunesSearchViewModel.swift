//
//  iTunesSearchViewModel.swift
//  SeSACRxThreads
//
//  Created by 홍수만 on 2023/11/08.
//

import Foundation
import RxSwift
import RxCocoa

class iTunesSearchViewModel: ViewModelType {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let searchButtonClicked: ControlEvent<Void>
        let searchText: ControlProperty<String>
    }
    
    struct Output {
        let items: BehaviorSubject<[AppInfo]>
    }
    
    func transform(input: Input) -> Output {
        
        let items: BehaviorSubject<[AppInfo]> = BehaviorSubject(value: [])  // BehaviorSubject 타입으로 해서 onNext로 전달하면 값이 새로 덮어 씌워지는데 BehaviorRelay타입으로 해서 accept로 전달하면 뒤에 append된다?..
        
        input.searchButtonClicked
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText) { void, text in
                return text
            }
            .flatMap { query in
                iTunesAPIManager.fetchData(query: query)
            }
            .subscribe(with: self) { owner, result in
                items.onNext(result.results)
            }
            .disposed(by: disposeBag)
        
        return Output(items: items)
    }
    
}
