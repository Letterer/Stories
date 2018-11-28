//
//  StoryError.swift
//  Letterer/Stories
//
//  Created by Marcin Czachurski on 28/11/2018.
//

import Vapor
import ExtendedError

enum StoryError: String, Error {
    case storyNotExists
}

extension StoryError: TerminateError {
    var status: HTTPResponseStatus {
        return .badRequest
    }

    var reason: String {
        switch self {
        case .storyNotExists: return "Story not exists. Probably story token is incorrect or user deleted this story."
        }
    }

    var identifier: String {
        return "user"
    }

    var code: String {
        return self.rawValue
    }
}
