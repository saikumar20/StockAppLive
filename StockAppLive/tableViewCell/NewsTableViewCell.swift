//
//  NewsTableViewCell.swift
//  StockAppLive
//
//  Created by Test on 22/06/25.
//

import UIKit
import SDWebImage

class NewsTableViewCell: UITableViewCell {
    
    let datelbl : UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    
    let title : UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 3
        return label
    }()
    
    let companyImage : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addsubviews(view: datelbl,title,companyImage)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyconstaraint()
    }
    
    func applyconstaraint() {
        
        NSLayoutConstraint.activate([
        
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            title.trailingAnchor.constraint(equalTo: companyImage.leadingAnchor, constant: -5),
            title.bottomAnchor.constraint(equalTo: datelbl.topAnchor, constant: 3),
            
            datelbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            datelbl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            datelbl.trailingAnchor.constraint(equalTo: companyImage.leadingAnchor, constant: 5),
            
           
            companyImage.widthAnchor.constraint(equalToConstant: 110),
            companyImage.heightAnchor.constraint(equalToConstant: 100),
            companyImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 8),
            companyImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            companyImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        
        ])
        
    }
    
    func addsubviews(view : UIView...) {
        view.forEach { com in
            com.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(com)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        datelbl.text = nil
        title.text = nil
        companyImage.image = nil
    }
    
    func databinding(_ data : NewList) {
        title.text = data.title
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        let date = formatter.date(from: data.publishedAt ?? "")
        
        formatter.dateFormat = "yyyy-MM-dd"
        let updatedDate = formatter.string(from: date!)

        
        datelbl.text = updatedDate
        
        companyImage.sd_setImage(with: URL(string: data.imageURL ?? ""))
        
        
    }

}
