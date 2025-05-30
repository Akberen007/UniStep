//
//  UserModel.swift
//  UniStep
//
//  Created by Akberen on 28.05.2025.
//

import Foundation

struct UserModel: Identifiable {
    var id: String { uid }
    let uid: String
    let email: String
    let role: String
}
