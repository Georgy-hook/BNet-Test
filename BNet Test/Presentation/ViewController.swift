//
//  ViewController.swift
//  BNet Test
//
//  Created by Georgy on 29.04.2023.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
           navigationController?.navigationBar.tintColor = .blue
           navigationController?.navigationBar.isTranslucent = true
           navigationItem.title = "Средства"
           navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
           navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonTapped))
       }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent //задаем белый цвет для statusBar
    }
    //MARK: - Private properties
    //private var searchTextField: UITextField = UITextField(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    //private var searchButton: UIButton?
    private var isSearchModeOn = false
    private var isDataLoaded = false
    private var page = 0
    private let pageSize = 8
    private var searchText:String? = nil
    private var collectionView: UICollectionView!
    private var images: [UIImage?] = []
    private var cellFillElem = CellFillElement(image: nil, header: "", description: "",iconToDownload: "")
    private var cellFill:[CellFillElement] = []
    @objc func backButtonTapped() {

    }
    
    @objc func searchButtonTapped() {
        
        let searchTextField = UISearchTextField(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        searchTextField.center = view.center
        searchTextField.borderStyle = .roundedRect
        searchTextField.placeholder = "Search"
        searchTextField.clearButtonMode = .whileEditing
        searchTextField.returnKeyType = .search
        searchTextField.delegate = self
        if isSearchModeOn{
            navigationItem.titleView = nil
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "magnifyingglass")
            self.searchText = nil
            loadFirstPage()
            isSearchModeOn.toggle()
        }else{
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "xmark.app")
            navigationItem.titleView = searchTextField
            // Configure animation for showing the search text field
            UIView.animate(withDuration: 0.2, animations: {
                searchTextField.alpha = 1
            }) { (success) in
                searchTextField.becomeFirstResponder()
            }
            isSearchModeOn.toggle()
        }
        
    }

}

//MARK: - Private methods
private extension ViewController{
   
    func initialize(){
        view.backgroundColor =  .white

        //MARK: - CollectionViewInit
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.minimumInteritemSpacing = 15
        collectionViewLayout.minimumLineSpacing = 15
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 24, left: 16, bottom: 0, right: 16)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints{make in
            make.leading.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalToSuperview()
        }
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        loadFirstPage()
    }
  
}
//MARK: - UICollectionViewDataSource
extension ViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellFill.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCell
        cell.configure(with: cellFill[indexPath.item])
        return cell
    }
}
//MARK: - UICollectionViewDelegateFlowLayout
extension ViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 164, height: 296)
    }
}

//MARK: - UICollectionViewDelegate
extension ViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if isDataLoaded{
            loadNextPage()
            isDataLoaded.toggle()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let myViewController = CardViewController() // создание экземпляра ViewController
        myViewController.configure(with: cellFill[indexPath.item])
        self.navigationController?.pushViewController(myViewController, animated: true) // отображение UINavigationController на экране
    }
}

//MARK: - LoadPagesPrivateFunc
private extension ViewController{
    private func loadFirstPage(){
        APIManager().loadIndex(limit: pageSize, offset: 0,search: searchText){ [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result{
                case .success(let index):
                    self.page = 1
                    self.cellFill = []
                    self.loadData(for: index)
                    self.collectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func loadNextPage() {
        let offset = page * pageSize
        APIManager().loadIndex(limit: pageSize, offset: offset,search: searchText){ [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result{
                case .success(let index):
                    self.page += 1
                    self.loadData(for: index)
                    
                    //self.collectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func loadData(for index:Drug) {
        var loadedCount = 0
        let imageCountBeforeLoad = self.cellFill.count
        
        index.forEach { item in
            var newCellFillElem = CellFillElement(image: nil, header: item.name ?? "", description: item.description ?? "", iconToDownload:item.categories?.icon ?? "" )
            APIManager().downloadImage(from: item.image ?? "") { [weak self] image in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    newCellFillElem.image = image
                    self.cellFill.append(newCellFillElem)
                    loadedCount += 1
                    
                    if loadedCount == index.count {
                        print("reloadData")
                        self.isDataLoaded.toggle()
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
}

//MARK: -
extension ViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let searchText = textField.text {
                self.page = 0
                self.searchText = searchText
                loadFirstPage()
        }
             textField.resignFirstResponder()
             return true
         }
    }

