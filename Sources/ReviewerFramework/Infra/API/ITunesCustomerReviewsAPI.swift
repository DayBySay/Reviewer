//
//  ITunesCustomerReviewsAPI.swift
//  Reviewer
//
//  Created by Takayuki Sei on 2020/08/08.
//

import Foundation
import SwiftyXMLParser

struct ITunesCustomerReviewsAPIRequestParameter {
    let path: String = "https://itunes.apple.com/jp/rss/customerreviews/"
    let parameter: ITunesCustomerReviewsAPIParameter

    init(parameter: ITunesCustomerReviewsAPIParameter) {
        self.parameter = parameter
    }

    func makeURL() -> URL {
        return URL(
            string:
                "\(path)/id=\(parameter.id)/sortBy=\(parameter.sortedBy)/page=\(parameter.page)/\(parameter.format)"
        )!
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
        do {
            return try JSONDecoder().decode(Feed.self, from: data)
        } catch {
            let parser = XML.parse(data)
            let entries = parser["feed"]["entry"].map { (accessor) in
                Entry.parseXML(accessor: accessor)
            }
            let feed = Feed(entry: entries)
            return feed
        }
    }
}
