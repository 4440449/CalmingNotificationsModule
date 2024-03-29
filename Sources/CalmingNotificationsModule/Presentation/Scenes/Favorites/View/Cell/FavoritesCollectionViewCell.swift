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
        self.contentView.addSubview(quoteLabel)
        self.contentView.addSubview(likeButton)
        self.contentView.addSubview(shareButton)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fillContent(quote: String, image: UIImage) {
        quoteLabel.text = quote
        contentView.backgroundColor = UIColor(patternImage: image)
    }
    
    // MARK: - UI
    
    // Properties
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
        let button = LikeButton_CN()
        button.setImage(UIImage(named: "heart"), for: .normal)
        button.setImage(UIImage(named: "heart.fill"), for: .selected)
        button.setImage(UIImage(named: "heart.transparent"), for: [.normal, .highlighted])
        button.setImage(UIImage(named: "heart.fill.transparent"), for: [.selected, .highlighted])
        button.imageView?.layer.transform = CATransform3DMakeScale(1.2, 1.2, 0)
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
        button.setImage(UIImage(named: "square.and.arrow.up"), for: .normal)
        button.imageView?.layer.transform = CATransform3DMakeScale(1.2, 1.2, 0)
        button.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func shareButtonTapped() {
        guard let index = index else { return }
        viewModel?.shareButtonTapped(cellWithIndex: index)
    }
    
    // Layout
    private func setupLayout() {
        quoteLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        quoteLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        quoteLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        
        likeButton.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
        likeButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -33).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        shareButton.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -41).isActive = true
        shareButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 33).isActive = true
        shareButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    // Animation
    func discardPreparingAnimation() {
        self.quoteLabel.alpha = 1
        self.likeButton.alpha = 1
        self.shareButton.alpha = 1
    }
    
    func prepareFadeAnimation() {
        self.quoteLabel.alpha = 0
        self.likeButton.alpha = 0
        self.shareButton.alpha = 0
    }
    
    func startFadeAnimation() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1.5,
                           delay: 0.5,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut) {
                self.quoteLabel.alpha = 1
            } completion: { _ in
                UIView.animate(withDuration: 1.3,
                               delay: 0.1,
                               usingSpringWithDamping: 1,
                               initialSpringVelocity: 0,
                               options: .curveEaseInOut,
                               animations: {
                    self.likeButton.alpha = 1
                    self.shareButton.alpha = 1
                },
                               completion: nil)
            }
        }
    }
    
    deinit {
        //        print("deinit FavoritesCollectionViewCell")
    }
    
}
