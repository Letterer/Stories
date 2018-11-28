//
//  StoryDto.swift
//  Letterer/Stories
//
//  Created by Marcin Czachurski on 26/11/2018.
//

import Vapor

final class StoryDto {

    var id: UUID?
    var title: String
    var text: String

    init(title: String, text: String) {
        self.title = title
        self.text = text
    }
}

extension StoryDto: Content { }
