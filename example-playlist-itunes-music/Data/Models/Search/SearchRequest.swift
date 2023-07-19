//
//  SearchRequest.swift
//  example-playlist-itunes-music
//
//  Created by Nontawat Kanboon on 20/7/2566 BE.
//

import Foundation

public struct SearchRequest: Codable {
    
    public let term: String?
    public let limit: Int?
    public let country: String?
    public let media: String?
    
    public init(term: String?, limit: Int?, country: String?, media: String?) {
        self.term = term
        self.limit = limit
        self.country = country
        self.media = media
    }
    
    enum CodingKeys: String, CodingKey {
        case term = "term"
        case limit = "limit"
        case country = "country"
        case media = "media"
    }
}
