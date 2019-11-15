//
//  UserInformation Model.swift
//  Messenger
//
//  Created by Vitaliy Paliy on 11/5/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import Foundation

// User information

class UserInformation{
    var id: String?
    var name: String?
    var email: String?
    var profileImage: String?
    var friend: Bool?
}

class CurrentUserInformation{
    static var uid: String!
    static var name: String!
    static var email: String!
    static var profileImage: String!
}
