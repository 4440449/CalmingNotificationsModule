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
        view.addSubview(closeButton)
        view.addSubview(loadingLabel)
        view.addSubview(progress)
        view.addSubview(logoStack)
        view.addSubview(reloadButton)
        setupLayout()
        setupObservers()
        viewModel.reloadButtonTapped()
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
            self?.loadingLabel.isHidden = isHidden
        }
        
        viewModel.isHiddenReloadButton.subscribe(observer: self) { [weak self] isHidden in
            self?.reloadButton.isHidden = isHidden
        }
        
        viewModel.isHiddenCloseButton.subscribe(observer: self) { [weak self] isHidden in
            self?.closeButton.isHidden = isHidden
        }
    }
    
    
    // MARK: - UI -
    
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.isHidden = true
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
    
    private lazy var loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Загрузка\nлюбимых цитат"
        label.font = UIFont(name: "Montserrat-Regular", size: 21)!
        label.textColor = .white
        label.numberOfLines = 2
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var progress: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .bar)
        progress.setProgress(0, animated: false)
        progress.trackTintColor = .gray
        progress.tintColor = .white
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    private lazy var logo1Label: UILabel = {
        let label = UILabel()
        label.text = "#мамавыдохни:"
        label.font = UIFont(name: "Montserrat-ExtraBold", size: 14)!
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var logo2Label: UILabel = {
        let label = UILabel()
        label.text = "напоминания"
        label.font = UIFont(name: "Montserrat-Regular", size: 14)!
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var logoStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 3
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(logo1Label)
        stack.addArrangedSubview(logo2Label)
        return stack
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
        viewModel.reloadButtonTapped()
    }
    
    func setupLayout() {
        closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        loadingLabel.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loadingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        loadingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        progress.topAnchor.constraint(equalTo: loadingLabel.bottomAnchor, constant: 20).isActive = true
        progress.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        progress.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        logoStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        
        reloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        reloadButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    
    
    deinit {
        //        print("SplashViewController_CN is deinit -------- ")
    }
}
