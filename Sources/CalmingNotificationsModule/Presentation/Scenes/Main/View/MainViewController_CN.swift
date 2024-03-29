//
//  MainViewController_CN.swift
//  CalmingNotifications
//
//  Created by Max on 10.01.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import UIKit
import MommysEye


class MainViewController_CN: UIViewController,
                             UICollectionViewDataSource,
                             UICollectionViewDelegate {
    
    // MARK: - Dependencies
    
    private let viewModel: MainViewModelProtocol_CN
    private let animator: CheckMarkAnimatableProtocol_CN
    
    
    // MARK: - Init
    
    init(viewModel: MainViewModelProtocol_CN,
         animator: CheckMarkAnimatableProtocol_CN,
         nibName nibNameOrNil: String?,
         bundle nibBundleOrNil: Bundle?) {
        self.viewModel = viewModel
        self.animator = animator
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
        view.addSubview(closeButton)
        view.addSubview(menuButton)
        view.addSubview(activity)
        setupLayout()
        setupObservers()
        viewModel.viewDidLoad()
    }
    
    // MARK: - Input data flow
    
    private func setupObservers() {
        viewModel.quoteCards.subscribe(observer: self) { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.collectionView.reloadItems(at: strongSelf.collectionView.cachedIndexPaths())
            
        }
        
        viewModel.isLoading.subscribe(observer: self) { [weak self] isLoading in
            switch isLoading {
            case .true: self?.activity.startAnimating()
            case .false: self?.activity.stopAnimating()
            }
        }
        
        viewModel.showSuccessAnimation.subscribe(observer: self) { [weak self] toShow in
            switch toShow {
            case true: self?.successAnimation()
            case false: return
            }
        }
    }
    
    // MARK: - UI -
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: view.bounds,
                                          collectionViewLayout: setupCollectionViewLayout())
        collection.register(MainCollectionViewCell_CN.self,
                            forCellWithReuseIdentifier: MainCollectionViewCell_CN.identifier)
        collection.backgroundColor = .black
        collection.contentInsetAdjustmentBehavior = .never
        collection.alwaysBounceVertical = false
        collection.alwaysBounceHorizontal = true
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()
    
    private var menuButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.alpha = 0
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.imageView?.layer.transform = CATransform3DMakeScale(1.3, 1.3, 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self,
                         action: #selector(menuButtonTapped),
                         for: .touchUpInside)
        return button
    }()
    
    @objc private func menuButtonTapped() {
        viewModel.menuButtonTapped()
    }
    
    private var closeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.alpha = 0
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.imageView?.layer.transform = CATransform3DMakeScale(1.3, 1.3, 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self,
                         action: #selector(closeButtonTapped),
                         for: .touchUpInside)
        return button
    }()
    
    @objc private func closeButtonTapped() {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    private lazy var activity: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        indicator.style = .large
        indicator.color = .systemGray
        return indicator
    }()
    
    
    //MARK: - Data source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.quoteCards.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell_CN.identifier, for: indexPath) as? MainCollectionViewCell_CN else { fatalError() }
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
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    
    private func setupLayout() {
        closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        menuButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        menuButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        menuButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        menuButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    
    // MARK: - Animation
    
    // Collection items fade
    private var collectionItemsWasHide = true
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionItemsWasHide ? showAnimation() : hideAnimation()
    }

    private func showAnimation() {
        UIView.animate(withDuration: 1,
                       delay: 0.1,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut,
                       animations: {
            self.closeButton.alpha = 1
            self.menuButton.alpha = 1
        },
                       completion: { _ in
            self.collectionItemsWasHide = false
        })
    }
    
    private func hideAnimation() {
        UIView.animate(withDuration: 1,
                       delay: 0.1,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut,
                       animations: {
            self.closeButton.alpha = 0
            self.menuButton.alpha = 0
        },
                       completion: { _ in
            self.collectionItemsWasHide = true
        })
    }
    
    // Cells fade
    private var cellIndexWasAnimated = -1
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? MainCollectionViewCell_CN else { return }
        if indexPath.row != cellIndexWasAnimated {
            cell.prepareFadeAnimation()
        } else {
            cell.discardPreparingAnimation()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let visibleCell = collectionView.visibleCells[0] as? MainCollectionViewCell_CN else { return }
        let visibleIndex = collectionView.indexPathsForVisibleItems[0].row
        // Проверяю показывал ли я уже анимацию для этого индекса ячейки
        guard visibleIndex != cellIndexWasAnimated else { return }
        // Если индексы не совпадают (не показывал) - показываю
        visibleCell.startFadeAnimation()
        // Записываю индекс ячейки у которой показал анимацию
        cellIndexWasAnimated = visibleIndex
    }
    
    // Checkmark
    private func successAnimation() {
        animator.checkMarkAnimation(for: view)
    }
    
}

