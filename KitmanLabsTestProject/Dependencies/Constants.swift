//
//  Constants.swift
//  Kitman Labs Test Project
//
//  Created by Robert Mccahill on 13/05/2025.
//

import Foundation

class Constants {
    static let baseURL = URL(string: "https://kml-tech-test.glitch.me")!
    static let snakeCaseJSONDecoder: JSONDecoder = {
        var decoder = JSONDecoder()
        
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return decoder
    }()
}
