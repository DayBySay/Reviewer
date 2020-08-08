//
//  ITunesCustomerReviewsAPIParameter.swift
//  ArgumentParser
//
//  Created by Takayuki Sei on 2020/08/08.
//

import Foundation

struct ITunesCustomerReviewsAPIParameter {
    let id: Int
    let page: Int
    let format: Format
    let sortedBy: SortedBy

    init(
        id: Int, page: Int, format: String = Format.json.rawValue, sortedBy: SortedBy = .mostRecent
    ) {
        self.id = id
        self.page = page
        self.format = Format.init(rawValue: format) ?? .json
        self.sortedBy = sortedBy
    }

    enum Format: String {
        case json = "JSON"
        case xml = "XML"
    }

    enum SortedBy {
        case mostRecent
    }
}
