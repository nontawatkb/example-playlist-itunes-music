//
//  ITunesAPI.swift
//  example-playlist-itunes-music
//
//  Created by Nontawat Kanboon on 20/7/2566 BE.
//

import Foundation
import Moya
import UIKit

public enum ITunesAPI {
    case getSearch(request: SearchRequest)
}

extension ITunesAPI: TargetType {
    public var baseURL: URL {
        switch self {
        default:
            return URL(string: "https://itunes.apple.com")!
        }
    }

    public var path: String {
        switch self {
        case .getSearch:
            return "/search"
        }
    }

    public var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }

    public var sampleData: Data {
        switch self {
        case .getSearch:
            return GetJsonFile.shared.readLocalFile(forName: "SearchResponse")
        }
    }

    public var task: Task {
        switch self {
        case let .getSearch(request):
            return .requestParameters(parameters: request.toJSON(), encoding: URLEncoding.queryString)
        }
    }
    
    public var headers: [String : String]? { return nil }

}

