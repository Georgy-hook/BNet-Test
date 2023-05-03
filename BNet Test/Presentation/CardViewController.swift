//
//  IndexElementCardView.swift
//  BNet Test
//
//  Created by Georgy on 02.05.2023.
//

import UIKit
import SnapKit
class CardViewController: UIViewController {
    
    // MARK: - Properties
    private var imageToDownload:String = ""
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
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.setImage(UIImage(systemName: "star.fill"), for: .selected)
        button.tintColor = .systemYellow
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "ДВД Шанс, КС"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Двухкомпонентный протравитель семян зерновых культур."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    
    private let buyButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Где купить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.contentHorizontalAlignment = .center
        button.setImage(UIImage(systemName: "mappin"), for: .normal)
        button.tintColor = .black
        button.layer.borderWidth = 0.2
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 9
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
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
        view.addSubview(imageView)
        view.addSubview(iconImageView)
        view.addSubview(starButton)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(buyButton)
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(117)
            make.height.equalTo(183)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(30)
            //make.leading.equalTo(imageView.snp.leading).offset(66)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(32)
            make.width.equalTo(28)
            make.height.equalTo(28)
        }
        
        starButton.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(66)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(32)
            make.width.equalTo(28)
            make.height.equalTo(28)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(14)
            make.top.equalTo(imageView.snp.bottom).offset(32)
            make.trailing.equalToSuperview().offset(-14)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(14)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.trailing.equalToSuperview().offset(-14)
        }
        
        buyButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(14)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            
            make.height.equalTo(40)
        }
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

