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
}

class ListViewController: UIViewController {
    
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
    
    //MARK: - Variables
    private var isSearchModeOn = false
    
    private var searchText:String? = nil {
        didSet{
            drugsListService.clearData()
            collectionView.clearData()
            drugsListService.fetchDrugsNextPage(searchText)
        }
    }
    
    private var drugsListServiceObserver: NSObjectProtocol?
    private var drugsListService = DrugsListService.shared
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        addSubviews()
        applyConstraints()
        
        fetchDrugs()
        addObserver()
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
            self.searchText = nil
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
    }
    
    func applyConstraints(){
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            searchTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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

//MARK: - Add Observer
private extension ListViewController{
    private func addObserver(){
        drugsListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: DrugsListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                collectionView.set(with: drugsListService.drugs)
            }
        collectionView.set(with: drugsListService.drugs)
    }
}

//MARK: - ListViewControllerProtocol
extension ListViewController:ListViewControllerProtocol{
    func fetchDrugs() {
        drugsListService.fetchDrugsNextPage(searchText)
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
            self.searchText = searchText
        }
        
        textField.resignFirstResponder()
        return true
    }
}

