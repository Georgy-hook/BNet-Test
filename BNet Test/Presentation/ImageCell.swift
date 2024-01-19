//
//  imageCell.swift
//  BNet Test
//
//  Created by Georgy on 29.04.2023.
//

import UIKit
final class ImageCell: UICollectionViewCell{
    
    //MARK: - UI Elements
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let labelHeader: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let labelDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Initiliazation
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.layer.cornerRadius = 8
        self.contentView.backgroundColor = UIColor.white
        initialize()
        addSubviews()
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Layout methods
private extension ImageCell{
    func initialize(){
        //Shadow init
        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
    }
    
    func addSubviews(){
        addSubview(imageView)
        addSubview(labelHeader)
        addSubview(labelDescription)
    }
    
    func applyConstraints(){
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            imageView.heightAnchor.constraint(equalToConstant: 82),
            
            labelHeader.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
            labelHeader.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            labelHeader.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            labelDescription.topAnchor.constraint(equalTo: labelHeader.bottomAnchor, constant: 6),
            labelDescription.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            labelDescription.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
        ])
    }
}

// MARK: - Public methods
extension ImageCell{
    func configure (with elem:CellFillElement) {
        labelHeader.text = elem.header
        labelDescription.text = elem.description
        
        imageView.downloadImage(with: elem.image)
    }
}
