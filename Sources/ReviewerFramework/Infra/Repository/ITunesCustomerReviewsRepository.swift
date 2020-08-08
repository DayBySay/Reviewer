//
//  ITunesCustomerReviewsRepository.swift
//  Reviewer
//
//  Created by Takayuki Sei on 2020/08/08.
//

import Foundation

class ITunesCustomerReviewsRepository {
  func reviewesJSON(
    parameter: ITunesCustomerReviewsAPIParameter, completion: ((Feed?, Error?) -> Void)?
  ) {
    let apiRequest = ITunesCustomerReviewsAPIRequest()
    let loader = APIRequestLoader(apiRequest: apiRequest)
    let parameter = ITunesCustomerReviewsAPIRequestParameter(parameter: parameter)
    loader.loadAPIRequest(requestData: parameter) { (feed, error) in
      if let error = error {
        completion?(nil, error)
        return
      }

      guard let feed = feed else {
        completion?(nil, nil)
        return
      }

      completion?(feed, nil)
    }
  }
}
