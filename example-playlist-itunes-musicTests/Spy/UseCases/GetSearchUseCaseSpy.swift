//
//  GetSearchUseCaseSpy.swift
//  example-playlist-itunes-musicTests
//
//  Created by Nontawat Kanboon on 23/7/2566 BE.
//

import Combine
import Moya
@testable import example_playlist_itunes_music

final class GetSearchUseCaseSpy: GetSearchUseCase {
    var invokedExecute = false
    var invokedExecuteCount = 0
    var invokedExecuteParameters: (term: String, Void)?
    var invokedExecuteParametersList = [(term: String, Void)]()
    var stubbedExecuteResult: AnyPublisher<SearchResponse?, MoyaError>!

    func execute(term: String) -> AnyPublisher<SearchResponse?, MoyaError> {
        invokedExecute = true
        invokedExecuteCount += 1
        invokedExecuteParameters = (term, ())
        invokedExecuteParametersList.append((term, ()))
        return stubbedExecuteResult
    }
}

