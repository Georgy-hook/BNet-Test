//
//  APIManager.swift
//  BNet Test
//
//  Created by Georgy on 30.04.2023.
//

import Foundation

protocol IndexLoading {
    func loadIndex(handler: @escaping (Result<Drug, Error>) -> Void)
}
private enum LoaderError: Error {
    case decodeError
}
enum ApiType {
    //Типы запросов
    case getIndex(limit:Int, offset:Int)
    case getItem(id: Int)
    case getImage(id: String)
    
    //Общий URL
    var baseURL:String {
        return "http://shans.d2.i-partner.ru/"
    }
    
    //Хэдэры если есть постзапросы
    var headers: [String: String] {
        switch self{
        default:
            return [:]
        }
    }
    
    //Путь до элемента
    var path: String {
        switch self{
        case .getItem(let id):
            return "api/ppp/item?id=\(id)"
        case .getIndex(let limit, let offset):
            return "api/ppp/index?offset=\(offset)&limit=\(limit)"
        case .getImage(let path):
            return path
        default:
            return ""
        }
    }
    //Собираем ссылку
    var url: URL {
        guard let baseUrl = URL(string: baseURL) else{
            preconditionFailure("Unable to construct BaseURL")
        }
        guard let url = URL(string: path, relativeTo: URL(string: baseURL)) else{
            preconditionFailure("Unable to construct URL")
        }
        return url
    }
}

class APIManager{
    static let shared = APIManager()
    private let networkClient = NetworkClient()
    
    
    func loadIndex(limit:Int,offset:Int,handler: @escaping (Result<Drug, Error>) -> Void) {
        networkClient.fetch(url: ApiType.getIndex(limit: limit, offset: offset).url){result in
            switch result{
            case .success(let data):
                do {
                    let json = try JSONDecoder().decode(Drug.self, from: data)
                    handler(.success(json))
                }
                catch{
                    handler(.failure(LoaderError.decodeError))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
}
