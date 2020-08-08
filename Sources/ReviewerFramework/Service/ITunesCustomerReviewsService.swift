//
//  ITunesCustomerReviewsService.swift
//  Reviewer
//
//  Created by Takayuki Sei on 2020/08/08.
//

import Foundation

public class ITunesCustomerReviewsService {
    private let repository = ITunesCustomerReviewsRepository()
    public init() {}
    public func reviewesJSON(completion: ((String?, Error?) -> Void)?) {
        repository.reviewesJSON(completion: completion)
    }
}
