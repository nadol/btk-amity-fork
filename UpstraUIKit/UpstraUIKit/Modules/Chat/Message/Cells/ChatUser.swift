//
//  ChatUser.swift
//  AmityUIKit
//
//  Created by Mateusz Nadolski on 12/05/2024.
//  Copyright © 2024 Amity. All rights reserved.
//

import Foundation

public struct ChatUser: Codable {
    let id: String
    let fullName: String
    let isCommissioner: Bool
    let role: String?
    let avatarURL: URL?

    public init(id: String, fullName: String, isCommissioner: Bool, role: String?, avatarURL: URL?) {
        self.id = id
        self.fullName = fullName
        self.isCommissioner = isCommissioner
        self.role = role
        self.avatarURL = avatarURL
    }
}
