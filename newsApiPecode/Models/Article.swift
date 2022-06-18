//
//  Article.swift
//  newsApiPecode
//
//  Created by Oleksiy Humenyuk on 14.06.2022.
//

import Foundation

struct Articles: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [Article]
}

struct Article: Codable {
    let author: String?
    let description: String?
    let content: String?
    let publishedAt: String?
    let source: Source
    let title: String
    let url: String
    let urlToImage: String?
}

struct Source: Codable {
    let name: String?
    let country: String?
    let category: String?
    let url: String?
    let id: String?
}
