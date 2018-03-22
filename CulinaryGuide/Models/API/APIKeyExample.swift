/*
    1. Duplicate this file as APIKey.swift
    2. Rename the following enum to APIKey
    3. Add missing keys as obfuscated string

    See: https://github.com/UrbanApps/UAObfuscatedString

    ************************************************
    ** DO NOT ADD APIKey.swift TO THE REPOSITORY! **
    ************************************************
 */

import Foundation

struct APIKeyExample {
    static var secret: String {
        switch API.environment {
        case .production:
            return String().t.e.s.t.space.a.p.i.space.k.e.y
        case .staging:
            return String().t.e.s.t.space.a.p.i.space.k.e.y
        case .development:
            return String().t.e.s.t.space.a.p.i.space.k.e.y
        }
    }
}
