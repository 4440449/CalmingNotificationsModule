//
//  MenuViewController_CN.swift
//  CalmingNotifications
//
//  Created by Max on 12.01.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import UIKit

class MenuViewController_CN: UIViewController,
                             UICollectionViewDataSource,
                             UICollectionViewDelegateFlowLayout {
    
    // MARK: - Dependencies
    
    private let viewModel: MenuViewModel_CN
    private let customTransition: UIViewControllerTransitioningDelegate
    
    
    // MARK: - Init
    
    init(viewModel: MenuViewModel_CN,
         customTransition: UIViewControllerTransitioningDelegate,
         nibName nibNameOrNil: String?,
         bundle nibBundleOrNil: Bundle?) {
        self.viewModel = viewModel
        self.customTransition = customTransition
        super.init(nibName: nibNameOrNil,
                   bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - View's lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.cornerRadius = 14
        view.layer.maskedCorners = [.layerMinXMinYCorner,
                                    .layerMaxXMinYCorner]
        view.layer.masksToBounds = true
        view.addSubview(collectionView)
        setupObservers()
        viewModel.viewDidLoad()
    }
    
    
    // MARK: - Input data flow
    
    private func setupObservers() {
        viewModel.menuItems.subscribe(observer: self) { [weak self] _ in
            self?.collectionView.reloadData()
        }
    }
    
    
    // MARK: - UI -
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: view.bounds,
                                          collectionViewLayout: UICollectionViewFlowLayout())
        collection.backgroundColor = UIColor(named: "backgroundColor")
        collection.register(MenuCollectionViewCell.self,
                            forCellWithReuseIdentifier: MenuCollectionViewCell.identifier)
        collection.dataSource = self
        collection.delegate = self
        collection.isScrollEnabled = false
        collection.contentInset.top = 70
        return collection
    }()
    
    
    //MARK: - Data source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.menuItems.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCollectionViewCell.identifier, for: indexPath) as? MenuCollectionViewCell else { fatalError() }
        let item = viewModel.menuItems.value[indexPath.row].item.get()
        cell.setupTitleButton(item.0, image: item.1)
        return cell
    }
    
    
    //MARK: - Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItemAt(index: indexPath.row)
    }
    
    
    //MARK: - Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 60,
                      height: collectionView.bounds.height / 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(30)
    }
    
    
    deinit {
        //        print("deinit NotificationsViewController_CN")
    }
    
}


