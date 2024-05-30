//
//  NetworkManager.swift
//  HomeTask-13
//
//  Created by Apple on 29.05.24.
//

import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    
    func getUser(username: String, completion: @escaping (Result<UserModel, AFError>) -> Void){
        AF.request("https://api.github.com/users/\(username)").responseDecodable(of: UserModel.self) { response in
            completion(response.result)
        }
    }
}
