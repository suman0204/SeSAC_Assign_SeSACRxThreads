//
//  SignInViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SignInViewController: UIViewController {

    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let signInButton = PointButton(title: "로그인")
    let signUpButton = UIButton()
    
    //Rx
    let disposeBag = DisposeBag()
//    let email = BehaviorSubject(value: "")//PublishSubject<String>()
//    let password = BehaviorSubject(value: "") //PublishSubject<String>()
//    let textfieldButtonColor: BehaviorSubject<ColorType> = BehaviorSubject(value: .red)
    let viewModel = SignInViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        configure()
        
        signUpButton.addTarget(self, action: #selector(signUpButtonClicked), for: .touchUpInside)
        
        bind()
        
    }
    
    func bind() {
        viewModel.email
            .bind(to: emailTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.password
            .bind(to: passwordTextField.rx.text)
            .disposed(by: disposeBag)
        
//        let email = emailTextField.rx.text.orEmpty
//        let password = passwordTextField.rx.text.orEmpty
        
        viewModel.textfieldButtonColor
            .map { $0.returnColor }
            .bind(to: emailTextField.rx.tintColor, passwordTextField.rx.tintColor, signInButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        viewModel.textfieldButtonColor
            .map { $0.returnColor.cgColor }
            .bind(to: emailTextField.layer.rx.borderColor, passwordTextField.layer.rx.borderColor)
            .disposed(by: disposeBag)
        
        emailTextField.rx.text.orEmpty
            .subscribe(with: self) { owner, value in
                owner.viewModel.email.onNext(value)
            }
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .subscribe(with: self) { owner, value in
                owner.viewModel.password.onNext(value)
            }
            .disposed(by: disposeBag)
        
//        let validation = Observable.combineLatest(viewModel.email, viewModel.password) { email, password in
//            return email.count > 8 && password.count > 6
//        }
        
        viewModel.validation
            .subscribe(with: self) { owner, value in
//                let color = value ? ColorType.blue : ColorType.red
//                owner.viewModel.textfieldButtonColor.onNext(color)
                owner.signInButton.rx.isEnabled.onNext(value)
            }
            .disposed(by: disposeBag)
        
        signInButton.rx.tap
            .subscribe(with: self) { owner, value in
                owner.navigationController?.pushViewController(SearchViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    @objc func signUpButtonClicked() {
        navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    
    
    func configure() {
        signUpButton.setTitle("회원이 아니십니까?", for: .normal)
        signUpButton.setTitleColor(Color.black, for: .normal)
    }
    
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signInButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(signInButton.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    

}
