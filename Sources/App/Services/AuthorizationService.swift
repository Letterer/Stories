//
//  AuthorizationService.swift
//  Letterer/Stories
//
//  Created by Marcin Czachurski on 26/11/2018.
//

import Vapor
import JWT
import Crypto

final class AuthorizationService: ServiceType {

    static func makeService(for worker: Container) throws -> AuthorizationService {
        return AuthorizationService()
    }

    public func getUserIdFromBearerToken(request: Request) throws -> Future<UUID?> {
        return try self.geAuthorizationPayloadFromBearerToken(request: request).map(to: UUID?.self) { authorizationPayload in
            guard let unwrapedAuthorizationPayload = authorizationPayload else {
                return nil
            }

            return unwrapedAuthorizationPayload.id
        }
    }

    public func getUserNameFromBearerToken(request: Request) throws -> Future<String?> {
        return try self.geAuthorizationPayloadFromBearerToken(request: request).map(to: String?.self) { authorizationPayload in
            guard let unwrapedAuthorizationPayload = authorizationPayload else {
                return nil
            }

            return unwrapedAuthorizationPayload.userName
        }
    }

    private func geAuthorizationPayloadFromBearerToken(request: Request) throws -> Future<AuthorizationPayload?> {

        if let bearer = request.http.headers.bearerAuthorization {

            let settingsService = try request.make(SettingsServiceType.self)
            return try settingsService.get(on: request).map(to: AuthorizationPayload?.self) { configuration in

                guard let jwtPrivateKey = configuration.getString(.jwtPublicKey) else {
                    throw Abort(.internalServerError, reason: "Private key is not configured in database.")
                }

                let rsaKey: RSAKey = try .public(pem: jwtPrivateKey)
                let authorizationPayload = try JWT<AuthorizationPayload>(from: bearer.token, verifiedUsing: JWTSigner.rs512(key: rsaKey))

                if authorizationPayload.payload.exp > Date() {
                    return authorizationPayload.payload
                }

                return nil
            }
        }

        return Future.map(on: request) { return nil }
    }

    public func getUserNameFromBearerTokenOrAbort(on request: Request) throws -> Future<String> {

        return try self.getUserNameFromBearerToken(request: request).map(to: String.self) { userNameFromToken in
            guard let unwrapedUserNameFromToken = userNameFromToken else {
                throw Abort(.unauthorized)
            }

            return unwrapedUserNameFromToken
        }
    }

    public func getUserIdFromBearerTokenOrAbort(on request: Request) throws -> Future<UUID> {

        return try self.getUserIdFromBearerToken(request: request).map(to: UUID.self) { userIdFromToken in
            guard let unwrapedUserIdFromToken = userIdFromToken else {
                throw Abort(.unauthorized)
            }

            return unwrapedUserIdFromToken
        }
    }
}
