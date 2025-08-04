//
//  StockDetailsHeader.swift
//  StockAppLive
//
//  Created by Test on 18/06/25.
//

import Foundation
import UIKit

struct graphicMetric  {
    
    let name : String?
    let value : String?
}

class StockDetailsHeader : UIView,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
   
    
    var chart = customChart()
    var symbol : String?
    var mertricData : [graphicMetric]?
    var HeaderCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.collectionView?.isScrollEnabled = false
        layout.scrollDirection = .horizontal
        
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.register(StockDetailsCollectionViewCell.self, forCellWithReuseIdentifier: "StockDetailsCollectionViewCell")
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        return collectionview
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addview(view: HeaderCollectionView,chart)
        HeaderCollectionView.delegate = self
        HeaderCollectionView.dataSource = self
        HeaderCollectionView.isScrollEnabled = false
    }
    
    func addview(view : UIView...) {
        view.forEach { component in
            addSubview(component)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        chart.frame = CGRect(x: 0, y: 0, width: self.width, height: self.height - 120)
        HeaderCollectionView.frame = CGRect(x: 0, y: self.height - 120, width: self.width, height: 120)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dataBinding(chartData : chartModel , mertricData : [graphicMetric] ) {
        self.mertricData = mertricData
        chart.setupchart(data: chartData)
        DispatchQueue.main.async {
            self.HeaderCollectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        mertricData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: width/2, height: 132/4)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StockDetailsCollectionViewCell", for: indexPath) as! StockDetailsCollectionViewCell
        if let data = mertricData?[indexPath.row] {
            cell.databinding(data)
        }
    
        return cell
    }
    
    
    
    
    
}
