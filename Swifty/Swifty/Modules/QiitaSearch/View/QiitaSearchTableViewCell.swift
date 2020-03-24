//
//  QiitaSearchTableViewCell.swift
//  Swifty
//
//  Created by Yuki Okudera on 2020/03/22.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

import UIKit

protocol QiitaSearchTableViewCellDelegate: AnyObject {
    func didTapUserIcon(indexPath: IndexPath)
    func didTapGitHubIcon(indexPath: IndexPath)
}

final class QiitaSearchTableViewCell: UITableViewCell {
    
    weak var delegate: QiitaSearchTableViewCellDelegate?
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var githubImageView: UIImageView!
    @IBOutlet private weak var createdDateLabel: UILabel!
    @IBOutlet private weak var updatedDateLabel: UILabel!
    @IBOutlet private weak var tagLabel: UILabel!
    
    private var indexPath: IndexPath?
    private var qiitaItem: QiitaItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        githubImageView.image = UITraitCollection.isDarkMode ? #imageLiteral(resourceName: "github_darkmode") : #imageLiteral(resourceName: "github")
        githubImageView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(tappedGitHubIcon(_:)))
        )
        
        thumbnailImageView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(tappedUserIcon(_:)))
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        githubImageView.image = UITraitCollection.isDarkMode ? #imageLiteral(resourceName: "github_darkmode") : #imageLiteral(resourceName: "github")
        thumbnailImageView.image = nil
    }
    
    func set(qiitaItem: QiitaItem?, indexPath: IndexPath, delegate: QiitaSearchTableViewCellDelegate?) {
        self.qiitaItem = qiitaItem
        self.indexPath = indexPath
        self.delegate = delegate
        
        guard let qiitaItem = qiitaItem else {
            return
        }
        titleLabel.text = qiitaItem.title
        
        if let createdAt = qiitaItem.createdAt {
            let createdDate = createdAt.toDate(dateFormat: .yyyyMMddHHmmssZ_Hyphen)
            let createdDateString = createdDate?.toString(dateFormat: .yyyyMMdd_Hyphen)
            createdDateLabel.text = createdDateString
        }
        
        if let updatedAt = qiitaItem.updatedAt {
            let updatedDate = updatedAt.toDate(dateFormat: .yyyyMMddHHmmssZ_Hyphen)
            let updatedDateString = updatedDate?.toString(dateFormat: .yyyyMMdd_Hyphen)
            updatedDateLabel.text = updatedDateString
        }
        
        if let profileImageUrl = qiitaItem.user?.profileImageUrl {
            thumbnailImageView.setImageByNuke(url: profileImageUrl.toURL())
        }
        if qiitaItem.makeGitHubUserUrlString() == nil {
            githubImageView.isHidden = true
        } else {
            githubImageView.isHidden = false
        }
        
        tagLabel.text = qiitaItem.tags.compactMap { $0.name }.joined(separator: ", ")
    }
}

extension QiitaSearchTableViewCell {
    
    @objc
    func tappedGitHubIcon(_ sender: UITapGestureRecognizer) {
        guard qiitaItem?.makeGitHubUserUrlString() != nil else {
            return
        }
        guard let indexPath = self.indexPath else {
            return
        }
        delegate?.didTapGitHubIcon(indexPath: indexPath)
    }
    
    @objc
    func tappedUserIcon(_ sender: UITapGestureRecognizer) {
        guard qiitaItem?.makeQiitaUserUrlString() != nil else {
            return
        }
        guard let indexPath = self.indexPath else {
            return
        }
        delegate?.didTapUserIcon(indexPath: indexPath)
    }
}

extension QiitaSearchTableViewCell: TableViewNibRegistrable {}

