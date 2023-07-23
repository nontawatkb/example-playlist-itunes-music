//
//  SearchViewModelTests.swift
//  example-playlist-itunes-musicTests
//
//  Created by Nontawat Kanboon on 23/7/2566 BE.
//

import Combine
import Moya
@testable import example_playlist_itunes_music
import XCTest

final class SearchViewModelTests: XCTestCase {
    private var sut: SearchViewModel?
    private var getSearchUseCaseSpy: GetSearchUseCaseSpy!
    
    override func setUp() {
        super.setUp()
        getSearchUseCaseSpy = GetSearchUseCaseSpy()
        sut = SearchViewModel(viewController: UIViewController(),
                              getSearchUseCase: getSearchUseCaseSpy)
    }

    func test_InitializeSearchViewModel_ShouldReturnSuccess() {
        // Given
        sut = nil
        
        // When
        sut = SearchViewModel(viewController: UIViewController())
        
        // Then
        XCTAssertNotNil(sut)
    }
    
    func test_GetSearch_SearchTextIsNil_ShouldReturnListSearchResultsEmpty() {
        // Given
        getSearchUseCaseSpy = GetSearchUseCaseSpy()
        sut = SearchViewModel(viewController: UIViewController(),
                              getSearchUseCase: getSearchUseCaseSpy)
        
        // When
        sut?.input.getSearch(text: nil)
        
        // Then
        XCTAssertEqual(sut?.output.getCountSearchResults(), 0)
        XCTAssertEqual(getSearchUseCaseSpy.invokedExecuteCount, 0)
        XCTAssertFalse(getSearchUseCaseSpy.invokedExecute)
    }
    
    func test_GetSearch_SearchTextIsNotNilAndIsFail_ShouldReturnListSearchResultsEmpty() {
        // Given
        let errorResponse = Response(statusCode: 401, data: Data(), request: nil, response: nil)
        getSearchUseCaseSpy = GetSearchUseCaseSpy()
        getSearchUseCaseSpy.stubbedExecuteResult = Fail(error: MoyaError.jsonMapping(errorResponse)).eraseToAnyPublisher()
        sut = SearchViewModel(viewController: UIViewController(),
                              getSearchUseCase: getSearchUseCaseSpy)
        
        // When
        sut?.input.getSearch(text: "Taylor Swift")
        
        // Then
        XCTAssertEqual(sut?.output.getCountSearchResults(), 0)
        XCTAssertEqual(getSearchUseCaseSpy.invokedExecuteCount, 1)
        XCTAssertTrue(getSearchUseCaseSpy.invokedExecute)
    }
    
    func test_GetSearch_SearchTextIsNotNilAndIsFail_ShouldReturnListSearchResultsNotEmpty() {
        // Given
        let mockItemSearch = SearchItem()
        var mockSearchResponse = SearchResponse()
        mockSearchResponse.results = [mockItemSearch]
        getSearchUseCaseSpy = GetSearchUseCaseSpy()
        getSearchUseCaseSpy.stubbedExecuteResult = Just(mockSearchResponse).setFailureType(to: MoyaError.self).eraseToAnyPublisher()
        sut = SearchViewModel(viewController: UIViewController(),
                              getSearchUseCase: getSearchUseCaseSpy)
        
        // When
        sut?.input.getSearch(text: "Taylor Swift")
        
        // Then
        XCTAssertEqual(sut?.output.getCountSearchResults(), 1)
        XCTAssertEqual(getSearchUseCaseSpy.invokedExecuteCount, 1)
        XCTAssertTrue(getSearchUseCaseSpy.invokedExecute)
    }
    
    func test_GetNumberOfSections_IsReturn2_ShouldReturn2Success() {
        // Given
        let collectionView: UICollectionView = .init(frame: CGRect(), collectionViewLayout: UICollectionViewLayout())
        
        // When
        let numberOfSections = sut?.output.getNumberOfSections(collectionView)
        
        // Then
        XCTAssertEqual(numberOfSections, 2)
    }
    
    func test_GetNumberOfRowsInSection_Section0AndListSearchResultsIsEmpty_ShouldReturn0Success() {
        // Given
        let collectionView: UICollectionView = .init(frame: CGRect(), collectionViewLayout: UICollectionViewLayout())
        
        // When
        let numberOfRowsInSection = sut?.output.getNumberOfRowsInSection(collectionView, numberOfItemsInSection: 0)
        
        // Then
        XCTAssertEqual(numberOfRowsInSection, 0)
    }
    
    func test_GetNumberOfRowsInSection_Section0AndListSearchResultsIs1_ShouldReturn1Success() {
        // Given
        let collectionView: UICollectionView = .init(frame: CGRect(), collectionViewLayout: UICollectionViewLayout())
        getSearchUseCaseSpy = GetSearchUseCaseSpy()
        let mockItemSearch = SearchItem()
        var mockSearchResponse = SearchResponse()
        mockSearchResponse.results = [mockItemSearch]
        getSearchUseCaseSpy.stubbedExecuteResult = Just(mockSearchResponse).setFailureType(to: MoyaError.self).eraseToAnyPublisher()
        sut = SearchViewModel(viewController: UIViewController(),
                              getSearchUseCase: getSearchUseCaseSpy)
        sut?.getSearch(text: "Taylor Swift")
        
        // When
        let numberOfRowsInSection = sut?.output.getNumberOfRowsInSection(collectionView, numberOfItemsInSection: 0)
        
        // Then
        XCTAssertEqual(numberOfRowsInSection, 1)
    }
    
    func test_GetNumberOfRowsInSection_Section1AndListSearchResultsIsEmpty_ShouldReturn0Success() {
        // Given
        let collectionView: UICollectionView = .init(frame: CGRect(), collectionViewLayout: UICollectionViewLayout())
        
        // When
        let numberOfRowsInSection = sut?.output.getNumberOfRowsInSection(collectionView, numberOfItemsInSection: 1)
        
        // Then
        XCTAssertEqual(numberOfRowsInSection, 0)
    }
    
    func test_GetCellForRowAt_Section0_ShouldReturnResultSearchCollectionViewCellSuccess() {
        // Given
        let collectionView: UICollectionView = .init(frame: CGRect(), collectionViewLayout: UICollectionViewLayout())
        collectionView.register(ResultSearchCollectionViewCell.self, forCellWithReuseIdentifier: ResultSearchCollectionViewCell.identifier)
        collectionView.register(PlaylistItemCollectionViewCell.self, forCellWithReuseIdentifier: PlaylistItemCollectionViewCell.identifier)
        
        // When
        let cellForRowAt = sut?.output.getCellForRowAt(collectionView, cellForItemAt: IndexPath(item: 0, section: 0)) as? ResultSearchCollectionViewCell
        
        // Then
        XCTAssertNotNil(cellForRowAt)
    }
    
    func test_GetCellForRowAt_Section0_ShouldReturnPlaylistItemCollectionViewCellSuccess() {
        // Given
        getSearchUseCaseSpy = GetSearchUseCaseSpy()
        let mockItemSearch = SearchItem()
        var mockSearchResponse = SearchResponse()
        mockSearchResponse.results = [mockItemSearch]
        getSearchUseCaseSpy.stubbedExecuteResult = Just(mockSearchResponse).setFailureType(to: MoyaError.self).eraseToAnyPublisher()
        sut = SearchViewModel(viewController: UIViewController(),
                              getSearchUseCase: getSearchUseCaseSpy)
        sut?.getSearch(text: "Taylor Swift")
        
        let collectionView: UICollectionView = .init(frame: CGRect(), collectionViewLayout: UICollectionViewLayout())
        collectionView.register(ResultSearchCollectionViewCell.self, forCellWithReuseIdentifier: ResultSearchCollectionViewCell.identifier)
        collectionView.register(PlaylistItemCollectionViewCell.self, forCellWithReuseIdentifier: PlaylistItemCollectionViewCell.identifier)
        
        // When
        let cellForRowAt = sut?.output.getCellForRowAt(collectionView, cellForItemAt: IndexPath(item: 0, section: 1)) as? PlaylistItemCollectionViewCell
        
        // Then
        XCTAssertNotNil(cellForRowAt)
    }
    
    func test_GetSizeForItemAt_Section0_ShouldReturnSizeForItemAtSuccess() {
        // Given
        let layout: UICollectionViewLayout = .init()
        let collectionView: UICollectionView = .init(frame: CGRect(), collectionViewLayout: layout)
        
        // When
        let sizeForItemAt = sut?.output.getSizeForItemAt(collectionView, layout: layout, sizeForItemAt: IndexPath(item: 0, section: 0))
        
        // Then
        XCTAssertEqual(sizeForItemAt, CGSize(width: -16, height: 45))
    }
    
    func test_GetSizeForItemAt_Section1_ShouldReturnSizeForItemAtSuccess() {
        // Given
        let layout: UICollectionViewLayout = .init()
        let collectionView: UICollectionView = .init(frame: CGRect(), collectionViewLayout: layout)
        
        // When
        let sizeForItemAt = sut?.output.getSizeForItemAt(collectionView, layout: layout, sizeForItemAt: IndexPath(item: 0, section: 1))
        
        // Then
        XCTAssertEqual(sizeForItemAt, CGSize(width: -12, height: -12))
    }
}

