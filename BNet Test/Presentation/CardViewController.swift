//
//  IndexElementCardView.swift
//  BNet Test
//
//  Created by Georgy on 02.05.2023.
//

import UIKit
class CardViewController: UIViewController {
    
    // MARK: - Properties
    private var imageToDownload:String = ""
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "ImageTest1")!
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "IconTest1")!
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let starButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "starIcon"), for: .normal)
        button.setImage(UIImage(systemName: "star.fill"), for: .selected)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "ДВД Шанс, КС"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor  = .black
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Двухкомпонентный протравитель семян зерновых культур."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor(named: "myLightGray")
        label.numberOfLines = 0
        return label
    }()
    
    private let buyButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("  ГДЕ КУПИТЬ", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        button.contentHorizontalAlignment = .center
        button.setImage(UIImage(named: "pinIcon"), for: .normal)
        button.tintColor = .black
        button.layer.borderWidth = 0.2
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 9
        return button
    }()

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor =  UIColor(named: "myGreen")
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Setup
    func configure(with item:CellFillElement){
        imageView.image = item.image
        titleLabel.text = item.header
        descriptionLabel.text = item.description
        imageToDownload = item.iconToDownload
        downloadImage(from: imageToDownload)
    }
    
    private func setupViews() {
        view.addSubview(contentView)
        
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(descriptionLabel)
        
        contentView.addSubview(imageView)
        contentView.addSubview(iconImageView)
        contentView.addSubview(starButton)
        contentView.addSubview(textStackView)
        contentView.addSubview(buyButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 183),
            imageView.widthAnchor.constraint(equalToConstant: 117),
            
            starButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -34),
            starButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            starButton.heightAnchor.constraint(equalToConstant: 32),
            starButton.widthAnchor.constraint(equalToConstant: 32),
            
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 32),
            iconImageView.widthAnchor.constraint(equalToConstant: 32),
            
            textStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 32),
            textStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            textStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -33),
            
            buyButton.topAnchor.constraint(equalTo: textStackView.bottomAnchor, constant: 16),
            buyButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            buyButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            buyButton.heightAnchor.constraint(equalToConstant: 36),
            
        ])
    }
    
    // MARK: - Actions
    
    @objc private func starButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
}

extension CardViewController{
    func downloadImage(from URLImage:String){
        APIManager().downloadImage(from: URLImage) { [weak self] image in
            guard let self = self else { return }
            iconImageView.image = image
        }
    }
}

