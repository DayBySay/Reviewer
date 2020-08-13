//
//  ITunesCustomerReviewsService.swift
//  Reviewer
//
//  Created by Takayuki Sei on 2020/08/08.
//

import Foundation

class ITunesCustomerReviewsService {
    private let repository = ITunesCustomerReviewsRepository()

    func reviewes(id: Int, page: Int, completion: ((Feed?, Error?) -> Void)?) {
        let parameter = ITunesCustomerReviewsAPIParameter(
            id: id,
            page: page,
            format: "XML",
            sortedBy: .mostRecent)
        repository.reviewes(parameter: parameter, completion: completion)
    }

    func reviewesAllPages(id: Int, completion: (([Feed], Error?) -> Void)?) {
        var feeds: [Feed] = []
        for i in 1..<10 {
            if let feed = reviewsAsyns(id: id, page: i) {
                feeds.append(feed)
            }
        }
        completion?(feeds, nil)
    }

    private func reviewsAsyns(id: Int, page: Int) -> Feed? {
        var result: Feed?
        let parameter = ITunesCustomerReviewsAPIParameter(
            id: id,
            page: page,
            format: "xml",
            sortedBy: .mostRecent)
        let semaphore = DispatchSemaphore(value: 0)
        repository.reviewes(parameter: parameter) { (feed, error) in
            result = feed
            semaphore.signal()
        }
        semaphore.wait()
        return result
    }
}
