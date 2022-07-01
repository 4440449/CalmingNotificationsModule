//
//  MainCollectionViewCell_CN.swift
//  CalmingNotifications
//
//  Created by Max on 11.01.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import UIKit

class MainCollectionViewCell_CN: UICollectionViewCell {
    
    static let identifier = String(describing: MainCollectionViewCell_CN.self)
    
    
    // MARK: - Dependencies
    
    private var viewModel: MainCellViewModelProtocol_CN?
    
    
    // MARK: - State
    
    private var index: Int?
    
    
    // MARK: - Cell's setup
    
    func setupDependencies<VM>(viewModel: VM, index: Int) {
        guard let vm = viewModel as? MainCellViewModelProtocol_CN else { return }
        self.viewModel = vm
        self.index = index
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [mainImage, quoteLabel, likeButton, shareButton].forEach { self.contentView.addSubview($0) }
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    
    func fillContent(quote: String, image: UIImage) {
        quoteLabel.text = quote
        mainImage.image = image
    }
    
    private var mainImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private var quoteLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-Regular", size: 18)!
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        button.imageView?.layer.transform = CATransform3DMakeScale(1.3, 1.3, 0)
        button.tintColor = .systemRed
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func likeButtonTapped() {
        guard let index = index else { return }
        viewModel?.likeButtonTapped(cellWithIndex: index)
    }
    
    func setLikeButtonsState(isFavorite: Bool) {
        switch isFavorite {
        case true: likeButton.isSelected = true
        case false: likeButton.isSelected = false
        }
    }
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.arrow.down"), for: .normal)
        button.imageView?.layer.transform = CATransform3DMakeScale(1.3, 1.3, 0)
        button.tintColor = .white
        button.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func shareButtonTapped() {
        guard let index = index else { return }
        viewModel?.shareButtonTapped(cellWithIndex: index)
    }
    
    private func setupLayout() {
        mainImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        mainImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        mainImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        mainImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        quoteLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        quoteLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        quoteLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        
        likeButton.topAnchor.constraint(equalTo: quoteLabel.bottomAnchor, constant: 30).isActive = true
        likeButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -23).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        shareButton.topAnchor.constraint(equalTo: quoteLabel.bottomAnchor, constant: 28).isActive = true
        shareButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 23).isActive = true
        shareButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
}
