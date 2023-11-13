//
//  APIManager.swift
//  SeSACRxThreads
//
//  Created by 홍수만 on 2023/11/13.
//

import Foundation
import Moya

class APIManager {
    
    static let shared = APIManager()
    
    private init() { }
    
    let provider = MoyaProvider<API>()
    
    func emailValid(email: String) {
        
        provider.request(.emailValidation(email: email)) { result in
            switch result {
            case.success(let value):
                print("Success", value.statusCode, value.data)
            case .failure(let error):
                print("error---", error)
            }
        }
    }
    
    func signUP(email: String, password: String, nick: String) {
        let data = Join(email: email, password: password, nick: nick)
        
        provider.request(.signUp(model: data)) { result in
            switch result {
            case.success(let value):
                print("success", value.statusCode, value.data)
                
//                let result = try! JSONDecoder().decode(JoinResponse.self, from: value.data)
                
            case .failure(let error):
                print("error---", error)
            }
        }
    }
}
