//
//  NewsTableViewCell.swift
//  newsApp
//
//  Created by Никита Кисляков on 31.01.2024.
//

import UIKit

class TableViewCellViewModel {
    let title: String
    let subtitle: String
    let imageURL: URL?
    var imageData: Data?
    
    init(title: String,
         subtitle: String,
         imageURL: URL?,
         imageData: Data? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
        self.imageData = imageData
    }
}

class NewsTableViewCell: UITableViewCell { 

    static let identifier = "TableViewCell"
    
    private let newsTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17, weight: .light)
        return label
    }()
    
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 7
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .systemGray
        imageView.contentMode = .scaleAspectFill
        return imageView
    } ()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsImageView)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(newsTitleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupElements()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsImageView.image = nil
        newsTitleLabel.text = nil
        subtitleLabel.text = nil
    }


    private func setupElements() {
        newsTitleLabel.frame = CGRect(x: 10,
                                      y: 0,
                                      width: contentView.frame.size.width - 170,
                                      height: 70)
        
        subtitleLabel.frame = CGRect(x: 10,
                                     y: 70,
                                     width: contentView.frame.size.width - 170,
                                     height: contentView.frame.size.height / 2)
        
        newsImageView.frame = CGRect(x: contentView.frame.size.width - 150,
                                     y: 5,
                                     width: 140,
                                     height: contentView.frame.size.height - 10)
    }
    
    func configure(with viewModel: TableViewCellViewModel) {
        newsTitleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        
        // Image
        
        if let data = viewModel.imageData {
            newsImageView.image = UIImage(data: data)
        } else if let url = viewModel.imageURL {
            
            // fetch
            
            URLSession.shared.dataTask(with: url, completionHandler: { [weak self] data, _, error in
                guard let data = data, error == nil else { return }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
            })
            .resume()
        }
    }
}


