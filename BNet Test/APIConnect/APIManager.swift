//
//  APIManager.swift
//  BNet Test
//
//  Created by Georgy on 30.04.2023.
//

import Foundation
import UIKit

protocol IndexLoading {
    func loadIndex(handler: @escaping (Result<Drug, Error>) -> Void)
}
private enum LoaderError: Error {
    case decodeError
}
enum ApiType {
    //Типы запросов
    case getIndex(limit:Int? = nil, offset:Int? = nil, search:String? = nil)
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
        case .getIndex(let limit, let offset, let search):
            guard let limit = limit, let offset = offset else{
                guard let search = search else{
                    return "api/ppp/index"
                }
                return "api/ppp/index?search=\(search)"
            }
            return "api/ppp/index?offset=\(offset)&limit=\(limit)"
        case .getImage(let path):
            return path
        default:
            return ""
        }
    }
    //Собираем ссылку
    var url: URL {
        print(path)
        guard let baseUrl = URL(string: baseURL) else{
            preconditionFailure("Unable to construct BaseURL")
        }
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)else {
            preconditionFailure("Unable to construct encodedPath")
        }
     
        guard let url = URL(string: encodedPath, relativeTo: baseUrl) else{
            preconditionFailure("Unable to construct URL")
        }
        return url
    }
}

// MARK: - Класс отвечающий за загрузку данных с сервера BNet
class APIManager{
    static let shared = APIManager()
    private let networkClient = NetworkClient()
    
    func downloadImage(from idImage: String, handler: @escaping (UIImage) -> Void) {
        print("Download Started")
        let url = ApiType.getImage(id: idImage).url
        networkClient.getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                guard let image = UIImage(data: data) else{
                    print("Download Image Error")
                    return
                }
                handler(image)
            }
        }
    }
    
    func loadIndex(limit:Int?,offset:Int?,search:String?,handler: @escaping (Result<Drug, Error>) -> Void) {
        networkClient.fetch(url: ApiType.getIndex(limit: limit, offset: offset,search: search).url){result in
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
