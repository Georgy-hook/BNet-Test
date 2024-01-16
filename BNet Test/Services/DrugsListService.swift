//
//  DrugsListService.swift
//  BNet Test
//
//  Created by Georgy on 15.01.2024.
//

import Foundation

final class DrugsListService{
    static let shared = DrugsListService()
    private init() {}
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    private var lastLoadedPage: Int = 1
    
    static let didChangeNotification = Notification.Name(rawValue: "DrugsListProviderDidChange")
    
    private var isFetchingDrugs = false
    
    private (set) var drugs: [CellFillElement] = []
    
    func fetchDrugsNextPage(_ search: String?) {
        guard !isFetchingDrugs else { return }
        isFetchingDrugs = true
        
        let nextPage = lastLoadedPage + 1
        self.lastLoadedPage = nextPage
        task?.cancel()
        
        let request = DrugsListURLReauest(limit:10, offset:nextPage, search:search)
        let session = URLSession.shared
        
        let task = session.objectTask(for: request) { [weak self] (result: Result<Drug, Error>) in
            guard let self = self else { return }
            self.isFetchingDrugs = false
            switch result {
            case .success(let body):
                body.forEach{ element in
                    self.drugs.append(self.convertToCellFillElem(element: element))
                }
                NotificationCenter.default
                    .post(
                        name: DrugsListService.didChangeNotification,
                        object: self,
                        userInfo: ["drugsList": drugs])
                
                self.task = nil
            case .failure(let error):
                print(error)
                self.isFetchingDrugs = false
            }
        }
        self.task = task
        task.resume()
    }
}

extension DrugsListService{
    private func DrugsListURLReauest(limit:Int?,offset:Int?,search:String?) -> URLRequest{
        var request = URLRequest.makeHTTPRequest(path: "api/ppp/index??limit=\(limit)&offset=\(offset)", httpMethod: "GET")
        guard let search = search else { return request }
        request.setValue(search, forHTTPHeaderField: search)
        print(request)
        return request
    }
    
    private func convertToCellFillElem(element: DrugElement) -> CellFillElement{
        return CellFillElement(image: element.image ?? "",
                               header: element.name ?? "",
                               description: element.description ?? "",
                               iconToDownload: element.categories?.icon ?? "")
    }
}

extension DrugsListService{
    func clearData() {
        drugs = []
    }
}

