//
//  QiitaSearchTableViewCell.swift
//  Swifty
//
//  Created by Yuki Okudera on 2020/03/22.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

import UIKit

final class QiitaSearchTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var githubImageView: UIImageView!
    @IBOutlet private weak var createdDateLabel: UILabel!
    @IBOutlet private weak var updatedDateLabel: UILabel!
    @IBOutlet private weak var tagLabel: UILabel!
    
    private let githubUrlBase = "https://github.com/"
    private var githubUrlString = ""
    
    var qiitaItem: QiitaItem? {
        didSet {
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
            if let githubLoginName = qiitaItem.user?.githubLoginName {
                githubImageView.isHidden = false
                githubUrlString = githubUrlBase + githubLoginName
            } else {
                githubImageView.isHidden = true
                githubUrlString = ""
            }
            
            tagLabel.text = qiitaItem.tags.compactMap { $0.name }.joined(separator: ", ")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        githubImageView.image = UITraitCollection.isDarkMode ? #imageLiteral(resourceName: "github_darkmode") : #imageLiteral(resourceName: "github")
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openGitHubPage(_:)))
        githubImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        githubUrlString = ""
        githubImageView.image = UITraitCollection.isDarkMode ? #imageLiteral(resourceName: "github_darkmode") : #imageLiteral(resourceName: "github")
        thumbnailImageView.image = nil
    }
}

extension QiitaSearchTableViewCell {
    
    @objc
    func openGitHubPage(_ sender: UITapGestureRecognizer) {
        if githubUrlString.isEmpty {
            return
        }
        UIApplication.shared.open(githubUrlString.toURL(), options: [:]) { result in
            if !result {
                print(debug: "GitHubのページを表示できませんでした")
            }
        }
    }
}

extension QiitaSearchTableViewCell: TableViewNibRegistrable {}

