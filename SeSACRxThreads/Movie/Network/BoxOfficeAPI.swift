//
//  BoxOfficeAPI.swift
//  SeSACRxThreads
//
//  Created by 홍수만 on 2023/11/06.
//

import Foundation
import RxSwift

enum APIError: Error {
    case invalidURL
    case unknown
    case statusError
}

class BoxOfficeAPI {
    
    static func fetchData(date: String) -> Observable<BoxOfficeResult> {
        
        Observable<BoxOfficeResult>.create { value in
            
            let stringURL = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=f5eef3421c602c6cb7ea224104795888&targetDt=\(date)"
            
            guard let url = URL(string: stringURL) else {
                value.onError(APIError.invalidURL)
                return Disposables.create()
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                print("URLSession Succed")
                
                if let _ = error {
                    value.onError(APIError.unknown)
                }
                
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    value.onError(APIError.statusError)
                    return
                }
                
                if let data = data, let appData = try? JSONDecoder().decode(BoxOffice.self, from: data) {
                    value.onNext(appData.boxOfficeResult)
                }
            }.resume()
            
            return Disposables.create()
        }
    }
}
