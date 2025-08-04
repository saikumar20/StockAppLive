//
//  StockDetailsCollectionViewCell.swift
//  StockAppLive
//
//  Created by Test on 19/06/25.
//

import UIKit

class StockDetailsCollectionViewCell: UICollectionViewCell {
    
    
    var namelbl : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var valuelbl : UILabel = {
        let lable = UILabel()
        lable.font = .systemFont(ofSize: 15, weight: .medium)
        lable.textColor = .white
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    func databinding(_ data : graphicMetric) {
        namelbl.text = "\(String(describing: data.name ?? "")) : "
        valuelbl.text = data.value
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(namelbl)
        contentView.addSubview(valuelbl)
        applyconstraint()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        

       
    }
    
    func applyconstraint() {
        namelbl.sizeToFit()
        valuelbl.sizeToFit()
        namelbl.numberOfLines = 2
        namelbl.setContentHuggingPriority(.defaultLow, for: .horizontal)
        namelbl.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        valuelbl.setContentHuggingPriority(.required, for: .horizontal)
        valuelbl.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        NSLayoutConstraint.activate([
            namelbl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            namelbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            namelbl.trailingAnchor.constraint(equalTo: valuelbl.leadingAnchor, constant: -4),
            
            valuelbl.centerYAnchor.constraint(equalTo: namelbl.centerYAnchor),
            valuelbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])
        
        
    }
   
    override func prepareForReuse() {
        super.prepareForReuse()
        namelbl.text = nil
        valuelbl.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
