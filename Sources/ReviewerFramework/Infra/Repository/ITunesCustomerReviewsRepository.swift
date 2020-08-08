//
//  ITunesCustomerReviewsRepository.swift
//  Reviewer
//
//  Created by Takayuki Sei on 2020/08/08.
//

import Foundation

class ITunesCustomerReviewsRepository {
    func reviewesJSON(completion: ((String?, Error?) -> Void)?) {
        let apiRequest = ITunesCustomerReviewsAPIRequest()
        let loader = APIRequestLoader(apiRequest: apiRequest)
        let parameter = ITunesCustomerReviewsAPIRequestParameter(id: 1404176564)
        loader.loadAPIRequest(requestData: parameter) { (feed, error) in
            if let error = error {
                completion?(nil, error)
                return
            }
            
            guard let feed = feed,
                let jsonData = try? JSONEncoder().encode(feed),
                let string = String(data: jsonData, encoding: .utf8) else {
                    completion?(nil, nil)
                    return
            }
            
            completion?(string, nil)
        }
    }
}
