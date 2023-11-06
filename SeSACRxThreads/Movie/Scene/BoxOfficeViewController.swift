//
//  BoxOfficeViewController.swift
//  SeSACRxThreads
//
//  Created by 홍수만 on 2023/11/06.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BoxOfficeViewController: UIViewController {
    
//    var data: [DailyBoxOfficeList] = []
//    lazy var items = BehaviorSubject(value: data)
    
    let viewModel = BoxOfiiceViewModel()
    
    let disposeBag = DisposeBag()
    
    let boxOfficeTableView = {
        let view = UITableView()
        view.register(BoxOfficeTableViewCell.self, forCellReuseIdentifier: BoxOfficeTableViewCell.identifier)
        view.backgroundColor = .white
        view.rowHeight = 100
        return view
    }()
    
    let searchBar = {
        let view = UISearchBar()
        view.placeholder = "검색할 날짜를 입력해주세요 ex)20230101"
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        setConstraints()
        
        bind()
        
    }
    
    func bind() {
        
        searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.text.orEmpty) { void, text in
                return text
            }
            .subscribe(with: self) { owner, text in
                
                let request = BoxOfficeAPI.fetchData(date: text)
                    .asDriver(onErrorJustReturn: BoxOfficeResult(boxofficeType: "", showRange: "", dailyBoxOfficeList: []))
                
                request
                    .drive(with: self) { owner, result in
                        owner.viewModel.items.onNext(result.dailyBoxOfficeList)
                    }
                    .disposed(by: owner.disposeBag)
                
            }
            .disposed(by: disposeBag)
        
        
//        let request = BoxOfficeAPI.fetchData(date: "20231101")
//            .asDriver(onErrorJustReturn: BoxOfficeResult(boxofficeType: "", showRange: "", dailyBoxOfficeList: []))
//        
//        request
//            .drive(with: self) { owner, result in
//                owner.viewModel.items.onNext(result.dailyBoxOfficeList)
//                print(result)
//            }
//            .disposed(by: disposeBag)
        
        viewModel.items
            .bind(to: boxOfficeTableView.rx.items(cellIdentifier: BoxOfficeTableViewCell.identifier, cellType: BoxOfficeTableViewCell.self)) { row, element, cell in
                
                cell.rankLabel.text = element.rank
                cell.openDateLabel.text = element.openDt
                cell.titleLabel.text = element.movieNm
            }
            .disposed(by: disposeBag)
    }
    
    private func configureView() {
        
        view.backgroundColor = .white
        
        [boxOfficeTableView, searchBar].forEach {
            view.addSubview($0)
        }
        
        navigationItem.titleView = searchBar
    }
    
    private func setConstraints() {
        boxOfficeTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}
