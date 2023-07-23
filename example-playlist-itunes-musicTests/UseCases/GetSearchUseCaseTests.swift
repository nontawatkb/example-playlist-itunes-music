//
//  GetSearchUseCaseTests.swift
//  example-playlist-itunes-musicTests
//
//  Created by Nontawat Kanboon on 23/7/2566 BE.
//

import Combine
import Moya
@testable import example_playlist_itunes_music
import XCTest

class GetSearchUseCaseTests: XCTestCase {
    
    private var sut: GetSearchUseCase!
    private var anyCancellable: Set<AnyCancellable> = .init()
    private var searchResponse: SearchResponse?

    override func setUp() {
        super.setUp()
        sut = GetSearchUseCaseImpl()
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_Execute_ExecuteIsFail_ShouldReturnResponseNil() {
        // Given
        let errorResponse = Response(statusCode: 401, data: Data(), request: nil, response: nil)
        let iTunesRepositorySpy = ITunesRepositorySpy()
        iTunesRepositorySpy.stubbedGetSearchResult = Fail(error: MoyaError.jsonMapping(errorResponse)).eraseToAnyPublisher()
        sut = GetSearchUseCaseImpl(repository: iTunesRepositorySpy)
      
        // When
        sut.execute(term: "Taylor Swift").sink { completion in
            // Then
            XCTAssertEqual(iTunesRepositorySpy.invokedGetSearchCount, 1)
            XCTAssertTrue(iTunesRepositorySpy.invokedGetSearch)
            XCTAssertNil(self.searchResponse)
        } receiveValue: { resp in
            self.searchResponse = resp
        }.store(in: &anyCancellable)
    }
    
    func test_Execute_ExecuteIsSuccess_ShouldReturnResponseNotNil() {
        // Given
        let iTunesRepositorySpy = ITunesRepositorySpy()
        iTunesRepositorySpy.stubbedGetSearchResult = Just(SearchResponse()).setFailureType(to: MoyaError.self).eraseToAnyPublisher()
        sut = GetSearchUseCaseImpl(repository: iTunesRepositorySpy)
      
        // When
        sut.execute(term: "Taylor Swift").sink { completion in
            // Then
            XCTAssertEqual(iTunesRepositorySpy.invokedGetSearchCount, 1)
            XCTAssertTrue(iTunesRepositorySpy.invokedGetSearch)
            XCTAssertNotNil(self.searchResponse)
        } receiveValue: { resp in
            self.searchResponse = resp
        }.store(in: &anyCancellable)
    }

}
