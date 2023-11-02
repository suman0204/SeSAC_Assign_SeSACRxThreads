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
   
    let nicknameTextField = SignTextField(placeholderText: "닉네임을 입력해주세요")
    let nextButton = PointButton(title: "다음")
    
    let nickname = PublishSubject<String>()
    let nextButtonEnabled = BehaviorSubject(value: false)
    let buttonColor = BehaviorSubject(value: UIColor.red)
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
       
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)

        bind()
    }
    
    func bind() {
        buttonColor
            .bind(to: nextButton.rx.backgroundColor, nicknameTextField.rx.tintColor)
            .disposed(by: disposeBag)
        
        buttonColor
            .map { $0.cgColor }
            .bind(to: nicknameTextField.layer.rx.borderColor)
            .disposed(by: disposeBag)
        
        nickname
            .bind(to: nicknameTextField.rx.text)
            .disposed(by: disposeBag)
        
        nextButtonEnabled
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        nickname
            .map { $0.count >= 2 && $0.count < 6}
            .subscribe(with: self) { owner, value in
                let color = value ? UIColor.blue : UIColor.red
                owner.buttonColor.onNext(color)
                
                owner.nextButtonEnabled.onNext(value)
            }
            .disposed(by: disposeBag)
        
        nicknameTextField.rx.text.orEmpty
            .subscribe { value in
                self.nickname.onNext(value)
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
