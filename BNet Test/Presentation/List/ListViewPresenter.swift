//
//  ListViewPresenter.swift
//  BNet Test
//
//  Created by Georgy on 19.01.2024.
//

import Foundation

// MARK: - Protocol

protocol ListViewPresenterProtocol {
    var view: ListViewController? {get set}
    func viewDidLoad()
    func loadNextPage()
    func search(with searchText: String?)
}

// MARK: - State
enum ListViewState {
    case initial, loading, failed(Error), data([CellFillElement])
}

final class ListViewPresenter: ListViewPresenterProtocol{
    
    // MARK: - Properties
    weak var view: ListViewController?
    private let service = DrugsListService.shared
    private var drugsListServiceObserver: NSObjectProtocol?
    private var searchText:String? = nil
    
    private var state = ListViewState.initial {
        didSet {
            stateDidChanged()
        }
    }
    
    // MARK: - Public Functions
    func viewDidLoad() {
        addObserver()
        state = .loading
    }
    
    func loadNextPage(){
        self.state = .loading
    }
    
    func search(with searchText: String?){
        service.clearData()
        view?.clearData()
        self.searchText = searchText
        self.state = .loading
    }
    
    // MARK: - Private Functions
    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
            
        case .loading:
            if service.drugs.isEmpty{
                view?.showLoading()
            }
            service.fetchDrugsNextPage(searchText)
            
        case .data(let drugs):
            view?.hideLoading()
            view?.setCollectionView(with: drugs)
            
        case .failed(let error):
            let errorModel = makeErrorModel(error)
            view?.hideLoading()
            view?.showError(errorModel)
        }
    }
    
    private func addObserver(){
        drugsListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: DrugsListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.state = .data(service.drugs)
            }
        self.state = .data(service.drugs)
    }
    
    private func makeErrorModel(_ error: Error) -> ErrorModel {
        let message = "Похоже какая-то ошибка с сетью"
        let actionText = "Повторить"
        
        return ErrorModel(message: message, actionText: actionText) { [weak self] in
            self?.state = .loading
        }
    }
    
}
