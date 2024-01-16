//
//  imageCell.swift
//  BNet Test
//
//  Created by Georgy on 29.04.2023.
//

import UIKit
import SnapKit

class ImageCell: UICollectionViewCell{
    // MARK: - Public
    func configure (with elem:CellFillElement) {
        labelHeader.text = elem.header
        labelDescription.text = elem.description
        
        imageView.downloadImage(with: elem.image)
    }
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.layer.cornerRadius = 8
        self.contentView.backgroundColor = UIColor.white
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private properties
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    private let labelHeader: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        return label
    }()
    private let labelDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 5
        return label
    }()
}

// MARK: - private methods
private extension ImageCell{
    func initialize(){
        //Shadow init
        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4

        contentView.addSubview(imageView)
        imageView.snp.makeConstraints{make in
            make.height.equalTo(140)
            make.top.trailing.leading.equalToSuperview().inset(12)
        }
        contentView.addSubview(labelHeader)
        labelHeader.snp.makeConstraints{make in
            make.top.equalTo(imageView.snp.bottomMargin).offset(12)
            make.trailing.leading.equalToSuperview().inset(12)
        }
        contentView.addSubview(labelDescription)
        labelDescription.snp.makeConstraints{make in
            make.top.equalTo(labelHeader.snp.bottomMargin).offset(6)
            make.trailing.leading.equalToSuperview().inset(12)
            
        }
    }
}
