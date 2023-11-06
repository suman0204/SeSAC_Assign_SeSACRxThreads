//
//  BoxOfficeTableViewCell.swift
//  SeSACRxThreads
//
//  Created by 홍수만 on 2023/11/06.
//

import UIKit
import SnapKit
import RxSwift

class BoxOfficeTableViewCell: UITableViewCell {
    
    static let identifier = "BoxOfficeTableViewCell"
    
    var disposeBag = DisposeBag()
    
    let backView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 10
        return view
    }()
    
    let rankLabel = {
        let label = UILabel()
        return label
    }()
    
    let titleLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    let openDateLabel = {
        let label = UILabel()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
        
        [rankLabel, titleLabel, openDateLabel].forEach {
            backView.addSubview($0)
        }
        
        contentView.addSubview(backView)
        
    }
    
    private func setConstraints() {
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        rankLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.verticalEdges.equalToSuperview().inset(10)
            make.width.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(rankLabel.snp.trailing).offset(20)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(20)
        }
        
        openDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(rankLabel.snp.trailing).offset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            
        }
    }
}
