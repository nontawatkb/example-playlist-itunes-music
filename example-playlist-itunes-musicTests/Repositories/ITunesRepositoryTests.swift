//
//  ITunesRepositoryTests.swift
//  example-playlist-itunes-musicTests
//
//  Created by Nontawat Kanboon on 23/7/2566 BE.
//

import Combine
import Moya
@testable import example_playlist_itunes_music
import XCTest

class ITunesRepositoryTests: XCTestCase {
    var anyCancellable: Set<AnyCancellable> = .init()
    private var repository: ITunesRepositoryImpl?
    private var response: SearchResponse?

    override func setUp() {
        super.setUp()
        repository = ITunesRepositoryImpl(provider: MoyaProvider<ITunesAPI>(stubClosure: MoyaProvider.immediatelyStub))
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func test_GetSearch_ShouldSuccess() {
        // Given
        var response: SearchResponse?
        let request = SearchRequest(term: "Test",
                                    limit: 100,
                                    country: "th",
                                    media: "music")
        
        // When
        repository?.getSearch(request: request)
            .sink { status in
                // Then
                switch status {
                case .failure:
                    XCTFail()
                case .finished:
                    XCTAssertNotNil(response)
                }
            } receiveValue: { value in
                response = value
            }
            .store(in: &anyCancellable)
    }
}

