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

class iTunesSearchViewController: UIViewController {
    
    let searchResultsTableView = {
        let view = UITableView()
        view.register(iTunesSearchTableViewCell.self, forCellReuseIdentifier: iTunesSearchTableViewCell.identifier)
        view.separatorStyle = .none
        view.rowHeight = 200
        view.backgroundColor = .blue
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        setConstraints()
        makeSearchBar()
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
