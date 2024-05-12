//
//  ChatUserInfoView.swift
//  BetTheKnot
//
//  Created by Mateusz Nadolski on 16/08/2023.
//  Copyright © 2023 Instamobile. All rights reserved.
//

import Foundation
import Kingfisher
import UIKit

final class ChatUserInfoView: UIView {

    static let height = 260.0

    private let displayData: ChatUserInfoDisplayData
    private let gradientLayerHeight = 115.0
    private let commissionerViewHeight = 18.0

    private lazy var avatarImageView = makeAvatarImageView()
    private lazy var avatarGradientOverlayView = makeAvatarGradientOverlayView()
    private lazy var gradientLayer = makeGradientLayer()
    private lazy var activityIndicator = makeActivityIndicatorView()
    private lazy var guestInfoStackView = makeGuestInfoStackView()
    private lazy var fullNameLabel = makeFullNameLabel()
    private lazy var roleNameLabel = makeRoleLabel()
    private lazy var commissionerContainerView = makeCommissionerContainerView()
    private lazy var commissionerLabel = makeCommissionerLabel()

    private var spacerView: UIView {
        UIView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientLayerFrame()
        roundCorners(corners: [.topLeft, .topRight], radius: 13.0)
    }

    init(displayData: ChatUserInfoDisplayData) {
        self.displayData = displayData
        super.init(frame: .zero)
        setupView()
        fetchAvatar()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = AmityColorSet.blue
        addSubview(avatarImageView)
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor),
            avatarImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            avatarImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])

        addSubview(avatarGradientOverlayView)
        NSLayoutConstraint.activate([
            avatarGradientOverlayView.heightAnchor.constraint(equalToConstant: 115.0),
            avatarGradientOverlayView.trailingAnchor.constraint(equalTo: trailingAnchor),
            avatarGradientOverlayView.bottomAnchor.constraint(equalTo: bottomAnchor),
            avatarGradientOverlayView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        avatarGradientOverlayView.layer.insertSublayer(gradientLayer, at: 0)

        addSubview(guestInfoStackView)
        NSLayoutConstraint.activate([
            guestInfoStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            guestInfoStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            guestInfoStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10.0)
        ])

        fullNameLabel.text = displayData.fullName
        guestInfoStackView.addArrangedSubview(fullNameLabel)
        guestInfoStackView.setCustomSpacing(5.0, after: fullNameLabel)

        if let role = displayData.role {
            roleNameLabel.text = role
            guestInfoStackView.addArrangedSubview(roleNameLabel)
            guestInfoStackView.setCustomSpacing(7.0, after: roleNameLabel)
        }

        if displayData.isCommissioner {
            addSubview(commissionerContainerView)
            commissionerContainerView.addSubview(commissionerLabel)
            NSLayoutConstraint.activate([
                commissionerContainerView.heightAnchor.constraint(equalToConstant: commissionerViewHeight),
                commissionerContainerView.widthAnchor.constraint(equalToConstant: 70.0),
                commissionerLabel.centerXAnchor.constraint(equalTo: commissionerContainerView.centerXAnchor),
                commissionerLabel.centerYAnchor.constraint(equalTo: commissionerContainerView.centerYAnchor)
            ])
            let commishStackView = UIStackView()
            let leftSpacerView = spacerView
            let rightSpacerView = spacerView
            commishStackView.addArrangedSubview(leftSpacerView)
            commishStackView.addArrangedSubview(commissionerContainerView)
            commishStackView.addArrangedSubview(rightSpacerView)
            NSLayoutConstraint.activate([
                leftSpacerView.widthAnchor.constraint(equalTo: rightSpacerView.widthAnchor)
            ])

            guestInfoStackView.addArrangedSubview(commishStackView)
        }
    }

    private func fetchAvatar() {
        avatarImageView.kf.indicatorType = .custom(indicator: makeActivityIndicatorView())
        avatarImageView.kf.setImage(
            with: displayData.avatarUrl,
            options: [.transition(.fade(0.25))]
        ) { [weak self] result in
            if case .success = result {
                self?.gradientLayer.isHidden = false
            }
        }
    }

    private func updateGradientLayerFrame() {
        gradientLayer.frame = avatarGradientOverlayView.bounds
    }
}

final class ActivityIndicator: UIActivityIndicatorView, Indicator {
    lazy var view: Kingfisher.IndicatorView = self

    func startAnimatingView() {
        startAnimating()
    }

    func stopAnimatingView() {
        stopAnimating()
    }
}

extension ChatUserInfoView {
    func makeAvatarImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }

    func makeAvatarGradientOverlayView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    func makeGradientLayer() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.isHidden = true
        return gradientLayer
    }

    func makeActivityIndicatorView() -> ActivityIndicator {
        let activityIndicator = ActivityIndicator()
        activityIndicator.color = AmityColorSet.lightBlue
        return activityIndicator
    }

    func makeGuestInfoStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }

    func makeFullNameLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18.0, weight: .medium)
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    func makeRoleLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .medium)
        label.textAlignment = .center
        label.textColor = AmityColorSet.textGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    func makeCommissionerContainerView() -> UIView {
        let view = UIView()
        view.layer.backgroundColor = AmityColorSet.yourUserIndicatorBackgroundColor.cgColor
        view.layer.cornerRadius = commissionerViewHeight / 2.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    func makeCommissionerLabel() -> UIView {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0, weight: .semibold)
        label.text = "Commish"
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
