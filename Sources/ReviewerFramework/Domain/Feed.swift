//
//  Feed.swift
//  Reviewer
//
//  Created by Takayuki Sei on 2020/08/08.
//

import Foundation
import SwiftyXMLParser

struct Feed: Codable, Equatable {
    let entry: [Entry]

    private enum CodingKeys: String, CodingKey {
        case feed
        case entry
    }
    
    init(entry: [Entry]) {
        self.entry = entry
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
    let updated: Date?


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
        case updated
    }
    
    init(name: String, rating: String, title: String, content: String, version: String, uri: URL?, link: URL?, updated: Date?) {
        self.name = name
        self.rating = rating
        self.title = title
        self.content = content
        self.version = version
        self.uri = uri
        self.link = link
        self.updated = updated
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
        
        updated = nil
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
        
        if #available(OSX 10.12, *) {
            let formatter = ISO8601DateFormatter()
            try container.encode(formatter.string(from: updated!), forKey: .updated)
        }
    }
    
    static func parseXML(accessor: XML.Accessor) -> Entry {
        var updated: Date?
        if #available(OSX 10.12, *) {
            let dateString = accessor["updated"].text!
            let formatter = ISO8601DateFormatter()
            updated = formatter.date(from: dateString)
        }

        return Entry(name: accessor["author"]["name"].text!,
                     rating: accessor["im:rating"].text!,
                     title: accessor["title"].text!,
                     content: accessor["content"][0].text!,
                     version: accessor["im:version"].text!,
                     uri: URL(string: accessor["author"]["uri"].text!),
                     link: URL(string: accessor["link"].attributes["href"]!),
                     updated: updated)
    }
}


extension Entry: Loopable {
    func allStringProperties() throws -> [String : String] {
        var result: [String: String] = [:]
        
        let mirror = Mirror(reflecting: self)
        
        // Optional check to make sure we're iterating over a struct or class
        guard let style = mirror.displayStyle, style == .struct || style == .class else {
            throw NSError()
        }
        
        for (property, value) in mirror.children {
            guard let property = property else {
                continue
            }
            
            var v: Any = value
            let mirror = Mirror(reflecting: value)
            if mirror.displayStyle == .optional {
                v = mirror.children.first!.value
            }

            if let v = v as? CustomStringConvertible  {
                result[property] = v.description
            }
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        result["updated"] = formatter.string(from: updated!)
        
        return result
    }
}
