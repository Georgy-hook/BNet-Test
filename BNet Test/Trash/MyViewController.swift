//
//  MyViewController.swift
//  BNet Test
//
//  Created by Georgy on 29.04.2023.
//

import UIKit


class MyViewController: UIViewController {
    
    let myCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        //layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        let spacing: CGFloat = 16
        let width = (UIScreen.main.bounds.width - spacing * 3) / 2
        let height: CGFloat = 296
        
        layout.itemSize = CGSize(width: width, height: height)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    let myNavigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.tintColor = .blue
        navigationBar.barTintColor = UIColor(hex: "#6FB54B")
        let navigationItem = UINavigationItem(title: "My Title")
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = searchButton
        navigationBar.items = [navigationItem]
        return navigationBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(myCollectionView)
        view.addSubview(myNavigationBar)
        
        NSLayoutConstraint.activate([
            myCollectionView.topAnchor.constraint(equalTo: myNavigationBar.bottomAnchor, constant: 24),
            myCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            myCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            myCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            myNavigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            myNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
    }
    
    @objc func backButtonTapped() {
        // handle back button tapped event
    }
    
    @objc func searchButtonTapped() {
        // handle search button tapped event
    }
}

extension MyViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCollectionViewCell
        cell.titleLabel.text = "Cell \(indexPath.item + 1)"
        return cell
    }
}

class MyCollectionViewCell: UICollectionViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .lightGray
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
