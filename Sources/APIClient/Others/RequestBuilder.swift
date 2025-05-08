//
//  File.swift
//  
//
//  Created by Jiguar on 29/03/25.
//

import Foundation


public protocol RequestBuilderType {
    func buildRequest(from route:EndPointType) throws -> URLRequest
}

public struct RequestBuilder<EndPoint: EndPointType> {
    
    public  func buildRequest(from route:EndPoint) throws -> URLRequest {
        guard let baseUrl = URL(string: route.domainName + route.path) else {
            throw NetworkError.missingURL
        }
        
        var request = URLRequest(url: baseUrl, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: route.timeOutInterval)
        
        request.httpMethod = route.httpMethod.rawValue
        
        do {
            switch route.task {
            case .request:
                request.setValue(ContentType.json.rawValue, forHTTPHeaderField: .contentType)
            case .requestParameters(let bodyParameters):
                try configureParameters(paramType: bodyParameters, request: &request)
            case .requestParametersAndHeaders(let bodyParameters, let additionalHeaders):
                try configureParameters(paramType: bodyParameters, request: &request)
                self.addAdditionalHeaders(additionalHeaders, request: &request)
            case .uploadMultiformDataRequest:
                print("need to implement this cases")
            }
            return request
        } catch {
            throw error
        }
    }
    
    func addAdditionalHeaders(_ additionalHeaders: [String: String]?, request: inout URLRequest) {

        guard let headers = additionalHeaders else {
            return
        }
               
        for(key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    fileprivate func configureParameters(paramType: ParamType, request:inout URLRequest) throws {
        
        do {
            switch paramType {
            case .encodable(let model):
                let jsonData = try JSONEncoder().encode(model)
                request.httpBody = jsonData
                request.setValue(ContentType.json.rawValue, forHTTPHeaderField: .contentType)
            case .json(let model):
                try JSONParameterEncoding.encode(urlRequest: &request, with: model)
            case .urlParam(model: let model):
                try URLParameterEncoder.encode(urlRequest: &request, with: model)
            }
        } catch {
            throw error
        }
    }
    
    
}
