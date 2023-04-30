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
        IndexLoader().loadIndex{result in
            print(result)
            
        }
    }
    //MARK: - Private properties
    private var collectionView: UICollectionView!
    private var images: [UIImage?] = [UIImage(systemName: "star"),UIImage(systemName: "chevron.left"),UIImage(systemName: "star"),UIImage(systemName: "star"),UIImage(systemName: "chevron.left"),UIImage(systemName: "star")]
    private let myNavigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.tintColor = .blue
        navigationBar.backgroundColor = .green
        let navigationItem = UINavigationItem(title: "My Title")
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = searchButton
        navigationBar.items = [navigationItem]
        return navigationBar
    }()
    @objc func backButtonTapped() {
        // handle back button tapped event
    }
    
    @objc func searchButtonTapped() {
        // handle search button tapped event
    }
}

//MARK: - Private methods
private extension ViewController{
   
    func initialize(){
        //MARK: - NavigationBarInit
        view.addSubview(myNavigationBar)
        myNavigationBar.snp.makeConstraints{make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        
        }
        //MARK: - CollectionViewInit
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.minimumInteritemSpacing = 15
        collectionViewLayout.minimumLineSpacing = 15
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints{make in
            make.leading.leading.trailing.equalToSuperview()
            make.top.equalTo(myNavigationBar.snp.bottom).offset(12)
            make.height.equalToSuperview()
        }
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.layer.borderWidth = 1
    }
  
}
//MARK: - UICollectionViewDataSource
extension ViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCell
        cell.configure(image: images[indexPath.item])
        return cell
    }
}
//MARK: - UICollectionViewDelegateFlowLayout
extension ViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 164, height: 296)
    }
}
