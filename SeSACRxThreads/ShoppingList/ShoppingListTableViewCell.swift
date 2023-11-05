//
//  ShoppingListTableViewCell.swift
//  SeSACRxThreads
//
//  Created by 홍수만 on 2023/11/05.
//

import UIKit
import SnapKit
import RxSwift

class ShoppingListTableViewCell: UITableViewCell {
    
    static let identifier = "ShoppingListTableViewCell"
    
    let checkButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "checkmark.square")!, for: .normal)
        view.tintColor = .black
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let contentLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 17)
        view.textColor = .black
        return view
    }()
    
    let likeButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "star")!, for: .normal)
        view.tintColor = .black
        view.isUserInteractionEnabled = true
        return view
    }()
    
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .systemGray6
        
        configureView()
        setConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    private func configureView() {
        
        contentView.layer.cornerRadius = 10
        
        [checkButton, contentLabel, likeButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setConstraints() {
        checkButton.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkButton.snp.trailing).offset(20)
            make.verticalEdges.equalToSuperview().inset(10)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.centerY.equalTo(checkButton)
        }
        
        likeButton.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.leading.equalTo(contentLabel.snp.trailing).offset(20)
            make.trailing.lessThanOrEqualToSuperview().offset(-20)
            make.centerY.equalTo(checkButton)
        }
        
    }
    
}

