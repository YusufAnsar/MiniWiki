//
//  SearchItemTableViewCell.swift
//  MiniWiki
//
//  Created by Yusuf Ansar on 30/09/18.
//  Copyright © 2018 MoneyTap. All rights reserved.
//

import UIKit

class SearchItemTableViewCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    

    func configureCell(with searchItem: SearchItem) {
        titleLabel.text = searchItem.title
        descriptionLabel.text = searchItem.articleDescription
        itemImageView.loadImageUsingCacheWithURLString(searchItem.thumbnailImageURLString ?? "", placeHolder: #imageLiteral(resourceName: "placeholder"))
    }
    
    func configureCell(with article: Article) {
        titleLabel.text = article.title
        descriptionLabel.text = article.articleDescription
    }

}
