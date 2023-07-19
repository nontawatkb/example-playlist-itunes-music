//
//  SearchResponse.swift
//  example-playlist-itunes-music
//
//  Created by Nontawat Kanboon on 20/7/2566 BE.
//

import Foundation

public struct SearchResponse: Codable, Hashable {
    
    public var resultCount: Int?
    public var results: [SearchItem]?
    
    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case resultCount = "resultCount"
        case results = "results"
    }
}

public struct SearchItem: Codable, Hashable {
    
    public var wrapperType: String?
    public var kind: String?
    public var artistId: Int?
    public var collectionId: Int?
    public var trackId: Int?
    public var artistName: String?
    public var collectionName: String?
    public var trackName: String?
    public var collectionCensoredName: String?
    public var trackCensoredName: String?
    public var artistViewUrl: String?
    public var collectionViewUrl: String?
    public var trackViewUrl: String?
    public var previewUrl: String?
    public var artworkUrl30: String?
    public var artworkUrl60: String?
    public var artworkUrl100: String?
    public var collectionPrice: Double?
    public var trackPrice: Double?
    public var releaseDate: String?
    public var collectionExplicitness: String?
    public var trackExplicitness: String?
    public var discCount: Int?
    public var discNumber: Int?
    public var trackCount: Int?
    public var trackNumber: Int?
    public var trackTimeMillis: Int?
    public var country: String?
    public var currency: String?
    public var primaryGenreName: String?
    public var isStreamable: Bool?
    
    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case wrapperType = "wrapperType"
        case kind = "kind"
        case artistId = "artistId"
        case collectionId = "collectionId"
        case trackId = "trackId"
        case artistName = "artistName"
        case collectionName = "collectionName"
        case trackName = "trackName"
        case collectionCensoredName = "collectionCensoredName"
        case trackCensoredName = "trackCensoredName"
        case artistViewUrl = "artistViewUrl"
        case collectionViewUrl = "collectionViewUrl"
        case trackViewUrl = "trackViewUrl"
        case previewUrl = "previewUrl"
        case artworkUrl30 = "artworkUrl30"
        case artworkUrl60 = "artworkUrl60"
        case artworkUrl100 = "artworkUrl100"
        case collectionPrice = "collectionPrice"
        case trackPrice = "trackPrice"
        case releaseDate = "releaseDate"
        case collectionExplicitness = "collectionExplicitness"
        case trackExplicitness = "trackExplicitness"
        case discCount = "discCount"
        case discNumber = "discNumber"
        case trackCount = "trackCount"
        case trackNumber = "trackNumber"
        case trackTimeMillis = "trackTimeMillis"
        case country = "country"
        case currency = "currency"
        case primaryGenreName = "primaryGenreName"
        case isStreamable = "isStreamable"
    }
}
