//
//  StoriesController.swift
//  Letterer/Stories
//
//  Created by Marcin Czachurski on 26/11/2018.
//

import Foundation
import Vapor
import FluentPostgreSQL

/// Controls basic operations for Story object.
final class StoriesController: RouteCollection {

    func boot(router: Router) throws {
        router.get("/stories", String.parameter, use: story)
        router.post(StoryDto.self, at: "/stories", use: create)
        // router.put(UserDto.self, at: "/stories", String.parameter, use: update)
        // router.delete("/stories", String.parameter, use: delete)
    }

    func story(request: Request) throws -> Future<StoryDto> {

        let token = try request.parameters.next(String.self).lowercased()

        return Story.query(on: request).filter(\.token == token).first().map(to: StoryDto.self) { storyFromDb in

            guard let story = storyFromDb else {
                throw StoryError.storyNotExists
            }

            let storyDto = StoryDto(from: story)
            return storyDto
        }
    }

    func create(request: Request, storyDto: StoryDto) throws -> Future<StoryDto> {

        let authorizationService = try request.make(AuthorizationService.self)
        guard let userIdFromToken = try authorizationService.getUserIdFromBearerToken(request: request) else {
            throw Abort(.unauthorized)
        }

        let story = Story(from: storyDto)
        story.language = self.findDominantLanguage(for: story.text)
        story.userId = userIdFromToken

        return story.save(on: request).map(to: StoryDto.self) { story in
            return StoryDto(from: story)
        }
    }

    private func findDominantLanguage(for text: String) -> String {
        // return LinguisticTagger.dominantLanguage(for: text)
        return "en"
    }
}
