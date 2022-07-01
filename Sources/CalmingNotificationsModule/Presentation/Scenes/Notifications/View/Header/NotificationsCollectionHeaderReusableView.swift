//
//  NotificationsCollectionHeaderReusableView.swift
//  CalmingNotifications
//
//  Created by Maxim on 18.01.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import UIKit


class NotificationsCollectionHeaderReusableView: UICollectionReusableView {
    
    // MARK: - Static
    
    static let identifier = String(describing: NotificationsCollectionHeaderReusableView.self)
    
    
    // MARK: - Dependencies
    
    private var viewModel: NotificationsHeaderViewModelProtocol_CN?
    
    func setupDependencies<VM>(viewModel: VM) {
        guard let vm = viewModel as? NotificationsHeaderViewModelProtocol_CN else { return }
        self.viewModel = vm
    }
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(title)
        self.addSubview(dismissButton)
        self.addSubview(addNewNotificationButton)
        self.addSubview(notificationStatus)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI -
    
    private var title: UILabel = {
        let label = UILabel()
        label.text = "Уведомления"
        label.font = UIFont(name: "Montserrat-Regular", size: 17)!
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .label
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.imageView?.layer.transform = CATransform3DMakeScale(1.1, 1.1, 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self,
                         action: #selector(dismissButtonTapped),
                         for: .touchUpInside)
        return button
    }()
    
    @objc private func dismissButtonTapped() {
        viewModel?.dismissButtonTapped()
    }
    
    private lazy var addNewNotificationButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .label
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.imageView?.layer.transform = CATransform3DMakeScale(1.1, 1.1, 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self,
                         action: #selector(addNewNotificationButtonTapped),
                         for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    @objc private func addNewNotificationButtonTapped() {
        viewModel?.addNewNotificationButtonTapped(date: Date())
    }
    
    private var notificationStatus: UIButton = {
        let button = UIButton(type: .system)
        let text = "Уведомления отключены. Разрешите их получение в настройках"
        let atrText = NSMutableAttributedString(string: text,
                                                attributes: [:])
        atrText.addAttributes([.foregroundColor : UIColor.systemBlue,
                               .underlineStyle: NSUnderlineStyle.single.rawValue],
                              range: NSRange(location: 48, length: 10))
        button.setAttributedTitle(atrText, for: .normal)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 16)!
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self,
                         action: #selector(notificationStatusButtonTapped),
                         for: .touchUpInside)
        button.contentEdgeInsets = .init(top: 0,
                                         left: 0,
                                         bottom: 30,
                                         right: 0)
        return button
    }()
    
    @objc func notificationStatusButtonTapped() {
        print(notificationStatusButtonTapped)
        if let appSettings = URL(string: UIApplication.openSettingsURLString),
           UIApplication.shared.canOpenURL(appSettings) {
            UIApplication.shared.open(appSettings)
        }
    }
    
    
    // MARK: - Layout
    
    func setupLayout() {
        title.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        title.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        dismissButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        dismissButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addNewNotificationButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        addNewNotificationButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        addNewNotificationButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        addNewNotificationButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        notificationStatus.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30).isActive = true
        notificationStatus.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30).isActive = true
        notificationStatus.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 50).isActive = true
    }
    
    
    // MARK: - Push notifications auth mode management
    
    func manageAuthStatusMode(isAuthorized: PushNotificationsAuthStatus_CN) {
        switch isAuthorized {
        case .authorized:
            addNewNotificationButton.isHidden = false
            notificationStatus.isHidden = true
        case .notAuthorized:
            addNewNotificationButton.isHidden = true
            notificationStatus.isHidden = false
        }
    }
    
}
