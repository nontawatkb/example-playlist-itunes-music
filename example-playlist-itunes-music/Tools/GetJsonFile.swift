//
//  GetJsonFile.swift
//  example-playlist-itunes-music
//
//  Created by Nontawat Kanboon on 23/7/2566 BE.
//

import Foundation

public struct GetJsonFile {
    public static var shared = GetJsonFile()
    public var bundleId: String = "com-test.example-playlist-itunes-musicTests"

    public init() {}

    public func readLocalFile(forName name: String) -> Data {
        do {
            if let bundlePath = Bundle(identifier: bundleId)?.path(forResource: name,
                                                                   ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print("Fail to get json file")
        }
        return Data()
    }
}
