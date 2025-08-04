//
//  watchListHeader.swift
//  StockAppLive
//
//  Created by Test on 22/06/25.
//

protocol addWatchListProtocol {
    func addWatchList(classs : watchListHeader)
}

import UIKit

class watchListHeader: UITableViewHeaderFooterView {
    
    var delegate : addWatchListProtocol?
    var centerLayout : NSLayoutConstraint!
    var leadingConstrainnt : NSLayoutConstraint!

    let headertitle : UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let watchlistbutton : UIButton = {
        let button  = UIButton()
        button.setTitle("Add WatchList", for: .normal)
        button.backgroundColor = UIColor(named: "watchbackground")
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add WatchList", for: .normal)
        button.addTarget(self, action: #selector(watchList), for: .touchUpInside)
        return button
    }()
    
    let headerStack : UIStackView = {
       let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.distribution = .equalSpacing
        stackview.backgroundColor = .black
        stackview.translatesAutoresizingMaskIntoConstraints = false
        return stackview
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        watchlistbutton.layer.cornerRadius = 12
        
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .darkGray
        
        watchlistbutton.sizeToFit()
        headertitle.sizeToFit()

        addcomponent(view: headertitle,watchlistbutton)
       
        applyconstraints()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addcomponent(view : UIView...){
        view.forEach { component in
            contentView.addSubview(component)
        }
    }
    
    func applyconstraints() {
        
        centerLayout = headertitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        centerLayout.isActive = false
        
        leadingConstrainnt = headertitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15)
        
        leadingConstrainnt.isActive = false
        
        NSLayoutConstraint.activate([
            
            headertitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
           
            watchlistbutton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
    
            watchlistbutton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            
            watchlistbutton.heightAnchor.constraint(equalToConstant: 50),
            watchlistbutton.widthAnchor.constraint(equalToConstant: watchlistbutton.width + 20)
        ])
    }
    
   
    @objc func watchList() {
        
        delegate?.addWatchList(classs: self)
        
    }
    
    
    func hideBtnAddText(title : String? , ishide : Bool?) {
        self.headertitle.text = title
        self.watchlistbutton.isHidden = ishide ?? false
        centerLayout.isActive = ishide ?? false
        
        if ishide == true {
            leadingConstrainnt.isActive = false
        }else {
            leadingConstrainnt.isActive = true
        }
        
        
    }
    
    
}
