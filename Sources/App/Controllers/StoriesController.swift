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
        router.get("/stories", use: stories)
        router.get("/stories", String.parameter, use: story)
        router.post(StoryDto.self, at: "/stories", use: create)
        router.put(StoryDto.self, at: "/stories", String.parameter, use: update)
        router.delete("/stories", String.parameter, use: delete)
    }

    func stories(request: Request) throws -> Future<[StoryDto]> {

        let authorizationService = try request.make(AuthorizationService.self)
        guard let userIdFromToken = try authorizationService.getUserIdFromBearerToken(request: request) else {
            throw Abort(.unauthorized)
        }

        return Story.query(on: request).filter(\.userId == userIdFromToken).all().map(to: [StoryDto].self) { storiesFromDb in

            var storiesDto: [StoryDto] = []
            for story in storiesFromDb {
                let storyDto = StoryDto(from: story)
                storiesDto.append(storyDto)
            }
            
            return storiesDto
        }
    }

    func story(request: Request) throws -> Future<StoryDto> {

        let authorizationService = try request.make(AuthorizationService.self)
        guard let _ = try authorizationService.getUserIdFromBearerToken(request: request) else {
            throw Abort(.unauthorized)
        }

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

    func update(request: Request, storyDto: StoryDto) throws -> Future<StoryDto> {

        let authorizationService = try request.make(AuthorizationService.self)
        guard let userIdFromToken = try authorizationService.getUserIdFromBearerToken(request: request) else {
            throw Abort(.unauthorized)
        }

        let token = try request.parameters.next(String.self).lowercased()

        return Story.query(on: request).filter(\.token == token).first().flatMap(to: Story.self) { storyFromDb in

            guard let story = storyFromDb else {
                throw StoryError.storyNotExists
            }

            if story.userId != userIdFromToken {
                throw StoryError.storyNotExists
            }

            story.title = storyDto.title
            story.text = storyDto.text
            story.language = self.findDominantLanguage(for: story.text)

            return story.update(on: request)
        }.map(to: StoryDto.self) { story in
            return StoryDto(from: story)
        }
    }

    func delete(request: Request) throws -> Future<HTTPStatus> {

        let authorizationService = try request.make(AuthorizationService.self)
        guard let userIdFromToken = try authorizationService.getUserIdFromBearerToken(request: request) else {
            throw Abort(.unauthorized)
        }

        let token = try request.parameters.next(String.self).lowercased()

        return Story.query(on: request).filter(\.token == token).first().flatMap(to: Void.self) { storyFromDb in

            guard let story = storyFromDb else {
                throw StoryError.storyNotExists
            }

            guard story.userId == userIdFromToken else {
                throw StoryError.storyNotExists
            }

            return story.delete(on: request)
        }.transform(to: HTTPStatus.ok)
    }

    private func findDominantLanguage(for text: String) -> String {
        // return NSLinguisticTagger.dominantLanguage(for: text)
        return "en"
    }
}
