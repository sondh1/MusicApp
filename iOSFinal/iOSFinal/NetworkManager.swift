//
//  NetworkManager.swift
//  iOSFinal
//
//  Created by QuanDL.FA on 1/31/23.
//

import Foundation
import Alamofire
import CoreTelephony
import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    private init(){}
    
    func getData(name: String, completion: @escaping (Weather) -> Void) {
        let url = "https://api.weatherapi.com/v1/forecast.json"
        let parameters: Parameters = [
            "key" : "c6c490750b2645fcb6442449233101",
            "q" : name,
            "days" : 1,
            "aqi" : "no",
            "alerts": "no"

        ]
        
        AF.request(url, method: .get, parameters: parameters).responseDecodable(of: Weather.self) { response in
            let result = response.result
            switch result {
            case .success(let weather):
                completion(weather)
            case .failure(let error):
                print(String(describing: error))
            }
        
            
        }
    }
    
}

