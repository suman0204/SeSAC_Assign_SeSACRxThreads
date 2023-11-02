//
//  NicknameViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class NicknameViewController: UIViewController {
   
    let viewModel = NicknameViewModel()
    
    let nicknameTextField = SignTextField(placeholderText: "닉네임을 입력해주세요")
    let nextButton = PointButton(title: "다음")
    
//    let nickname = PublishSubject<String>()
//    let nextButtonEnabled = BehaviorSubject(value: false)
//    let buttonColor = BehaviorSubject(value: UIColor.red)
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
       
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)

        bind()
    }
    
    func bind() {
        viewModel.buttonColor
            .map { $0.buttonColor }
            .bind(to: nextButton.rx.backgroundColor, nicknameTextField.rx.tintColor)
            .disposed(by: disposeBag)
        
        viewModel.buttonColor
            .map { $0.buttonColor.cgColor }
            .bind(to: nicknameTextField.layer.rx.borderColor)
            .disposed(by: disposeBag)
        
        viewModel.nickname
            .bind(to: nicknameTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.nextButtonEnabled
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
//        viewModel.nickname
//            .map { $0.count >= 2 && $0.count < 6}
//            .subscribe(with: self) { owner, value in
//                let color = value ? ButtonColor.blue : ButtonColor.red
//                owner.viewModel.buttonColor.onNext(color)
//                
//                owner.viewModel.nextButtonEnabled.onNext(value)
//            }
//            .disposed(by: disposeBag)
        
        nicknameTextField.rx.text.orEmpty
            .subscribe { value in
                self.viewModel.nickname.onNext(value)
            }
            .disposed(by: disposeBag)
        
    }
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(BirthdayViewController(), animated: true)
    }

    
    func configureLayout() {
        view.addSubview(nicknameTextField)
        view.addSubview(nextButton)
         
        nicknameTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
