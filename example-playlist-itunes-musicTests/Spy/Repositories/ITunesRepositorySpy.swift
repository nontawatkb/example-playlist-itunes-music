//
//  ITunesRepositorySpy.swift
//  example-playlist-itunes-musicTests
//
//  Created by Nontawat Kanboon on 23/7/2566 BE.
//

import Combine
import Moya
@testable import example_playlist_itunes_music

final class ITunesRepositorySpy: ITunesRepository {

    var invokedGetSearch = false
    var invokedGetSearchCount = 0
    var invokedGetSearchParameters: (request: SearchRequest, Void)?
    var invokedGetSearchParametersList = [(request: SearchRequest, Void)]()
    var stubbedGetSearchResult: AnyPublisher<SearchResponse?, MoyaError>!

    func getSearch(request: SearchRequest) -> AnyPublisher<SearchResponse?, MoyaError> {
        invokedGetSearch = true
        invokedGetSearchCount += 1
        invokedGetSearchParameters = (request, ())
        invokedGetSearchParametersList.append((request, ()))
        return stubbedGetSearchResult
    }
}

