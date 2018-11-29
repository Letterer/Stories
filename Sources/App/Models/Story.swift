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
    var created: Date
    var modified: Date
    var lead: String?
    var language: String?
    var words: Int?
    var duration: Int?

    init(id: UUID? = nil,
         token: String,
         userId: UUID,
         title: String,
         text: String,
         created: Date,
         modified: Date,
         lead: String? = nil,
         language: String? = nil,
         words: Int? = nil,
         duration: Int? = nil
    ) {
        self.id = id
        self.token = token
        self.userId = userId
        self.title = title
        self.text = text
        self.created = created
        self.modified = modified
        self.lead = lead
        self.language = language
        self.words = words
        self.duration = duration
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
            created: storyDto.created ?? Date(),
            modified: storyDto.modified ?? Date(),
            lead: storyDto.lead,
            language: storyDto.language,
            words: storyDto.words,
            duration: storyDto.duration
        )
    }
}
