//
//  DrugsCollectionView.swift
//  BNet Test
//
//  Created by Georgy on 12.01.2024.
//

import UIKit

final class DrugsCollectionView: UICollectionView{
    // MARK: - Variables
    private let params = GeometricParams(cellCount: 2, leftInset: 16, rightInset: 16, cellSpacing: 15)
    private var cells:[CellFillElement] = []
    
    weak var delegateVC: ViewControllerProtocol?
    
    // MARK: - Initiliazation
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(frame: .zero, collectionViewLayout: layout)
        
        delegate = self
        dataSource = self
        register(ImageCell.self, forCellWithReuseIdentifier: "cell")
        backgroundColor = .white
        
        translatesAutoresizingMaskIntoConstraints = false
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UICollectionViewDataSource
extension DrugsCollectionView:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCell
        cell.configure(with: cells[indexPath.item])
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension DrugsCollectionView:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: params.leftInset, bottom: 0, right: params.rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return params.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWidth
        let cellWidth =  availableWidth / CGFloat(params.cellCount)
        return CGSize(width: cellWidth, height: 296)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return params.cellSpacing
    }
}

//MARK: - UICollectionViewDelegate
extension DrugsCollectionView:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        delegateVC?.fetchDrugs()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegateVC?.pushCardViewController(with: cells[indexPath.item])
    }
}

extension DrugsCollectionView{
    func set(with drugs:[CellFillElement]){
        cells = drugs
        self.reloadData()
    }
}
