//
//  Generator.swift
//  Reviewer
//
//  Created by Takayuki Sei on 2020/08/08.
//

import Foundation

public func generate(id: Int, page: Int, format: String, completion: @escaping ((String) -> Void))
    throws
{
    guard let outputFormat = OutputFormat(rawValue: format.uppercased()) else {
        print("format \(format) is not supported.")
        exit(0)
    }

    let service = ITunesCustomerReviewsService()
    if page == -1 {
        service.reviewesAllPages(id: id) { (feeds, error) in
            guard let string = try? formatting(with: outputFormat, feeds: feeds) else {
                exit(0)
            }

            completion(string)
        }
    } else {
        service.reviewes(id: id, page: page) { (feed, error) in
            guard let feed = feed,
                let string = try? formatting(with: outputFormat, feeds: [feed])
            else {
                exit(0)
            }

            completion(string)
        }
    }
}

private enum OutputFormat: String {
    case json = "JSON"
    case csv = "CSV"
}

private func formatting(with format: OutputFormat, feeds: [Feed]) throws -> String? {
    switch format {
    case .json:
        let entries = feeds.flatMap { $0.entry }
        guard let jsonData = try? JSONEncoder().encode(entries),
            let string = String(data: jsonData, encoding: .utf8)
            else {
                return nil
        }
        return string
    case .csv:
        return try formatCSV(feeds: feeds)
    }
}

private func formatCSV(feeds: [Feed]) throws -> String? {
    guard !feeds.isEmpty else { return nil}
    let feedForHeader = feeds[0]
    let headers = try Array(feedForHeader.entry[0].allStringProperties().keys).sorted()
    var csvArray: [[String]] = [headers]
    try feeds.flatMap { $0.entry }
        .forEach { (entity) in
            var record = [String]()
            try headers.forEach { (key) in
                let entityProps = try entity.allStringProperties()
                var string = entityProps[key]!
                while(string.range(of: "\n") != nil) {
                    string = string.replacingCharacters(in: string.range(of: "\n")!, with: " ")
                }
                while(string.range(of: ",") != nil) {
                    string = string.replacingCharacters(in: string.range(of: ",")!, with: "、")
                }
                record.append(string)
            }
            csvArray.append(record)
        }

    var result = ""
    csvArray.forEach { (innerArray) in
        for i in innerArray {
            result += i
            if i == innerArray.last {
                result += "\n"
            } else {
                result += ","
            }
        }
    }
    return result
}
