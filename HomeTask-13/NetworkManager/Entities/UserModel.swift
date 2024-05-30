//
//  UserModel.swift
//  HomeTask-13
//
//  Created by Apple on 29.05.24.
//

import Foundation

struct UserModel: Decodable{
    let name: String
    let bio: String
    let avatar_url: String
    let followers: Int
    let following: Int
    let public_repos: Int
}
