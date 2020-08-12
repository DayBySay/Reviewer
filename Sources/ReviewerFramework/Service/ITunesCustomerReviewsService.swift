//
//  ITunesCustomerReviewsService.swift
//  Reviewer
//
//  Created by Takayuki Sei on 2020/08/08.
//

import Foundation

class ITunesCustomerReviewsService {
    private let repository = ITunesCustomerReviewsRepository()

    func reviewesJSON(id: Int, page: Int, format: String, completion: ((Feed?, Error?) -> Void)?) {
        let parameter = ITunesCustomerReviewsAPIParameter(
            id: id,
            page: page,
            format: format,
            sortedBy: .mostRecent)
        repository.reviewesJSON(parameter: parameter, completion: completion)
    }

    func reviewesAllPagesJSON(id: Int, format: String, completion: (([Feed], Error?) -> Void)?) {
        var feeds: [Feed] = []
        for i in 1..<10 {
            if let feed = reviewsJSONAsyns(id: id, page: i, format: format) {
                feeds.append(feed)
            }
        }
        completion?(feeds, nil)
    }

    private func reviewsJSONAsyns(id: Int, page: Int, format: String) -> Feed? {
        var result: Feed?
        let parameter = ITunesCustomerReviewsAPIParameter(
            id: id,
            page: page,
            format: "xml",
            sortedBy: .mostRecent)
        let semaphore = DispatchSemaphore(value: 0)
        repository.reviewesJSON(parameter: parameter) { (feed, error) in
            result = feed
            semaphore.signal()
        }
        semaphore.wait()
        return result
    }
}
