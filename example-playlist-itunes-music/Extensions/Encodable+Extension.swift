//
//  Encodable+Extension.swift
//  example-playlist-itunes-music
//
//  Created by Nontawat Kanboon on 20/7/2566 BE.
//

import Foundation

extension Encodable {
    
    public func toJSON() -> [String: Any] {
        do {
            let encoded = try JSONEncoder().encode(self)
            let json = try JSONSerialization.jsonObject(with: encoded) as? [String: Any]
            return json ?? [:]
        } catch {
            return [:]
        }
    }
}
