//
//  ITunesCustomerReviewsAPI.swift
//  Reviewer
//
//  Created by Takayuki Sei on 2020/08/08.
//

import Foundation

struct ITunesCustomerReviewsAPIRequestParameter {
    let path: String = "https://itunes.apple.com/jp/rss/customerreviews/"
    let id: Int
    let page: Int
    let format: Format
    let sortedBy: SortedBy
    
    init(id: Int, page: Int = 1, format: Format = .json, sortedBy: SortedBy = .mostRecent) {
        self.id = id
        self.page = page
        self.format = format
        self.sortedBy = sortedBy
    }
    
    enum Format {
        case json
    }
    
    enum SortedBy {
        case mostRecent
    }
    
    func makeURL() -> URL {
        return URL(string: "\(path)/id=\(id)/sortBy=\(sortedBy)/page=\(page)/\(format)")!
    }
}

struct ITunesCustomerReviewsAPIRequest: APIRequest {
    typealias RequestDataType = ITunesCustomerReviewsAPIRequestParameter
    typealias ResponseDataType = Feed
    
    init() {}
    
    func makeRequest(from data: ITunesCustomerReviewsAPIRequestParameter) throws -> URLRequest {
        return URLRequest(url: data.makeURL())
    }
    
    func parseResponse(data: Data) throws -> Feed {
        return try JSONDecoder().decode(Feed.self, from: data)
    }
}
