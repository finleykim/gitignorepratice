//
//  SearchBookNetwork.swift
//  SearchDaumBook
//
//  Created by Bo-Young PARK on 2021/09/08.
//

import RxSwift

struct SearchBookAPI {
    static let scheme = "https"
    static let host = "dapi.kakao.com"
    static let path = "/v3/search/"
    
    func searchBook(query: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = SearchBookAPI.scheme
        components.host = SearchBookAPI.host
        components.path = SearchBookAPI.path + "book"
        
        components.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "size", value: "25")
        ]
        
        return components
    }
}

class SearchBookNetwork {
    private let session: URLSession
    let api = SearchBookAPI()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func searchBook(query: String) -> Single<Result<Book, SearchNetworkError>> {
        guard let url = api.searchBook(query: query).url else {
            return .just(.failure(.invalidURL))
        }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("KakaoAK 974defb9863e9c41e3f9ec6a213475a0", forHTTPHeaderField: "Authorization")
        
        return session.rx.data(request: request as URLRequest)
            .map { data in
                do {
                    let bookData = try JSONDecoder().decode(Book.self, from: data)
                    return .success(bookData)
                } catch {
                    return .failure(.invalidJSON)
                }
            }
            .catch { _ in
                .just(.failure(.networkError))
            }
            .asSingle()
    }
}
