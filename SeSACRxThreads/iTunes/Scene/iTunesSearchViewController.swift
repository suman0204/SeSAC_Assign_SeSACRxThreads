//
//  iTunesSearchViewController.swift
//  SeSACRxThreads
//
//  Created by 홍수만 on 2023/11/06.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class iTunesSearchViewController: UIViewController {
    
    let searchResultsTableView = {
        let view = UITableView()
        view.register(iTunesSearchTableViewCell.self, forCellReuseIdentifier: iTunesSearchTableViewCell.identifier)
        view.separatorStyle = .none
        view.rowHeight = 300
        view.backgroundColor = .blue
        return view
    }()
    
    var data: [AppInfo] = []
    
    lazy var items = BehaviorSubject(value: data)
    
    let disposeBag = DisposeBag()
    
    let viewModel = iTunesSearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        setConstraints()
        makeSearchBar()
        
        bind()
    }
    
    func bind() {
        let searchBar = navigationItem.searchController!.searchBar
        
        let input = iTunesSearchViewModel.Input(searchButtonClicked: searchBar.rx.searchButtonClicked, searchText: searchBar.rx.text.orEmpty)
        
        let output = viewModel.transform(input: input)
        
//        searchBar.rx.searchButtonClicked // input
//            .throttle(.seconds(1), scheduler: MainScheduler.instance)
//            .withLatestFrom(searchBar.rx.text.orEmpty)/*input*/ { void, text in
//                print(text)
//                return text
//            }
//            .flatMap { query in
//                iTunesAPIManager.fetchData(query: query)
//            }
//            .subscribe(with: self) { owner, response in
//                print(response)
//                owner.items.onNext(response.results) /*output*/
//            }
//            .disposed(by: disposeBag)
        
        output.items
//        items
            .bind(to: searchResultsTableView.rx.items(cellIdentifier: iTunesSearchTableViewCell.identifier, cellType: iTunesSearchTableViewCell.self)) { (row, element, cell) in
                
                cell.appIcon.kf.setImage(with: URL(string: element.artworkUrl512))
                cell.appTitleLabel.text = element.trackName
                cell.categoryLabel.text = element.genres[0]
                cell.rateLabel.text = "\(element.averageUserRating)"
                cell.sellerNameLabel.text = element.sellerName
                cell.firstScreenshotImage.kf.setImage(with: URL(string: element.screenshotUrls[0]))
                cell.secondScreenshotImage.kf.setImage(with: URL(string: element.screenshotUrls[1]))
                cell.thirdScreenshotImage.kf.setImage(with: URL(string: element.screenshotUrls[2]))

            }
            .disposed(by: disposeBag)
        
        
    }
    
    private func configureView() {
        view.backgroundColor = .white
        
        view.addSubview(searchResultsTableView)
    }
    
    private func setConstraints() {
        searchResultsTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func makeSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "게임, 앱, 스토리 등"
        
        navigationItem.searchController = searchController
        navigationItem.searchController?.hidesNavigationBarDuringPresentation = true
        
        navigationItem.title = "검색"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
