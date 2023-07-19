//
//  GetSearchUseCase.swift
//  example-playlist-itunes-music
//
//  Created by Nontawat Kanboon on 20/7/2566 BE.
//

import Combine
import Foundation
import Moya

protocol GetSearchUseCase {
    func execute(term: String) -> AnyPublisher<SearchResponse?, MoyaError>
}

class GetSearchUseCaseImpl: GetSearchUseCase {
    
    private let repository: ITunesRepository
    
    init(repository: ITunesRepository = ITunesRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute(term: String) -> AnyPublisher<SearchResponse?, MoyaError>{
        let request = SearchRequest(term: term,
                                    limit: 100,
                                    country: "th",
                                    media: "music")
        return repository.getSearch(request: request)
    }
}
