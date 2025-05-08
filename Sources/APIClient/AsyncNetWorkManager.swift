
//
//  File.swift
//
//
//  Created by Jiguar on 29/03/25.

import Foundation

public protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> SessionResponseType
}

extension URLSession: URLSessionProtocol {}
public typealias SessionResponseType = (Data, URLResponse)

public protocol Networkable: AnyObject {
    associatedtype EndPoint: EndPointType
    func request<T: Decodable>(apiRouter: EndPoint) async throws -> T
    func request(apiRouter: EndPoint) async throws -> [String: Any]?
}

public class NetWorkClient<EndPoint: EndPointType>: Networkable {
    
    public let session: URLSessionProtocol
    public let requestBuilderType: RequestBuilderType

    public init(session: URLSessionProtocol = URLSession.shared, requestBuilder: RequestBuilderType) {
        self.session = session
        self.requestBuilderType = requestBuilder
    }
    
    public func request(apiRouter: EndPoint) async throws -> [String: Any]? {
        do {
            let data: Data = try await self.request(apiRouter: apiRouter)
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            return json as? [String: Any]
        } catch let error {
            throw error
        }
    }

    public func request<T>(apiRouter: EndPoint) async throws -> T where T : Decodable {
        do {
            let data: Data = try await self.request(apiRouter: apiRouter)
            guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else {
                throw NetworkError.encodingFailed
            }
            return decodedResponse
        } catch let error {
            throw error
        }
    }
    
    public func request(apiRouter: EndPoint) async throws -> SessionResponseType  {
        let request = try self.requestBuilderType.buildRequest(from: apiRouter)
        let (data, response) = try await session.data(for: request)
        return (data, response)
    }
    
    public func request(apiRouter: EndPoint) async throws -> Data  {
        
        let request = try self.requestBuilderType.buildRequest(from: apiRouter)

        let (data, response) = try await self.request(apiRouter: apiRouter)
        
        try  NetWorkErrorHandler().findErrorIfany(from: response)
        
        return data
    }
}


struct NetWorkErrorHandler {
    
    
    func findErrorIfany(from response: URLResponse) throws {
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.badRequest
        }
        let result = self.handleNetworkResponse(response)
        switch result {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }
    
    
    func handleNetworkResponse(_ response: HTTPURLResponse) -> Swift.Result<String, NetworkError> {
        switch response.statusCode {
        case 200...299: return .success("Success")
        case 401: return .failure(NetworkError.unauthorized)
        case 402...500: return .failure(NetworkError.serverError)
        case 501...599: return .failure(NetworkError.badRequest)
        case 600: return .failure(NetworkError.outdated)
        default: return .failure(NetworkError.missingURL)
        }
    }
}
