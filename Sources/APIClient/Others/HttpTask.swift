//
//  File.swift
//  
//
//  Created by Jiguar on 29/03/25.
//

import Foundation

public enum HTTPTask {
    case request
    case requestParameters(bodyParameters: ParamType)
    case requestParametersAndHeaders(bodyParameters:ParamType,additionalHeaders:[String: String]?)
    case uploadMultiformDataRequest(data:Data,additionalHeaders:[String: String]?)
}
