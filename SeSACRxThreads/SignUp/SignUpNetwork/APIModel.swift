//
//  APIModel.swift
//  SeSACRxThreads
//
//  Created by 홍수만 on 2023/11/13.
//

import Foundation

struct Join: Encodable {
    let email: String
    let password: String
    let nick: String
}

struct SignIn: Encodable {
    let email: String
    let password: String
}

struct JoinResponse: Decodable {
    let email: String
    let nick: String
}
