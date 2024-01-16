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
    
    private var CurrentPage: Int = 0
    
    static let didChangeNotification = Notification.Name(rawValue: "DrugsListProviderDidChange")
    
    private var isFetchingDrugs = false
    
    private (set) var drugs: [CellFillElement] = []
    
    func fetchDrugsNextPage(_ search: String?) {
        guard !isFetchingDrugs else { return }
        isFetchingDrugs = true
        
        
        task?.cancel()
        
        let request = DrugsListURLReauest(limit:10, offset:CurrentPage, search:search)
        let session = URLSession.shared
        
        CurrentPage += 1
        
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
    private func DrugsListURLReauest(limit:Int,offset:Int,search:String?) -> URLRequest{
        if let search = search {
            let request = URLRequest.makeHTTPRequest(path: "api/ppp/index??limit=\(limit)&offset=\(offset)&search=\(search)", httpMethod: "GET")
            return request
        } else {
            let request = URLRequest.makeHTTPRequest(path: "api/ppp/index??limit=\(limit)&offset=\(offset)", httpMethod: "GET")
            return request
        }
       
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
        CurrentPage = 0
        drugs = []
    }
}

