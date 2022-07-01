//
//  SplashViewController_CN.swift
//  CalmingNotifications
//
//  Created by Maxim on 04.02.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import UIKit

class SplashViewController_CN: UIViewController {

    // MARK: - Dependencies

    private let viewModel: SplashViewModelProtocol_CN
    
    
    // MARK: - Init

    init(viewModel: SplashViewModelProtocol_CN,
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
        view.backgroundColor = UIColor(patternImage: UIImage(named: "SplashScreen")!)
        view.addSubview(progress)
        view.addSubview(reloadButton)
        setupLayout()
        setupObservers()
        viewModel.downloadInitialData()
    }
    
    private func setupObservers() {
        viewModel.progress.subscribe(observer: self) { [weak self] progressValue in
            self?.progress.progress = Float(progressValue)
        }
        
        viewModel.error.subscribe(observer: self) { [weak self] message in
            guard !message.isEmpty else { return }
            guard let strongSelf = self else { return }
            strongSelf.present(strongSelf.alert,
                          animated: true,
                          completion: nil)
        }
        
        viewModel.isHiddenProgressBar.subscribe(observer: self) { [weak self] isHidden in
            if isHidden { self?.progress.setProgress(0, animated: false) }
            self?.progress.isHidden = isHidden
        }
        
        viewModel.isHiddenReloadButton.subscribe(observer: self) { [weak self] isHidden in
            self?.reloadButton.isHidden = isHidden
        }
    }
    
    
    // MARK: - UI -
    
    private lazy var progress: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .bar)
        progress.center = view.center
        progress.setProgress(0, animated: false)
        progress.trackTintColor = .black
        progress.tintColor = .red
        return progress
    }()
    
    private lazy var alert: UIAlertController = {
        let alert = UIAlertController(title: "Ошибка",
                                      message: viewModel.error.value,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Закрыть",
                                   style: .cancel) { [weak self] _ in
            self?.viewModel.closeAlert()
        }
        alert.addAction(action)
        return alert
    }()
    
    
    private lazy var reloadButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        button.imageView?.layer.transform = CATransform3DMakeScale(1.3, 1.3, 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        button.addTarget(self,
                         action: #selector(reloadButtonTapped),
                         for: .touchUpInside)
        return button
    }()
    
    
    @objc private func reloadButtonTapped() {
        viewModel.downloadInitialData()
    }
    
    func setupLayout() {
        reloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        reloadButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    

    deinit {
//        print("SplashViewController_CN is deinit -------- ")
    }
}
