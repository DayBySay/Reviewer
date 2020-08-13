//
//  PropertyLoopable.swift
//  esara
//
//  Created by Takayuki Sei on 2020/08/10.
//

import Foundation

protocol Loopable {
    func allProperties() throws -> [String: Any]
    func allStringProperties() throws -> [String: String]
}

extension Loopable {
    func allProperties() throws -> [String: Any] {

        var result: [String: Any] = [:]

        let mirror = Mirror(reflecting: self)

        // Optional check to make sure we're iterating over a struct or class
        guard let style = mirror.displayStyle, style == .struct || style == .class else {
            throw NSError()
        }

        for (property, value) in mirror.children {
            guard let property = property else {
                continue
            }

            result[property] = value
        }

        return result
    }
    
    func allStringProperties() throws -> [String: String] {
        var result: [String: String] = [:]
        
        let mirror = Mirror(reflecting: self)
        
        // Optional check to make sure we're iterating over a struct or class
        guard let style = mirror.displayStyle, style == .struct || style == .class else {
            throw NSError()
        }
        
        for (property, value) in mirror.children {
            guard let property = property, let value = value as? CustomStringConvertible else {
                continue
            }
            
            result[property] = value.description
        }
        
        return result
    }
}

