//
//  Generator.swift
//  Reviewer
//
//  Created by Takayuki Sei on 2020/08/08.
//

import Foundation

public func generate(id: Int, page: Int, format: String, completion: @escaping ((String) -> Void)) throws {
    let service = ITunesCustomerReviewsService()
    if page == -1 {
        service.reviewesAllPagesJSON(id: id, format: format) { (feeds, error) in
            let entries = feeds.flatMap { $0.entry }
            guard let jsonData = try? JSONEncoder().encode(entries),
                let string = String(data: jsonData, encoding: .utf8) else {
                    exit(0)
            }
            
            completion(string)
        }
    } else {
        service.reviewesJSON(id: id, page: page, format: format) { (feed, error) in
            guard let feed = feed,
                let jsonData = try? JSONEncoder().encode(feed),
                let string = String(data: jsonData, encoding: .utf8) else {
                    exit(0)
            }
            
            completion(string)
        }
    }
}
