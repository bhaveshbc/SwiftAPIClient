//
//  File.swift
//  
//
//  Created by Jiguar on 29/03/25.
//

import Foundation

public enum ParamType {
    case encodable(model: Encodable)
    case json(model: [String: Any])
    case urlParam(model: [String: Any])
}
