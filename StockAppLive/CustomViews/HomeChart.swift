//
//  HomeChart.swift
//  StockAppLive
//
//  Created by Test on 07/06/25.
//


import Charts
import UIKit
import DGCharts
import Charts


struct chartModel {
    let value : [Double]
    let showLegend : Bool
    let showAxis : Bool
    let color : UIColor
}


final class customChart : UIView {
    
    let chart : LineChartView = {
       let chart = LineChartView()
        chart.setScaleEnabled(false)
        chart.leftAxis.enabled = false
        chart.rightAxis.enabled = false
        chart.legend.enabled = false
        chart.drawGridBackgroundEnabled = false
       return chart
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(chart)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.chart.frame = bounds
    }
    
    func setupchart(data : chartModel) {
       
        var chartData = [ChartDataEntry]()
        chart.xAxis.enabled = data.showAxis
        
        for(index,value) in data.value.enumerated() {
            chartData.append(.init(x: Double(index), y: value))
        }
        
        let dataset = LineChartDataSet(entries: chartData, label: "7 days")
        dataset.label?.removeAll()
        dataset.fillColor = data.color
        dataset.drawIconsEnabled = false
        dataset.drawCirclesEnabled = false
        dataset.drawValuesEnabled = false
        dataset.drawFilledEnabled = true
        dataset.colors = [NSUIColor(red: 165/256, green: 165/256, blue: 165/256, alpha: 1)]
        chart.data = LineChartData(dataSet: dataset)

    }
    
    
    func reset() {
        chart.data = nil
    }
    
    
}
