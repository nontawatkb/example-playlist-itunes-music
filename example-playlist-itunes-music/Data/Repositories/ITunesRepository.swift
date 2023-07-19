//
//  ITunesRepository.swift
//  example-playlist-itunes-music
//
//  Created by Nontawat Kanboon on 20/7/2566 BE.
//

import Combine
import Moya

protocol ITunesRepository {
    func getSearch(request: SearchRequest) -> AnyPublisher<SearchResponse?, MoyaError>
}

final class ITunesRepositoryImpl: ITunesRepository {
    
    private let provider: MoyaProvider<ITunesAPI> = MoyaProvider<ITunesAPI>()

    func getSearch(request: SearchRequest) -> AnyPublisher<SearchResponse?, MoyaError> {
        return self.provider.requestPublisher(.getSearch(request: request))
            .map(SearchResponse?.self)
    }
}
