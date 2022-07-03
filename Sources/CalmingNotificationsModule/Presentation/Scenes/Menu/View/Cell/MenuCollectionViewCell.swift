//
//  MenuCollectionViewCell.swift
//  CalmingNotifications
//
//  Created by Maxim on 11.02.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import UIKit

class MenuCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: MenuCollectionViewCell.self)
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(title)
        setupAppearance()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI -
    
//    var t: UIButton(type: .system) = { }()
    
    private lazy var title: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart.fill"), for: .disabled)
//        button.imageView?.layer.transform = CATransform3DMakeScale(1.3, 1.3, 0)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        button.setTitleColor(.label, for: .disabled)
        button.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 16)!
        button.tintColor = .label
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
//    private var title: UILabel = {
//        let label = UILabel()
//
//        let attachment = NSTextAttachment()
//        attachment.image = UIImage(systemName: "heart.fill")
//        let attachmentString = NSAttributedString(attachment: attachment)
////        let myString = NSMutableAttributedString(string: price)
////        myString.append(attachmentString)
//        label.attributedText = attachmentString
//
////        label.text = "Mom's Exhale"
//        label.font = UIFont(name: "Montserrat-Regular", size: 17)!
//        label.textAlignment = .center
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
    
    func setupTitleButton(_ text: String, image: UIImage) {
//        title.text = text
        title.setTitle(text, for: .disabled)
        title.setImage(image, for: .disabled)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        print("traitCollectionDidChange")
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
        contentView.layer.shadowPath = UIBezierPath(rect: contentView.bounds).cgPath

        self.setupShadows(color: UIColor(named: "bottomShadowColor"),
                          offset: CGSize(width: 10, height: 10),
                          radius: 7,
                          opacity: 1,
                          rasterize: true)
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    }
    
    
    // MARK: - Layout
    
    private func setupLayout() {
        title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40).isActive = true //20
    }
    
}



