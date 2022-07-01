//
//  FavoritesViewController_CN.swift
//  CalmingNotifications
//
//  Created by Maxim on 08.02.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import UIKit

class FavoritesViewController_CN: UIViewController,
                                  UICollectionViewDataSource,
                                  UICollectionViewDelegate {
    
    // MARK: - Dependencies
    
    private let viewModel: FavoritesViewModelProtocol_CN
    
    
    // MARK: - Init
    
    init(viewModel: FavoritesViewModelProtocol_CN,
         nibName nibNameOrNil: String?,
         bundle nibBundleOrNil: Bundle?) {
        self.viewModel = viewModel
        super.init(nibName: nibNameOrNil,
                   bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - View's lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        view.addSubview(dismissButton)
        view.addSubview(activity)
        view.addSubview(emptyScreenLabel)
        setupLayout()
        setupObservers()
        viewModel.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    
    // MARK: - Input data flow
    
    private func setupObservers() {
        viewModel.quoteCards.subscribe(observer: self) { [weak self] cards in
            self?.collectionView.reloadData()
            self?.manageEmptyScreenSetup(favoritesIsEmpty: cards.isEmpty)
        }
        
        viewModel.isLoading.subscribe(observer: self) { [weak self] isLoading in
            switch isLoading {
            case .true: self?.activity.startAnimating()
            case .false: self?.activity.stopAnimating()
            }
        }
    }
    
    // MARK: - UI -
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: view.bounds,
                                          collectionViewLayout: setupCollectionViewLayout())
        collection.register(FavoritesCollectionViewCell.self,
                            forCellWithReuseIdentifier: FavoritesCollectionViewCell.identifier)
        collection.contentInsetAdjustmentBehavior = .never
        collection.alwaysBounceVertical = false
//        collection.alwaysBounceHorizontal = true
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()
    
    private var dismissButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.imageView?.layer.transform = CATransform3DMakeScale(1.3, 1.3, 0)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self,
                         action: #selector(dismissButtonTapped),
                         for: .touchUpInside)
        return button
    }()
    
    @objc private func dismissButtonTapped() {
        viewModel.dismissButtonTapped()
    }
    
    
    private lazy var activity: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.center = view.center
        indicator.hidesWhenStopped = true
        indicator.style = .large
        indicator.color = .systemGray
        return indicator
    }()
    
    private var emptyScreenLabel: UILabel = {
        let label = UILabel()
        label.text = "Пока что здесь пусто, вы можете добавить понравившиеся заставки в изранное"
        label.textAlignment = .center
        label.numberOfLines = 0
        //        label.lineBreakMode = .byCharWrapping
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    //MARK: - Data source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.quoteCards.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoritesCollectionViewCell.identifier, for: indexPath) as? FavoritesCollectionViewCell else { fatalError() }
        cell.setupDependencies(viewModel: viewModel, index: indexPath.row)
        cell.fillContent(quote: viewModel.quoteCards.value[indexPath.row].quote,
                         image: viewModel.quoteCards.value[indexPath.row].image)
        cell.setLikeButtonsState(isFavorite: viewModel.quoteCards.value[indexPath.row].isFavorite)
        return cell
    }
    
    
    //MARK: - Layout
    
    private func setupCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        //        item.contentInsets = .init(top: 1, leading: 1, bottom: 1, trailing: 1)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func setupLayout() {
        emptyScreenLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        emptyScreenLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        emptyScreenLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func manageEmptyScreenSetup(favoritesIsEmpty: Bool) {
        switch favoritesIsEmpty {
        case true:
            emptyScreenLabel.isHidden = false
        case false:
            emptyScreenLabel.isHidden = true
        }
    }
    
    
    
    deinit {
//        print("deinit FavoritesViewController_CN")
    }
    
}

