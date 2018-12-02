//
//  StoryDto.swift
//  Letterer/Stories
//
//  Created by Marcin Czachurski on 26/11/2018.
//

import Vapor

final class StoryDto {

    var id: UUID?
    var token: String
    var userId: UUID
    var title: String
    var text: String
    var created: Date?
    var modified: Date?
    var published: Date?
    var lead: String?
    var language: String?
    var words: Int?
    var duration: Int?

    init(id: UUID?,
         token: String,
         userId: UUID,
         title: String,
         text: String,
         created: Date? = nil,
         modified: Date? = nil,
         published: Date? = nil,
         lead: String? = nil,
         language: String? = nil,
         words: Int? = nil,
         duration: Int? = nil) {
        self.token = token
        self.userId = userId
        self.title = title
        self.text = text
        self.created = created
        self.modified = modified
        self.published = published
        self.lead = lead
        self.language = language
        self.words = words
        self.duration = duration
    }
}

extension StoryDto: Content { }

extension StoryDto {
    convenience init(from story: Story) {
        self.init(
            id: story.id,
            token: story.token,
            userId: story.userId,
            title: story.title,
            text: story.text,
            created: story.created,
            modified: story.modified,
            published: story.published,
            lead: story.lead,
            language: story.language,
            words: story.words,
            duration: story.duration
        )
    }
}
