//
//  ListViewController.swift
//  BNet Test
//
//  Created by Georgy on 29.04.2023.
//

import UIKit

protocol ListViewControllerProtocol: AnyObject{
    func pushCardViewController(with element:CellFillElement)
    func fetchDrugs()
    func setCollectionView(with data:[CellFillElement])
    func clearData()
}

final class ListViewController: UIViewController, LoadingView, ErrorView {
    
    //MARK: - UI Elements
    private var collectionView = DrugsCollectionView()
    
    private let searchTextField:UISearchTextField = {
        let searchTextField = UISearchTextField(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
        searchTextField.tintColor = .white
        searchTextField.textColor = .white
        searchTextField.borderStyle = .roundedRect
        searchTextField.placeholder = "Search"
        searchTextField.clearButtonMode = .whileEditing
        searchTextField.returnKeyType = .search
        searchTextField.alpha = 0
        return searchTextField
    }()
    
    var activityIndicator = UIActivityIndicatorView()
    
    //MARK: - Variables
    private var isSearchModeOn = false    
    private var presenter:ListViewPresenterProtocol = ListViewPresenter()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        addSubviews()
        applyConstraints()
        
        presenter.view = self
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    //MARK: - PreferredStatusBarStyle
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Actions
    @objc func backButtonTapped() {
        
    }
    
    @objc func searchButtonTapped() {
        if isSearchModeOn{
            navigationItem.titleView = nil
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "magnifyingglass")
            presenter.search(with: nil)
            isSearchModeOn.toggle()
        } else{
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "xmark.app")
            navigationItem.titleView = searchTextField
            UIView.animate(withDuration: 0.2, animations: {
                self.searchTextField.alpha = 1
            })
            { [self] _ in
                searchTextField.becomeFirstResponder()
            }
            isSearchModeOn.toggle()
        }
    }
}

//MARK: - Layout methods
private extension ListViewController{
    
    func initialize(){
        view.backgroundColor =  UIColor(named: "myGreen")
        searchTextField.delegate = self
        collectionView.delegateVC = self
    }
    
    func addSubviews(){
        view.addSubview(collectionView)
        view.addSubview(searchTextField)
        view.addSubview(activityIndicator)
    }
    
    func applyConstraints(){
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            searchTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    func setupNavigationBar(){
        navigationController?.navigationBar.isTranslucent = true
        
        navigationController?.navigationBar.tintColor = .white
        title = "Средства"
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor:UIColor.white
        ]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                                           style: .plain,
                                                           target: self, action: #selector(backButtonTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"),
                                                            style: .plain, target: self,
                                                            action: #selector(searchButtonTapped))
    }
}

//MARK: - ListViewControllerProtocol
extension ListViewController:ListViewControllerProtocol{
    func setCollectionView(with data: [CellFillElement]) {
        collectionView.set(with: data)
    }
    
    func clearData(){
        collectionView.clearData()
    }
    
    func fetchDrugs() {
        presenter.loadNextPage()
    }
    
    func pushCardViewController(with element:CellFillElement){
        let myViewController = CardViewController()
        myViewController.configure(with: element)
        self.navigationController?.pushViewController(myViewController, animated: true)
    }
}

//MARK: - UITextFieldDelegate
extension ListViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let searchText = textField.text {
            presenter.search(with: searchText)
        }
        
        textField.resignFirstResponder()
        return true
    }
}

