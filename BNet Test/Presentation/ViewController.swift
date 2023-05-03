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
    private var page = 0
    private let pageSize = 10
    private var collectionView: UICollectionView!
    private var images: [UIImage?] = []
    private var cellFillElem = CellFillElement(image: nil, header: "", description: "")
    private var cellFill:[CellFillElement] = []
    @objc func backButtonTapped() {
        
        let myViewController = MyViewController() // создание экземпляра вашего ViewController
        self.navigationController?.pushViewController(myViewController, animated: true) // отображение UINavigationController на экране


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
           
            //loadSearchPage(with: searchTextField.text)
            isSearchModeOn.toggle()
        }
        
    }

    @objc func handleSearchButtonTap() {
        // Обработчик нажатия на кнопку "Search"
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
               loadNextPage()
    }
}

//MARK: - LoadPagesPrivateFunc
extension ViewController{
    private func loadFirstPage(){
        APIManager().loadIndex(limit: pageSize, offset: 0,search: nil){ [weak self] result in
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
        APIManager().loadIndex(limit: pageSize, offset: offset,search: nil){ [weak self] result in
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
    private func loadSearchPage(with search:String){
        APIManager().loadIndex(limit:nil,offset:nil,search:search){ [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result{
                case .success(let index):
                    self.page += 1
                    self.loadData(for: index)
                    self.collectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func loadData(for index:Drug) {
        let imageCountBeforeLoad = self.cellFill.count
        index.forEach { item in
            var newCellFillElem = CellFillElement(image: nil, header: item.name ?? "", description: item.description ?? "")
            APIManager().downloadImage(from: item.image ?? "") { [weak self] image in
                guard let self = self else { return }
                newCellFillElem.image = image
                self.images.append(image)
                self.cellFill.append(newCellFillElem)
                if self.cellFill.count == imageCountBeforeLoad + index.count {
                    self.collectionView.reloadData()
                }
            }
        
        }
    }
}
//MARK: -
extension ViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let searchText = textField.text {
                self.cellFill = []
                loadSearchPage(with: searchText)
             }
             textField.resignFirstResponder()
             return true
         }
    }

