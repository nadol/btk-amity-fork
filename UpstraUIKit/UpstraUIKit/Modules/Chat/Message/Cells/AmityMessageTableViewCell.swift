//
//  AmityMessageTableViewCell.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 7/8/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import Kingfisher
import UIKit
import AmitySDK

class AmityMessageTableViewCell: UITableViewCell, AmityMessageCellProtocol {
    
    static let deletedMessageCellHeight: CGFloat = 52
    
    // MARK: - Delegate
    weak var delegate: AmityMessageCellDelegate?
    
    // MARK: - IBOutlet Properties
    @IBOutlet var avatarView: AmityAvatarView!
    @IBOutlet var containerView: AmityResponsiveView!
    @IBOutlet var displayNameLabel: UILabel?
    @IBOutlet var metadataLabel: UILabel!
    @IBOutlet var messageImageView: UIImageView!
    @IBOutlet var statusMetadataImageView: UIImageView!
    @IBOutlet var errorButton: UIButton!
    
    // MARK: Container
    @IBOutlet var containerMessageView: UIView!
    @IBOutlet var containerMetadataView: UIView!
    
    // MARK: - Properties
    var screenViewModel: AmityMessageListScreenViewModelType!
    var message: AmityMessageModel!
    
    var indexPath: IndexPath!
    let editMenuItem = UIMenuItem(title: AmityLocalizedStringSet.General.edit.localizedString, action: #selector(editTap))
    let deleteMenuItem = UIMenuItem(title: AmityLocalizedStringSet.General.delete.localizedString, action: #selector(deleteTap))
    let reportMenuItem = UIMenuItem(title: AmityLocalizedStringSet.General.report.localizedString, action: #selector(reportTap))
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if message.isOwner {
            switch message.messageType {
            case .text:
                return action == #selector(editTap) || action == #selector(deleteTap)
            default:
                return action == #selector(deleteTap)
            }
        } else {
            return action == #selector(reportTap)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        statusMetadataImageView?.isHidden = true
        containerMessageView?.isHidden = false
        metadataLabel?.isHidden = false
        errorButton?.isHidden = true
        avatarView?.image = nil
    }
    
    class func height(for message: AmityMessageModel, boundingWidth: CGFloat) -> CGFloat {
        fatalError("This function need to be implemented.")
    }
    
    func setViewModel(with viewModel: AmityMessageListScreenViewModelType) {
        screenViewModel = viewModel
    }
    
    func setIndexPath(with _indexPath: IndexPath) {
        indexPath = _indexPath
    }
    
    func setRoundCorner(isOwner: Bool) -> CACornerMask {
        if isOwner {
            return [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        } else {
            return [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        }
    }

    func display(message: AmityMessageModel) {
        
        self.message = message
        
        if message.isOwner {
            
            containerView.layer.maskedCorners = setRoundCorner(isOwner: message.isOwner)
            
            switch message.messageType {
            case .text, .audio:
                containerView.backgroundColor = AmityColorSet.ownerMessageColor
            case .image:
                containerView.backgroundColor = .clear
            default:
                containerView.backgroundColor = AmityColorSet.ownerMessageColor
            }
        } else {
            avatarView.placeholder = AmityIconSet.defaultAvatar
            setAvatarImage(message)
            containerView.layer.maskedCorners = setRoundCorner(isOwner: message.isOwner)
            
            switch message.messageType {
            case .text, .audio:
                containerView.backgroundColor = AmityColorSet.blue
            default:
                containerView.backgroundColor = .clear
            }
            
            setDisplayName(for: message)
        }
        
        setMetadata(message: message)
        
        if message.flagCount > 0 {
            containerView.layer.borderColor = UIColor.red.cgColor
            containerView.layer.borderWidth = 1
        } else {
            containerView.layer.borderColor = UIColor.clear.cgColor
            containerView.layer.borderWidth = 0
        }
        
    }
    
    func setMetadata(message: AmityMessageModel) {
        let fullString = NSMutableAttributedString()
        let style: [NSAttributedString.Key : Any]? = [
            .foregroundColor: AmityColorSet.lightBlue,
            .font: AmityFontSet.metadataLabelFont
        ]
        if message.isDeleted {
            containerMessageView.isHidden = true
            statusMetadataImageView.isHidden = false
            var deleteMessage =  String.localizedStringWithFormat(AmityLocalizedStringSet.MessageList.deleteMessage.localizedString, message.time)
            deleteMessage += "               "
            fullString.append(NSAttributedString(string: deleteMessage, attributes: style))
            statusMetadataImageView.image = AmityIconSet.iconDeleteMessage?
                .withTintColor(AmityColorSet.lightBlue, renderingMode: .alwaysOriginal)
        } else if message.isEdited {
            let editMessage = String.localizedStringWithFormat(AmityLocalizedStringSet.MessageList.editMessage.localizedString, message.time)
            fullString.append(NSAttributedString(string: editMessage, attributes: style))
        } else {
            if message.isOwner {
                switch message.syncState {
                case .error:
                    errorButton.isHidden = false
                    fullString.append(NSAttributedString(string: message.time, attributes: style))
                case .syncing:
                    fullString.append(NSAttributedString(string: AmityLocalizedStringSet.MessageList.sending.localizedString, attributes: style))
                case .synced:
                    fullString.append(NSAttributedString(string: message.time, attributes: style))
                default:
                    break
                }
            } else {
                fullString.append(NSAttributedString(string: message.time, attributes: style))
            }
        }
        metadataLabel?.attributedText = fullString
    }
    
    // MARK: - Setup View
    private func setupView() {
        let avatarTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        selectionStyle = .none
        statusMetadataImageView?.isHidden = true
        containerView?.layer.backgroundColor = AmityColorSet.blue.cgColor
        containerView?.layer.cornerRadius = 8.0
        containerView?.menuItems = [deleteMenuItem]
        errorButton?.isHidden = true
        displayNameLabel?.font = AmityFontSet.displayNameLabelFont
        displayNameLabel?.textColor = AmityColorSet.lightBlue
        contentView.backgroundColor = AmityColorSet.backgroundBlue
    }

    @objc private func avatarTapped() {
//        let guestInfoController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
//        let displayData = EventGuestInfoDisplayData(avatarUrl: <#T##URL#>, fullName: <#T##String#>, role: <#T##String?#>, isCommissioner: <#T##Bool#>)
//        let guestInfoView = EventGuestInfoView(displayData: displayData)
//        guestInfoController.view.addSubview(guestInfoView)
//        guestInfoView.clipsToBounds = true
//        guestInfoView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            guestInfoView.topAnchor.constraint(equalTo: guestInfoController.view.topAnchor),
//            guestInfoView.rightAnchor.constraint(equalTo: guestInfoController.view.rightAnchor),
//            guestInfoView.leftAnchor.constraint(equalTo: guestInfoController.view.leftAnchor),
//            guestInfoView.heightAnchor.constraint(equalToConstant: EventGuestInfoView.height)
//        ])
//
//        guestInfoController.view.clipsToBounds = true
//        guestInfoController.view.translatesAutoresizingMaskIntoConstraints = false
//        guestInfoController.view.heightAnchor.constraint(equalToConstant: 304.0).isActive = true
//
//        let okAction = UIAlertAction(title: "OK", style: .default)
//        guestInfoController.addAction(okAction)
//        dependencies.navigationController.present(guestInfoController, animated: true)
    }

    private func setDisplayName(for message: AmityMessageModel) {
        setDisplayName(message.displayName)
    }
    
    private func setDisplayName(_ name: String?) {
        displayNameLabel?.text = name
    }
    
    private func setAvatarImage(_ messageModel: AmityMessageModel) {
        if let urlString = messageModel.object.user?.avatarCustomUrl {
            avatarView.imageView.kf.setImage(with: URL(string: urlString))
        }
    }

}

// MARK: - Action
private extension AmityMessageTableViewCell {
    @objc
    func editTap() {
        screenViewModel.action.performCellEvent(for: .edit(indexPath: indexPath))
    }
    
    @objc
    func deleteTap() {
        switch message.syncState {
        case .error:
            screenViewModel.action.performCellEvent(for: .deleteErrorMessage(indexPath: indexPath))
        default:
            screenViewModel.action.performCellEvent(for: .delete(indexPath: indexPath))
        }
        
    }
    
    @objc
    func reportTap() {
        screenViewModel.action.performCellEvent(for: .report(indexPath: indexPath))
    }
    
    @IBAction func errorTap() {
        screenViewModel.action.performCellEvent(for: .deleteErrorMessage(indexPath: indexPath))
    }
    
}
