//
//  NotificationsCollectionViewCell_CN.swift
//  CalmingNotifications
//
//  Created by Maxim on 18.01.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import UIKit


class NotificationsCollectionViewCell_CN: UICollectionViewCell {
    
    static let identifier = String(describing: NotificationsCollectionViewCell_CN.self)
    
    
    // MARK: - Dependencies
    
    private var viewModel: NotificationsCellViewModelProtocol_CN?
    
    
    // MARK: - State
    
    private var index: Int?
    
    override var isHighlighted: Bool {
      didSet {
        UIView.animate(withDuration: 0.15) {
          let scale: CGFloat = 0.97
          self.transform = self.isHighlighted ? CGAffineTransform(scaleX: scale, y: scale) : .identity
            self.alpha = self.isHighlighted ? 0.6 : 1
        }
      }
    }
    
    
    // MARK: - Cell's setup
    
    func setupDependencies<VM>(viewModel: VM, index: Int) {
        guard let vm = viewModel as? NotificationsCellViewModelProtocol_CN else { return
        }
        self.viewModel = vm
        self.index = index
    }
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleButton)
        contentView.addSubview(datePicker)
        contentView.addSubview(saveButton)
        contentView.addSubview(deleteButton)
        setupAppearance()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Input data flow
    
    func reloadData(time: Date) {
        animateRemovingDynamicViews(duration: 0.0)
        titleButton.setTitle(" \(time.hh_mm())", for: .normal)
        resetDatePickerTime(time)
    }
    
    func resetDatePickerTime(_ time: Date) {
        datePicker.date = Date()
        datePicker.date = time
    }
    
    
    // MARK: - UI -
    
    // MARK: - Static views prop
    
    private var titleButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setTitleColor(.label, for: .disabled)
        button.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 18)!
        button.setImage(UIImage(systemName: "bell.fill"),
                        for: .disabled)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    // MARK: - Dynamic views prop
    
    private var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        if #available(iOS 14.0, *) {
            picker.preferredDatePickerStyle = .wheels
        }
        picker.datePickerMode = .time
        picker.locale = Locale(identifier: "ru_RU")
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.alpha = 0
        picker.isHidden = true
        return picker
    }()
    
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Сохранить", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 17)!
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        button.isHidden = true
        button.isUserInteractionEnabled = true
        button.addTarget(self,
                         action: #selector(saveButtonTapped),
                         for: .touchUpInside)
        return button
    }()
    
    @objc private func saveButtonTapped() {
        guard let index = index else { return }
        viewModel?.saveButtonTapped(cellWithIndex: index, new: datePicker.date)
    }
    
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "trash.fill"),
                        for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        button.alpha = 0
        button.isHidden = true
        button.addTarget(self,
                         action: #selector(deleteButtonTapped),
                         for: .touchUpInside)
        return button
    }()
    
    @objc private func deleteButtonTapped() {
        guard let index = index else { return }
        viewModel?.deleteButtonTapped(cellWithIndex: index)
    }
    
    
    // MARK: - Cell's UI
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            contentView.layer.borderColor = UIColor(named: "borderColor")?.cgColor
            contentView.layer.shadowColor = UIColor(named: "topShadowColor")?.cgColor
            self.layer.shadowColor = UIColor(named: "bottomShadowColor")?.cgColor
        }
    }
    
    private func setupAppearance() {
        contentView.backgroundColor = UIColor(named: "backgroundColor")
        
        contentView.layer.cornerRadius = 15
        contentView.layer.borderColor = UIColor(named: "borderColor")?.cgColor
        contentView.layer.borderWidth = 0.5
        contentView.setupShadows(color: UIColor(named: "topShadowColor"),
                                 offset: CGSize(width: -10, height: -10),
                                 radius: 7,
                                 opacity: 1,
                                 rasterize: true)
        self.setupShadows(color: UIColor(named: "bottomShadowColor"),
                          offset: CGSize(width: 10, height: 10),
                          radius: 7,
                          opacity: 1,
                          rasterize: true)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate(
            [titleButton.topAnchor.constraint(equalTo: contentView.topAnchor,
                                              constant: 10),
             titleButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                  constant: 20),
             titleButton.heightAnchor.constraint(equalToConstant: (contentView.bounds.height / 2.5))] )
        
        NSLayoutConstraint.activate(
            [datePicker.topAnchor.constraint(equalTo: titleButton.bottomAnchor,
                                             constant: 20),
             datePicker.widthAnchor.constraint(equalToConstant: (contentView.bounds.width / 1.3)),
             datePicker.heightAnchor.constraint(equalToConstant: (contentView.bounds.height * 2.3)),
             datePicker.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
             
             saveButton.topAnchor.constraint(equalTo: contentView.topAnchor,
                                             constant: 10),
             saveButton.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor,
                                                  constant: -20),
             saveButton.heightAnchor.constraint(equalToConstant: (contentView.bounds.height / 2.5)),
             deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
             deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
             deleteButton.heightAnchor.constraint(equalToConstant: contentView.bounds.height / 2.5)
            ]
        )
    }
    
    
    // MARK: - Dynamic views animation
    
    func animateAddingDynamicViews() {
        self.saveButton.isHidden = false
        self.deleteButton.isHidden = false
        self.datePicker.isHidden = false
        UIView.animate(withDuration: 0.4, delay: 0.05, options: .curveEaseIn) {
            self.datePicker.alpha = 1
            self.saveButton.alpha = 1
            self.deleteButton.alpha = 1
        }
    }
    
    func animateRemovingDynamicViews(duration: TimeInterval) {
        UIView.animate(withDuration: duration, delay: 0, options: .curveLinear) {
            self.datePicker.alpha = 0
            self.saveButton.alpha = 0
            self.deleteButton.alpha = 0
        } completion: { _ in
            self.saveButton.isHidden = true
            self.deleteButton.isHidden = true
            self.datePicker.isHidden = true
        }
    }
    
}
