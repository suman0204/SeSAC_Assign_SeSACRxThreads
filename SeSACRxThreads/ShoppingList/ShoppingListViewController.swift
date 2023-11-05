//
//  ShoppingListViewController.swift
//  SeSACRxThreads
//
//  Created by 홍수만 on 2023/11/05.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ShoppingListViewController: UIViewController {
    
    private let shoppingListTableView = {
        let view = UITableView()
        view.register(ShoppingListTableViewCell.self, forCellReuseIdentifier: ShoppingListTableViewCell.identifier)
        view.backgroundColor = .white
        view.rowHeight = 60
        return view
    }()
    
    private let searchBar = {
        let view = UISearchBar()
        return view
    }()
    
    private let appendview = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 10
        view.layer.cornerCurve = .continuous
        return view
    }()
    
    private let appendTextField = {
        let view = UITextField()
        view.placeholder = "무엇을 구매하실 건가요?"
        return view
    }()
    
    private let appendButton = {
        let view = UIButton()
        view.setTitle("추가", for: .normal)
        view.setTitleColor(.black, for: .normal)
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 10
        view.layer.cornerCurve = .continuous
        return view
    }()
    
    let viewModel = ShoppingViewModel()
    
    let disposBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureView()
        setConstraints()
        
        bind()
    }
    
    func bind() {
        //tableView
        viewModel.observableItems
            .bind(to: shoppingListTableView.rx.items(cellIdentifier: ShoppingListTableViewCell.identifier, cellType: ShoppingListTableViewCell.self)) { (row, element, cell) in
                cell.contentLabel.text = element.title
                cell.checkButton.setImage(element.checked ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "checkmark.square") , for: .normal)
                cell.likeButton.setImage(element.liked ? UIImage(systemName: "star.fill") : UIImage(systemName: "star") , for: .normal)
                
                cell.checkButton.rx.tap
                    .subscribe(with: self) { owner, _ in
                        print("checkButton")
                        element.checked.toggle()
                        owner.shoppingListTableView.reloadData() // ??....
                        
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.likeButton.rx.tap
                    .subscribe(with: self) { owner, _ in
                        print("likeButton")
                        element.liked.toggle()
                        owner.shoppingListTableView.reloadData()
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposBag)
        

        
        
        //appendButton
        appendButton.rx.tap
            .withLatestFrom(appendTextField.rx.text.orEmpty) { void, text in
                return text
            }
            .subscribe(with: self) { owner, value in
                print(value)
                owner.viewModel.items.insert(ShoppingItem(title: value), at: 0)
                owner.viewModel.observableItems.onNext(owner.viewModel.items)
            }
            .disposed(by: disposBag)
//        appendTextField.rx.
//            .withLatestFrom(searchBar.rx.text.orEmpty) { Void, text in
//                return text
//            }
//            .subscribe(with: self) { owner, value in
//                print(value)
//                owner.viewModel.items.insert(ShoppingItem(title: value), at: 0)
//                owner.viewModel.observableItems.onNext(owner.viewModel.items)
//                print(owner.viewModel.observableItems)
//            }
//            .disposed(by: disposBag)
        
        //searchBar
        searchBar.rx.text.orEmpty
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                
                let result = value == "" ? owner.viewModel.items : owner.viewModel.items.filter({
                    $0.title.contains(value)
                })
                
                owner.viewModel.observableItems.onNext(result)
                
                print("1초 후 검색")
            }
            .disposed(by: disposBag)
        
        searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.text.orEmpty) { void, text in
                return text
            }
            .subscribe(with: self) { owner, value in
                let result = value == "" ? owner.viewModel.items : owner.viewModel.items.filter { $0.title == value }
                owner.viewModel.observableItems.onNext(result)
                
                print("searchButton 검색")
            }
            .disposed(by: disposBag)
    }
    
    private func configureView() {
        [appendTextField, appendButton].forEach {
            appendview.addSubview($0)
        }
        
        [shoppingListTableView, searchBar, appendview].forEach {
            view.addSubview($0)
        }
        
        navigationItem.titleView = searchBar
    }
    
    private func setConstraints() {
        
        appendview.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.height.equalTo(50)
            
        }
        
        appendTextField.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.width.equalToSuperview().multipliedBy(0.7)
        }
        
        appendButton.snp.makeConstraints { make in
            make.leading.equalTo(appendTextField.snp.trailing).offset(10)
            make.verticalEdges.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        shoppingListTableView.snp.makeConstraints { make in
            make.top.equalTo(appendview.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    
}
