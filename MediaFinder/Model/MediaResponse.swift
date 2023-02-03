//
//  MediaResponse.swift
//  MediaFinder
//
//  Created by Karim Mohamed on 16/01/2023.
//

import Foundation


// MARK:- MediaResponse
struct MediaResponse: Codable {
    var resultCount: Int!
    var results: [Media]!
}

// MARK:- Media
struct Media: Codable {
    var artistName: String?
    var trackName: String?
    var artworkUrl: String!
    var longDescription: String?
    var previewUrl: String!
    
    enum CodingKeys: String, CodingKey {
        case artistName, trackName, longDescription, previewUrl
        case artworkUrl = "artworkUrl100"
    }
}
