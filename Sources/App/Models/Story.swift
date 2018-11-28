//
//  User.swift
//  Letterer/Users
//
//  Created by Marcin Czachurski on 08/10/2018.
//

import FluentPostgreSQL
import Vapor
import Crypto

/// A single entry of a Voice list.
final class Story: PostgreSQLUUIDModel {

    var id: UUID?
    var token: String
    var userId: UUID
    var title: String
    var text: String
    var language: String?

    init(id: UUID? = nil,
         token: String,
         userId: UUID,
         title: String,
         text: String,
         language: String? = nil
    ) {
        self.id = id
        self.token = token
        self.userId = userId
        self.title = title
        self.text = text
        self.language = language
    }
}

/// Allows `Story` to be used as a dynamic migration.
extension Story: Migration { }

/// Allows `Story` to be encoded to and decoded from HTTP messages.
extension Story: Content { }

/// Allows `Story` to be used as a dynamic parameter in route definitions.
extension Story: Parameter { }

extension Story {
    convenience init(from storyDto: StoryDto) {
        self.init(
            token: storyDto.token,
            userId: storyDto.userId,
            title: storyDto.title,
            text: storyDto.text,
            language: storyDto.language
        )
    }
}
