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
    var language: String?

    init(id: UUID?,
         token: String,
         userId: UUID,
         title: String,
         text: String,
         language: String? = nil) {
        self.token = token
        self.userId = userId
        self.title = title
        self.text = text
        self.language = language
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
            language: story.language
        )
    }
}