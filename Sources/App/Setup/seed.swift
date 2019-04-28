//
//  seed.swift
//  App
//
//  Created by Marcin Czachurski on 27/04/2019.
//

import Vapor
import FluentPostgreSQL

public class DatabaseSeed {

    public static func `default`(_ app: Application) throws {
        let connection = try app.newConnection(to: .psql).wait()
        try settings(on: connection)
    }

    private static func settings(on connection: PostgreSQLConnection) throws {
        let settings = try Setting.query(on: connection).all().wait()

        try ensureSettingExists(on: connection, existing: settings, key: .jwtPublicKey, value:
            """
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAh4WjL2kJmM2GwSp1h/SM
yrx7hD99Hl5vdNqlEhJ7mpg7UHznK0A3nroOqo4Z8idkfM0kjTLFqlHdo1HU5jBm
ibfuTo8CpAwqKi6Ff+sR9mJd8QkQnPRmHgRg5hvbt8h1zHZokiKFUG0P5bCoZ/bg
zHEXIVYZ3Y+htcvZwSIpZBqjZ/QmHjIk9Q7gKlcVUOgBuagerpvxELD4viOu7OET
V3bpVa5boL55jJoxHmpUKiPaytOix8eRvi8YjUNf3uQ5y9ye+891BEsVxcjLDyHM
UKcpj5e1EysLDLJJQsbRUElO0CCsquATzcGbPz3pmF/5Wn1mRr+GoLD72Hr4wR9/
MwIDAQAB
-----END PUBLIC KEY-----
""")
    }

    private static func ensureSettingExists(on connection: PostgreSQLConnection,
                                            existing settings: [Setting],
                                            key: SettingKey,
                                            value: String) throws {

        if !settings.contains(where: { $0.key == key.rawValue }) {
            let setting = Setting(key: key.rawValue, value: value)
            _ = try setting.save(on: connection).wait()
        }
    }
}
