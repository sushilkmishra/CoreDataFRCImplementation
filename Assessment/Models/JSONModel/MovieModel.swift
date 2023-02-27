//
//  MovieModel.swift
//  Assessment
//
//  Created by Sushil K Mishra on 15/02/23.
//

import Foundation

struct MovieModel: Codable {
    let rating: Float
    let id: Int
    let revenue: Int32?
    let releaseDate: String
    let director: DirectorData
    let posterUrl: String
    let cast: [CastData]
    let runtime: Int
    let title: String
    let overview: String
    let reviews: Int
    let budget: Int32
    let language: String
    let genres: [String]
    
    enum CodingKeys: String, CodingKey {
        case rating
        case id
        case revenue
        case releaseDate
        case director
        case posterUrl
        case cast
        case runtime
        case title
        case overview
        case reviews
        case budget
        case language
        case genres
    }
}

struct DirectorData: Codable {
    let name: String
    let pictureUrl: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case pictureUrl
    }
}

struct CastData: Codable {
    let name: String
    let pictureUrl: String
    let character: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case pictureUrl
        case character
    }
}

