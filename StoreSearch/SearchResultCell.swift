//
//  SearchResultCell.swift
//  StoreSearch
//
//  Created by Максим on 31.01.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artworkImageView: UIImageView!

    var downloadTask: NSURLSessionDownloadTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let selectedView = UIView(frame: CGRect.zero)
        selectedView.backgroundColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 0.5)
        
        selectedBackgroundView = selectedView
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureForSearchResult(searchResult: Result) {
        nameLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        nameLabel.text = searchResult.getName()
        
        artistNameLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        if searchResult.getArtistName().isEmpty {
            artistNameLabel.text = "Unknown"
        } else {
            artistNameLabel.text = String(format: "%@ (%@)", searchResult.getArtistName(), searchResult.getKindForDisplay())
        }
        artworkImageView.image = UIImage(named: "Placeholder")
        if let url = searchResult.getArtworkImageURL60() {
            downloadTask = artworkImageView.loadImageWithUrl(url)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        downloadTask?.cancel()
        downloadTask = nil
        
        nameLabel.text = nil
        artistNameLabel.text = nil
        artworkImageView.image = nil
    }
}
