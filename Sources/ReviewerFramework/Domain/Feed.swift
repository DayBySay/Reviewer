//
//  Feed.swift
//  Reviewer
//
//  Created by Takayuki Sei on 2020/08/08.
//

import Foundation

struct Feed: Codable, Equatable {
    let entry: [Entry]
    
    private enum CodingKeys: String, CodingKey {
        case feed
        case entry
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        entry = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .feed)
            .decode([Entry].self, forKey: .entry)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(entry, forKey: .entry)
    }
}

struct Entry: Codable, Equatable {
    let name: String
    let rating: String
    let title: String
    let content: String
    let version: String
    let uri: URL?
    let link: URL?

    private enum CodingKeys: String, CodingKey {
        case author
        case uri
        case label
        case name
        case version = "im:version"
        case rating = "im:rating"
        case title
        case content
        case link
        case attributes
        case href
    }

    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let uriString = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .author)
            .nestedContainer(keyedBy: CodingKeys.self, forKey: .uri)
            .decode(String.self, forKey: .label)
        uri = URL(string: uriString)
        
        rating = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .rating)
            .decode(String.self, forKey: .label)
        
        title = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .title)
            .decode(String.self, forKey: .label)
        
        content = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .content)
            .decode(String.self, forKey: .label)
        
        name = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .author)
        .nestedContainer(keyedBy: CodingKeys.self, forKey: .name)
        .decode(String.self, forKey: .label)
        
        version = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .version)
                   .decode(String.self, forKey: .label)
        
        let linkString = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .link)
            .nestedContainer(keyedBy: CodingKeys.self, forKey: .attributes)
            .decode(String.self, forKey: .href)
        link = URL(string: linkString)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(rating, forKey: .rating)
        try container.encode(title, forKey: .title)
        try container.encode(version, forKey: .version)
        try container.encode(content, forKey: .content)
        try container.encode(uri, forKey: .uri)
        try container.encode(link, forKey: .link)
    }
}
