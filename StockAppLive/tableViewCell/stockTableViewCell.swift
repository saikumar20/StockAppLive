//
//  stockTableViewCell.swift
//  StockAppLive
//
//  Created by Test on 07/06/25.
//

import UIKit

struct cellData {
    var symbol : String
    var companyName : String
    var price : String
    var changeColor : UIColor
    var changePercentage : String
    var chartData : chartModel
}



class stockTableViewCell: UITableViewCell {
    
    
    let companyShortName : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    let companyName : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    let price : UILabel =  {
       let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .right
        return label
    }()
    
    let changeNumber : UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .right
        label.layer.cornerRadius = 8
        return label
    }()
    
    let chart : customChart = {
       let customChart = customChart()
        customChart.clipsToBounds = true
       return customChart
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        addViews(companyShortName,companyName,price,changeNumber,chart)
    }
    
    
    func addViews(_ views : UIView...){
        views.forEach {
            addSubview($0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var delegate : uiUpdatation?

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        companyShortName.sizeToFit()
        companyName.sizeToFit()
        price.sizeToFit()
        changeNumber.sizeToFit()
        
        companyShortName.frame = CGRect(x: CGFloat(Int(separatorInset.left)), y: (contentView.frame.height - companyShortName.frame.height - companyName.frame.height)/2, width: companyShortName.width, height: companyShortName.height)
        
        companyName.frame = CGRect(x: Int(CGFloat(Int(separatorInset.left))), y: Int(companyShortName.bottom), width: Int(companyName.width), height: Int(companyName.height))
        
        let compareWidth = max(max(price.width,changeNumber.width),HomeViewController.rightMaxWidth)
        
        if compareWidth > HomeViewController.rightMaxWidth {
            delegate?.maxWidthUpdate(value: compareWidth)
        }
        
        price.frame =  CGRect(x: CGFloat(Int(contentView.width - (compareWidth + 10))), y: CGFloat(Int(contentView.height - price.height - changeNumber.height)/2) , width: compareWidth, height: price.height)

        changeNumber.frame = CGRect(x: CGFloat(Int(contentView.width - (compareWidth + 10))), y: CGFloat(Int(price.bottom)), width: compareWidth, height: changeNumber.height)
        
        chart.frame = CGRect(x: CGFloat(Int(price.left - (contentView.width/3 + 5))) , y: 6, width: contentView.width/3, height: contentView.height - 12)
        
        
//        miniChartView.frame = CGRect(
//            x: priceLabel.left - (contentView.width / 3 + 5),
//            y: 6,
//            width: contentView.width / 3,
//            height: contentView.height - 12
//        )
        
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        companyShortName.text = nil
        companyName.text = nil
        price.text = nil
        changeNumber.text = nil
        chart.reset()
    }
    
    func updateCell(data : cellData) {
        companyShortName.text = data.symbol
        companyName.text = data.companyName
        price.text = data.price
        changeNumber.text = data.changePercentage
        chart.setupchart(data: data.chartData)
    }
    
  

}


extension UIView {
    
    var top : CGFloat {
        self.frame.origin.y
    }
    
    var height : CGFloat {
        self.frame.size.height
    }
    
    var bottom : CGFloat {
        top + height
    }
    
    var width : CGFloat {
        frame.size.width
    }
    
    var left : CGFloat {
        frame.origin.x
    }
    
    
}
