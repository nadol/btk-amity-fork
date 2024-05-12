//
//  AmityMessageImageTableViewCell.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 5/8/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit
import AmitySDK

class AmityMessageImageTableViewCell: AmityMessageTableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    private func setupView() {
        messageImageView.contentMode = .center
        messageImageView.layer.cornerRadius = 4
        let tapGesuter = UITapGestureRecognizer(target: self, action: #selector(imageViewTap))
        tapGesuter.numberOfTouchesRequired = 1
        messageImageView.isUserInteractionEnabled = true
        messageImageView.addGestureRecognizer(tapGesuter)
        layer.backgroundColor = AmityColorSet.backgroundBlue.cgColor
    }
    
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    override func display(message: AmityMessageModel) {
        if !message.isDeleted {
            let indexPath = self.indexPath
            AmityUIKitManagerInternal.shared.messageMediaService.downloadImageForMessage(message: message.object, size: .medium) { [weak self] in
                if message.isOwner {
                    self?.messageImageView.layer.backgroundColor = AmityColorSet.ownerMessageColor.cgColor
                } else {
                    self?.messageImageView.layer.backgroundColor = AmityColorSet.blue.cgColor
                }
                self?.addActivityIndicator()
            } completion: { [weak self] result in
                switch result {
                case .success(let image):
                    self?.activityIndicator.stopAnimating()
                    // To check if the image going to assign has the correct index path.
                    if indexPath == self?.indexPath {
                        self?.messageImageView.image = image
                        self?.messageImageView.contentMode = .scaleAspectFill
                    }
                case .failure:
                    self?.activityIndicator.stopAnimating()
                    if message.isOwner {
                        self?.messageImageView.layer.backgroundColor = AmityColorSet.ownerMessageColor.cgColor
                    } else {
                        self?.messageImageView.layer.backgroundColor = AmityColorSet.blue.cgColor
                    }
                    self?.messageImageView.image = AmityIconSet.defaultMessageImage
                    self?.metadataLabel.isHidden = false
                    self?.messageImageView.contentMode = .center
                }
            }
        }
        super.display(message: message)
    }

    private func addActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .white
        messageImageView.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: messageImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: messageImageView.centerYAnchor),
        ])
        activityIndicator.startAnimating()
    }
}

private extension AmityMessageImageTableViewCell {
    @objc
    func imageViewTap() {
        if messageImageView.image != AmityIconSet.defaultMessageImage {
            screenViewModel.action.performCellEvent(for: .imageViewer(indexPath: indexPath, imageView: messageImageView))
        }
    }
}
