//
//  File.swift
//  
//
//  Created by Jiguar on 29/03/25.
//

import Foundation

public protocol ParameterEncoder {
    static func encode(urlRequest:inout URLRequest, with parameters:[String: Any]) throws
}


public struct JSONParameterEncoding: ParameterEncoder {
    public static func encode(urlRequest: inout URLRequest, with parameters: [String: Any]) throws {
        do
        {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonData
            if urlRequest.value(forHTTPHeaderField: .contentType) == nil
            {
                urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: .contentType)
            }
        }catch
        {
            throw NetworkError.encodingFailed
        }
    }
}

public struct URLParameterEncoder: ParameterEncoder{
    
    public static func encode(urlRequest: inout URLRequest, with parameters: [String: Any]) throws {
        
        guard let url = urlRequest.url else { throw NetworkError.missingURL}
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty{
            
            for (key,value) in parameters{
                let queryItem = URLQueryItem(name: key, value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                urlComponents.queryItems?.append(queryItem)

            }
            
            urlRequest.url = urlComponents.url
        }
        
        if urlRequest.value(forHTTPHeaderField: .contentType) == nil{
            urlRequest.setValue(ContentType.urlEncoded.rawValue, forHTTPHeaderField: .contentType)
        }
    }
}
