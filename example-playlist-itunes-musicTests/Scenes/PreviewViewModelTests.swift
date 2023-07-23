//
//  PreviewViewModelTests.swift
//  example-playlist-itunes-musicTests
//
//  Created by Nontawat Kanboon on 23/7/2566 BE.
//

//import Combine
//import Moya
@testable import example_playlist_itunes_music
import XCTest

final class PreviewViewModelTests: XCTestCase {
    private var sut: PreviewViewModel?
    
    override func setUp() {
        super.setUp()
        sut = PreviewViewModel(searchItem: nil)
    }
    
    func test_InitializePreviewViewModel_ShouldReturnSuccess() {
        // Given
        sut = nil
        
        // When
        sut = PreviewViewModel(searchItem: nil)
        
        // Then
        XCTAssertNotNil(sut)
    }
    
    func test_DownloadPreviewUrl_SearchItemIsNil_ShouldReturnPreviewUrlNil() {
        // Given
        sut = PreviewViewModel(searchItem: nil)
        
        // When
        sut?.downloadPreviewUrl()
        
        // Then
        XCTAssertNil(sut?.previewURL)
        XCTAssertNil(sut?.previewItem)
    }
}


