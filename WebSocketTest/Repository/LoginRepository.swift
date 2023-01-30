//
//  LoginRepository.swift
//  WebSocketTest
//
//  Created by kbsys on 2023/01/30.
//

import Foundation

protocol LoginRepository {
    func requestLogin(userID:String, completion:@escaping (Result<Data, APIError>)->Void)
}

class LoginRepositoryImpl:LoginRepository {
    
    let loginURLString = "\(BASE_URL)/loginMOBILE?user=\(TEST_ID)"
    
    func requestLogin(userID:String, completion:@escaping (Result<Data, APIError>)->Void) {
        // method = get
        var request = URLRequest(url: URL(string: loginURLString)!)
        request.httpMethod = "GET"
        
        // header set
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data else {
                return completion(.failure(.data))
            }
            completion(.success(data))
            
        }.resume()
    }
}
