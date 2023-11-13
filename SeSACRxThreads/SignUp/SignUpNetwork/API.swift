//
//  API.swift
//  SeSACRxThreads
//
//  Created by 홍수만 on 2023/11/13.
//

import Foundation
import Moya

enum API {
    case signUp(model: Join)
    case emailValidation(email: String)
    case signIn(model: SignIn)
}

extension API: TargetType {
    
    var baseURL: URL {
        URL(string: "http://lslp.sesac.kr:27811/")!
    }
    
    var path: String {
        switch self {
        case .signUp:
            return "join"
        case .emailValidation:
            return "validation/email"
        case .signIn:
            return "login"
        }
    }

    var method: Moya.Method {
        switch self {
        case .signUp, .emailValidation, .signIn:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .signUp(let data):
            return .requestJSONEncodable(data)
        case .emailValidation(let email):
            return .requestJSONEncodable(email)
        case .signIn(let data):
            return .requestJSONEncodable(data)
        }
    }
    
    var headers: [String : String]? {
        ["Content-Type" : "application/json",
         "SesacKey": "aNV93W3Xd8"]
    }
    
}
