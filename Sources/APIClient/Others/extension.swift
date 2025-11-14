//
//  File.swift
//  
//
//  Created by Jiguar on 29/03/25.
//

import Foundation

enum ContentType: String {
    case json = "application/json"
    case urlEncoded = "application/x-www-form-urlencoded; charset=utf-8"
}

extension String {
    static let authorize = "Authorization"
    static let contentType = "Content-Type"
}

extension URLRequest {
   public var curl: String {
        self.cURL
    }
}
