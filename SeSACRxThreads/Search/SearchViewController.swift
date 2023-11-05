//
//  SearchViewController.swift
//  SeSACRxThreads
//
//  Created by 홍수만 on 2023/11/03.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SampleViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        title = "\(Int.random(in: 1...100))"
    }
}

class SearchViewController: UIViewController {
     
    private let tableView: UITableView = {
       let view = UITableView()
        view.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        view.backgroundColor = .white
        view.rowHeight = 80
        view.separatorStyle = .none
       return view
     }()
    
    let searchBar = UISearchBar()
    
//    var data = ["A", "B", "C", "AB", "D", "ABC"]
//    
//    lazy var items = BehaviorSubject(value: data)
//    
    let disposeBag = DisposeBag()
  
    let viewModel: SearchViewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configure()
        
        setSearchController()
        
        bind()
        
    }
    
    func bind() {
        viewModel.items
            .bind(to: tableView.rx.items(cellIdentifier: SearchTableViewCell.identifier, cellType: SearchTableViewCell.self)) {
                (row, element, cell) in
                cell.appNameLabel.text = element
                cell.appIconImageView.backgroundColor = .green
                
                cell.downloadButton.rx.tap
                    .subscribe(with: self) { owner, _ in
                        print("downloadButton Tapped")
                        owner.navigationController?.pushViewController(SampleViewController(), animated: true)
                    }
                    .disposed(by: cell.disposeBag)
                
            }
            .disposed(by: disposeBag)
        
        
//        tableView.rx.itemSelected
//            .subscribe(with: self) { owner, indexPath in
//                print(indexPath)
//            }
//            .disposed(by: disposeBag)
//        
//        tableView.rx.modelSelected(String.self)
//            .subscribe(with: self) { owner, value in
//                print(value)
//            }
//            .disposed(by: disposeBag)
        
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(String.self))
            .map { "셀 선택 \($0) \($1)" }
            .subscribe(with: self) { owner, value in
                print(value)
            }
            .disposed(by: disposeBag)
        
        //searchBar
        searchBar.rx.searchButtonClicked    //검색 버튼 클릭 시, 입력된 text가 data배열에 첫 번째 위치에 추가되고 추가된 data 배열이 item observable로 emit
            .withLatestFrom(searchBar.rx.text.orEmpty) { Void, text in
                return text
            }
            .subscribe(with: self) { owner, value in
                print(value)
                owner.viewModel.data.insert(value, at: 0)
                owner.viewModel.items.onNext(owner.viewModel.data)
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                print(value)
                
                let result = value == "" ? owner.viewModel.data : owner.viewModel.data.filter { $0.contains(value) }
                owner.viewModel.items.onNext(result)
                
                print("==실시간 검색== \(value)")
            }
            .disposed(by: disposeBag)
        
    }
    
    private func setSearchController() {
        view.addSubview(searchBar)
        self.navigationItem.titleView = searchBar
    }

    
    private func configure() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

    }
}
