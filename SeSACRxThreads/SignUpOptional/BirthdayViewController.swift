//
//  BirthdayViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BirthdayViewController: UIViewController {
    
    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    let infoLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.text = "만 17세 이상만 가입 가능합니다."
        return label
    }()
    
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10 
        return stack
    }()
    
    let yearLabel: UILabel = {
       let label = UILabel()
        label.text = "2023년"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let monthLabel: UILabel = {
       let label = UILabel()
        label.text = "33월"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let dayLabel: UILabel = {
       let label = UILabel()
        label.text = "99일"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
  
    let nextButton = PointButton(title: "가입하기")
    
    let viewModel = BirthdayViewModel()
    
//    let birthday = BehaviorSubject(value: Date.now)
//    let year = BehaviorSubject(value: 2020)
//    let month = BehaviorSubject(value: 10)
//    let day = BehaviorSubject(value: 12)
    
    let buttonColor = BehaviorSubject(value: UIColor.red)
//    let buttonEnabled = BehaviorSubject(value: false)
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
        bind()
    }
    
    func bind() {
        viewModel.year
            .map { "\($0)년" }
            .bind(to: yearLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.month
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, value in
                owner.monthLabel.text = "\(value)월"
            } onDisposed: { owner in
                print("month dispose")
            }
            .disposed(by: disposeBag)
        
        viewModel.day
            .map{"\($0)일"}
            .subscribe(with: self) { owner, value in
                owner.dayLabel.text = value
            }
            .disposed(by: disposeBag)
        
        birthDayPicker.rx.date
            .bind(to: viewModel.birthday)
            .disposed(by: disposeBag)
        
//        viewModel.birthday
//            .subscribe(with: self) { owner, date in
//                let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
//                
//                guard let year = component.year, let month = component.month, let day = component.day else {return}
//                
//                owner.viewModel.year.onNext(year)
//                owner.viewModel.month.onNext(month)
//                owner.viewModel.day.onNext(day)
//                
////                let ageComponent = Calendar.current.dateComponents([.year], from: date, to: Date())
////                guard let age = ageComponent.year else {return}
////                
////                if age >= 17 {
////                    owner.buttonColor.onNext(.blue)
////                    owner.viewModel.buttonEnabled.onNext(true)
////                } else {
////                    owner.buttonColor.onNext(.red)
////                    owner.viewModel.buttonEnabled.onNext(false)
////                }
//            }
//            .disposed(by: disposeBag)
        
//        viewModel.birthday
//            .map{ date in
//                let ageComponent = Calendar.current.dateComponents([.year], from: date, to: Date())
//                return ageComponent.year ?? 0 >= 17
//            }
//            .subscribe(with: self) { owner, value in
//                let color = value ? ButtonColor.blue : ButtonColor.red
//                owner.viewModel.buttonColor.onNext(color)
//                owner.viewModel.buttonEnabled.onNext(value)
//            }
//            .disposed(by: disposeBag)

        
        viewModel.buttonColor
            .map { $0.buttonColor }
            .bind(to: nextButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        viewModel.buttonEnabled
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        
    }
    
    @objc func nextButtonClicked() {
        print("가입완료")
    }

    
    func configureLayout() {
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
 
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
   
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}

enum ButtonColor {
    case red
    case blue
    
    var buttonColor: UIColor {
        switch self {
        case .red:
            return UIColor.red
        case .blue:
            return UIColor.blue
        }
    }
}
