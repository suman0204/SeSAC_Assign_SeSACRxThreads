//
//  iTunesSearchTableViewCell.swift
//  SeSACRxThreads
//
//  Created by 홍수만 on 2023/11/06.
//

import UIKit
import SnapKit
import RxSwift

class iTunesSearchTableViewCell: UITableViewCell {
    
    static let identifier = "iTunesSearchTableViewCell"
    
    let topView = {
        let view = UIView()
        return view
    }()
    
    let appIcon = {
        let view = UIImageView()
        view.layer.cornerRadius = 8
        view.layer.cornerCurve = .continuous
        return view
    }()
    
    let appTitleLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 17)
        return label
    }()
    
    let downloadButton = {
        let button = UIButton()
        button.layer.cornerRadius = 20
        button.setTitle("받기", for: .normal)
        return button
    }()
    
    let containerStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
//        stack.spacing = 10
        return stack
    }()
    
    let starImage = {
        let view = UIImageView()
        view.image = UIImage(systemName: "star.fill")
        view.tintColor = .blue
        return view
    }()
    
    let rateLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .lightGray
        return label
    }()
    
    let sellerNameLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .lightGray
        return label
    }()
    
    let categoryLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .lightGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        [appIcon, appTitleLabel, downloadButton].forEach {
            topView.addSubview($0)
        }
        
        [starImage, rateLabel, sellerNameLabel, categoryLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        [topView, containerStackView].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setConstraints() {
        topView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        
        appIcon.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.leading.equalToSuperview().offset(10)
            make.verticalEdges.equalToSuperview().inset(10)
        }
        
        appTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(appIcon.snp.trailing).offset(10)
            make.centerY.equalTo(appIcon)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.width.equalToSuperview().multipliedBy(0.1)
            make.height.equalToSuperview().multipliedBy(0.1)
        }
    }
    
}
