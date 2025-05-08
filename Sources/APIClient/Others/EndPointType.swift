//
//  File.swift
//  
//
//  Created by Jiguar on 29/03/25.
//

import Foundation

public protocol EndPointType {
    var domainName: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: [String: Any]? { get }
    var timeOutInterval: TimeInterval { get }
}

extension EndPointType {
    public var domainName: String {
        return ""
    }
}

extension EndPointType {
    public var timeOutInterval: TimeInterval {
        return 30
    }
}

extension EndPointType {
    public var headers: [String: Any]? {
        return nil
    }
}
