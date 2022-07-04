//
//  FavoritesCollectionViewCell.swift
//  CalmingNotifications
//
//  Created by Maxim on 08.02.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import UIKit

class FavoritesCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: MainCollectionViewCell_CN.self)
    
    
    // MARK: - Dependencies
    
    private var viewModel: FavoritesCellViewModelProtocol_CN?
    
    
    // MARK: - State
    
    private var index: Int?
    
    
    // MARK: - Cell's setup
    
    func setupDependencies<VM>(viewModel: VM, index: Int) {
        guard let vm = viewModel as? FavoritesCellViewModelProtocol_CN else { return }
        self.viewModel = vm
        self.index = index
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [logoLabel, quoteLabel, likeButton, shareButton].forEach { self.contentView.addSubview($0) }
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    
    func fillContent(quote: String, image: UIImage) {
        quoteLabel.text = quote
        contentView.backgroundColor = UIColor(patternImage: image)
    }
    
    private var logoLabel: UILabel = {
        let label = UILabel()
        //        label.text = "Mom's Exhale"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        button.addTarget(self, action: #selector(favoritelikeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func favoritelikeButtonTapped() {
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
        logoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        logoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        logoLabel.bottomAnchor.constraint(equalTo: quoteLabel.topAnchor, constant: -40).isActive = true
        
        quoteLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        quoteLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        quoteLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        
        likeButton.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
        likeButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -33).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        shareButton.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -43).isActive = true
        shareButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 33).isActive = true
        shareButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    deinit {
        //        print("deinit FavoritesCollectionViewCell")
    }
    
}
