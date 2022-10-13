//
//  UserModel.swift
//  githubAPI
//
//  Created by Vinicius on 04/10/22.
//

import Foundation
import UIKit

struct UserDetail: Codable {
    let login: String
    let id: Int?
    let avatar_url: String
    let name: String

}
