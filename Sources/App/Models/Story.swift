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
    var title: String
    var text: String

    init(id: UUID? = nil,
         title: String,
         text: String
    ) {
        self.id = id
        self.title = title
        self.text = text
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
            title: storyDto.title,
            text: storyDto.text
        )
    }
}
