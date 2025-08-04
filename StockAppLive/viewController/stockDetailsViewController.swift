//
//  stockDetailsViewController.swift
//  StockAppLive
//
//  Created by Test on 18/06/25.
//

import UIKit
import SafariServices





class stockDetailsViewController: UIViewController {
    
    var symbol : String?
    var companyName : String?
    var stockData :  [convertData]?
    var metricData : Meta?
    var cellData : cellData?
    var context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    var stockDeatislheader = StockDetailsHeader()
    var newsData : [NewList]?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = companyName
         setupCloseButton()
        view.addSubview(stockDetailsTableView)
        stockDetailsTableView.delegate = self
        stockDetailsTableView.dataSource = self
        fectchnewsData()
        fetchChartData()
    }
    
    var stockDetailsTableView : UITableView = {
        let tableview = UITableView(frame: .zero, style: .plain)
        tableview.register(NewsTableViewCell.self, forCellReuseIdentifier: "NewsTableViewCell")
        tableview.register(watchListHeader.self, forHeaderFooterViewReuseIdentifier: "watchListHeader")
        return tableview
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        stockDetailsTableView.frame = self.view.bounds
    }

    func setupCloseButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeAction))
    }
    
    @objc func closeAction() {
        self.dismiss(animated: true)
    }
    
    
    init(symbol: String, companyName: String) {
        self.symbol = symbol
        self.companyName = companyName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fetchChartData() {
        
        ApiserviceHandler.shared.fetchDataForSymbolChart(for: symbol ?? "") { response in
                
                switch response {
                case .success(let data) :
                    let stock = data.chart?.result?.first?.stockData
                    let metric = data.chart?.result?.first?.meta
                    self.stockData = stock
                    self.metricData = metric
                    DispatchQueue.main.async {
                        self.constructstockdata()
                    }
                case .failure(let error) :
                    print(error)
                }
            }
    }
    
    
   
    
    
    func constructstockdata() {
       
        var unknowncompany = "company"
            let request = WatchListModel.fetchRequest()
        request.predicate = NSPredicate(format: "symbol == %@", symbol ?? "")
            var companyname : WatchListModel?
            do {
                let result = try context?.fetch(request)
                companyname = result?.first
            }catch {
               
            }
            
        let change = stockData?.getChangePercentage()
        
        let chartValues: [Double] = stockData?.reversed().compactMap { $0.close } ?? []
        let color: UIColor = (change ?? 0 > 0 ? UIColor(named: "chartgreen") : UIColor(named: "chartred")) ?? .systemGray
        let chartData = chartModel(value: chartValues, showLegend: false, showAxis: false, color: color)

        
        var model = StockAppLive.cellData(symbol: symbol ?? "",
                                          companyName: companyname?.value ?? "", price: getLastestClosePrice(stockData!), changeColor: color, changePercentage: .numberFormattor(change ?? 0.0),  chartData: chartData)

        self.cellData = model
        DispatchQueue.main.async {
            self.setupHeader()
        }
    }
    
   
    func getLastestClosePrice(_ data : [convertData]) -> String {
        guard let number = data.first?.close else {return ""}
        return String.numberFormattor(number)
    }
    
    func fectchnewsData() {
        
        ApiserviceHandler.shared.fetchNewsFeed(symbol: symbol ?? "") { [weak self] result in
            switch result {
            case .success(let data) :
                if self?.newsData == nil {
                    self?.newsData = []
                }
                self?.newsData = data.data
                DispatchQueue.main.async {
                    self?.stockDetailsTableView.reloadData()
                }
            case .failure(let error) :
                print(error)
            }
        }
        
    }
    
    func setupHeader() {
        
        let header = StockDetailsHeader(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: (view.width * 0.7) + 100))
        
        
        
        var metric :[graphicMetric] = []
        
        if let data = metricData {
            metric.append(.init(name: "52W high", value: String( format: "%.2f", data.fiftyTwoWeekHigh ?? 0)))
            
            metric.append(.init(name: "52W low", value: String( format: "%.2f", data.fiftyTwoWeekLow ?? 0)))
            
            
            metric.append(.init(name: "Regular Marketprice", value: String( format: "%.2f", data.regularMarketPrice ?? 0)))
            
            metric.append(.init(name: "Regular Market Day High", value: String( format: "%.2f", data.regularMarketDayHigh ?? 0)))
            
            metric.append(.init(name: "Regular Market Day Low",  value: String( format: "%.2f", data.regularMarketDayLow ?? 0)))
            
        }
        
        let change = stockData?.getChangePercentage() ?? 0
        
        if let data = stockData {
            header.dataBinding(chartData: .init(value: data.reversed().map{$0.close}, showLegend: true, showAxis: true, color: ((change > 0 ? UIColor(named: "chartgreen") : UIColor(named: "chartred")) ?? .systemGray)), mertricData: metric)
        }
        
        self.stockDetailsTableView.tableHeaderView = header
        
    }

}


extension stockDetailsViewController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
        if let data = newsData?[indexPath.row] {
            cell.databinding(data)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        HapticManager.shared.vibrationWhileSelecting()
        
        if let urlValue =  self.newsData?[indexPath.row].url {
            
            guard let url = URL(string: urlValue)else {return}
             let vc = SFSafariViewController(url: url)
              present(vc, animated: true)
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headercell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "watchListHeader") as! watchListHeader
        headercell.backgroundColor = .gray
        headercell.delegate = self
        headercell.hideBtnAddText(title: symbol, ishide: localPresistance.shared.cotainsWatchList(symbol : symbol ?? ""))
       
        
        return headercell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
}
extension stockDetailsViewController : addWatchListProtocol {
    func addWatchList(classs : watchListHeader) {
        HapticManager.shared.vibrate(type: .success)
        classs.watchlistbutton.isHidden = true
        localPresistance.shared.addwatchList(symbol: symbol ?? "", description: companyName ?? "")
        self.stockDetailsTableView.reloadData()
        
    }
}
