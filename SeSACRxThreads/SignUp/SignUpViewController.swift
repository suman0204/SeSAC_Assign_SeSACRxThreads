//
//  SignUpViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let viewModel = SignUpViewModel()
//    let email = BehaviorSubject(value: "")

    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let validationButton = UIButton()
    let nextButton = PointButton(title: "다음")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        configure()
        
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
        bind()

    }
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(PasswordViewController(), animated: true)
    }
    
    func bind() {
        //input
//        emailTextField.rx.text.orEmpty
//            .map { $0.isValidEmail()}
//            .subscribe(with: self) { owner, value in
//                owner.validationButton.rx.isEnabled.onNext(value)
//                
//                let color = value ? UIColor.black : UIColor.gray
//                owner.validationButton.layer.rx.borderColor.onNext(color.cgColor)
//                owner.validationButton.setTitleColor(color, for: .normal)
//            }
//            .disposed(by: disposeBag)
        
//        validationButton.rx.tap
//            .throttle(.seconds(1), scheduler: MainScheduler.instance)
//            .withLatestFrom(emailTextField.rx.text.orEmpty) { void, email in
//                return email
//            }
//            .subscribe(with: self) { owner, email in
//                print("tapped")
//                APIManager.shared.emailValid(email: email) { statusCode in
//                    switch statusCode {
//                    case 200:
//                        print("사용 가능한 이메일입니다.")
//                        owner.nextButton.rx.isEnabled.onNext(true)
//                        owner.nextButton.rx.backgroundColor.onNext(.black)
//                    case 409:
//                        print("이미 사용 중인 이메일입니다.")
//                        owner.nextButton.rx.isEnabled.onNext(false)
//                        owner.nextButton.rx.backgroundColor.onNext(.red)
//                    case 500:
//                        print("Server Error")
//                        owner.nextButton.rx.isEnabled.onNext(false)
//                        owner.nextButton.rx.backgroundColor.onNext(.red)
//                    default:
//                        print("Email Validation")
//                        owner.nextButton.rx.isEnabled.onNext(false)
//                        owner.nextButton.rx.backgroundColor.onNext(.red)
//                    }
//                }
//            }
//            .disposed(by: disposeBag)
        
        let input = SignUpViewModel.Input(email: emailTextField.rx.text.orEmpty, validationButtonClicked: validationButton.rx.tap, nextButtonClicked: nextButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.validationButtonEnabled
            .bind(to: validationButton.rx.isEnabled)
            .disposed(by: disposeBag)

        output.validationButtonEnabled
            .bind(with: self) { owner, value in
                let color: UIColor = value ? .black : .lightGray
                owner.validationButton.layer.borderColor = color.cgColor
                owner.validationButton.setTitleColor(color, for: .normal)
            }
            .disposed(by: disposeBag)

        output.nextButtonEnabled
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.nextButtonEnabled
            .bind(with: self) { owner, value in
                let color: UIColor = value ? .black : .red
                owner.nextButton.backgroundColor = color
            }
            .disposed(by: disposeBag)
        
        
            
    }

    func configure() {
        validationButton.setTitle("중복확인", for: .normal)
        validationButton.setTitleColor(Color.black, for: .normal)
        validationButton.layer.borderWidth = 1
        validationButton.layer.borderColor = Color.black.cgColor
        validationButton.layer.cornerRadius = 10
        
        nextButton.isEnabled = false //?..
    }
    
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(validationButton)
        view.addSubview(nextButton)
        
        validationButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.equalTo(100)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.trailing.equalTo(validationButton.snp.leading).offset(-8)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    

}


extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}
