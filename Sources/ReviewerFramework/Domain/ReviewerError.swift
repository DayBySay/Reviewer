//
//  ReviewerError.swift
//  ArgumentParser
//
//  Created by Takayuki Sei on 2020/08/09.
//

import Foundation

public enum ReviewerError: Error, LocalizedError {
    case unknown
    case encode
    
    public var errorDescription: String? {
        switch self {
        case .unknown:
            return "an unknown error occurred."
        case .encode:
            return "failed to make a JSON Strings."
        }
    }
}
