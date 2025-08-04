//
//  HomeViewController.swift
//  StockAppLive
//
//  Created by Test on 07/06/25.
//

import UIKit

protocol uiUpdatation {
    func maxWidthUpdate(value : CGFloat)
}

struct Constants {
   static let oneDay : TimeInterval = 24 * 3600
    static let apiKey :  String = "d15gv21r01qhqto5pee0d15gv21r01qhqto5peeg"
    static let sandboxApiKey : String = "SANDBOX KEY HERE"
    static let baseUrl : String = "https://finnhub.io/api/v1//"
    static let chartBaseUrl : String = "https://query1.finance.yahoo.com/v8/finance/"
    static let newsFeed : String = "https://api.marketaux.com/v1/"
}

class HomeViewController: UIViewController {
    
    let homeTableView : UITableView = {
        let tableview = UITableView(frame: .zero, style: .plain)
       tableview.separatorStyle = .none
        tableview.register(stockTableViewCell.self, forCellReuseIdentifier: "stockTableViewCell")
        return tableview
    }()
    
    let liveimage : UIImageView = {
       let image = UIImageView()
        image.backgroundColor = .systemGreen
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var context = ((UIApplication.shared.delegate) as? AppDelegate)?.persistentContainer.viewContext
    
    

    
   static var rightMaxWidth : CGFloat = 0.0
    var stockData : [String : [convertData]] = [:]
    
    var stockGraphData : [String : [convertData]] = [:]
    var cellData : [cellData]?
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        liveimage.layer.cornerRadius = liveimage.frame.height / 2
        homeTableView.frame = self.view.bounds
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()

        addsubviews()
        //fetchData()
        fetchChartData()
    }
    

    
    
    func fetchData() {
        let symbols = localPresistance.shared.symbolList
        constructModel()
        let group = DispatchGroup()
        
        for symbol in symbols {
            group.enter()
            ApiserviceHandler.shared.fetchDataForSymbol(for: symbol) { response in
              
                defer{
                    group.leave()
                }
                
                switch response {
                case .success(let data) :
                    let stock = data.stockData
                    self.stockData[symbol]  = stock
                case .failure(let error) :
                    print(error)
            }
                
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.constructstockdata()
            self?.homeTableView.reloadData()
        }
        
    }
    
    
    func fetchChartData() {
        
        let group = DispatchGroup()
        
        var symbols = localPresistance.shared.symbolList
        
        for symbol in symbols {
            group.enter()
            
            ApiserviceHandler.shared.fetchDataForSymbolChart(for: symbol) { response in
                
                defer {
                    group.leave()
                }
                
                switch response {
                case .success(let data) :
                    let stock = data.chart?.result?.first?.stockData
                    self.stockData[symbol]  = stock

                    
                    
                    
                case .failure(let error) :
                    print(error)
                }
                
            }
        }
        group.notify(queue: .main) { [weak self] in
            self?.constructstockdata()
            
        }
        
    }
    
    func constructModel() {
        var model : [cellData]?
        let symbols = localPresistance.shared.symbolList
        
        symbols.forEach { item in
            
            let request = WatchListModel.fetchRequest()
            request.predicate = NSPredicate(format: "symbol == %@", item)
            var companyname : WatchListModel?
            do {
                let result = try context?.fetch(request)
                companyname = result?.first
            }catch {
               
            }
            model?.append(.init(symbol: item, companyName: companyname?.value ?? "company", price: "0.00", changeColor: .systemGray, changePercentage: "unch", chartData: .init(value: [], showLegend: false, showAxis: false, color: .clear)))
        }
        
        self.homeTableView.reloadData()
    }
    
    func constructstockdata() {
        var model : [cellData]?
        
        if model == nil {
            model = []
        }
        var unknowncompany = "company"
        for(symbol, value) in stockData {
            
            let request = WatchListModel.fetchRequest()
            request.predicate = NSPredicate(format: "symbol == %@", symbol)
            var companyname : WatchListModel?
            do {
                let result = try context?.fetch(request)
                companyname = result?.first
            }catch {
               
            }
            
            let change = value.getChangePercentage()
           
            model?.append(.init(symbol: symbol, companyName: companyname?.value ?? unknowncompany , price: getLastestClosePrice(value), changeColor: ((change > 0 ? UIColor(named: "chartgreen") : UIColor(named: "chartred")) ?? .systemGray) ,  changePercentage: .numberFormattor(change), chartData: .init(value: value.reversed().map{$0.close}, showLegend: false, showAxis: false, color: ((change > 0 ? UIColor(named: "chartgreen") : UIColor(named: "chartred")) ?? .systemGray))))
            
        }
        
        self.cellData =  model?.sorted(by: {$0.symbol < $1.symbol})
        self.homeTableView.reloadData()
    }
    
    func addsubviews() {
        
        view.addSubview(homeTableView)
        homeTableView.delegate = self
        homeTableView.dataSource = self
        
        homeTableView.backgroundColor = .black
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.navigationController?.navigationBar.frame.height ?? 100))
        
        let titlelable : UILabel = {
            let title = UILabel()
            title.translatesAutoresizingMaskIntoConstraints = false
            title.adjustsFontSizeToFitWidth = true
            title.minimumScaleFactor = 0.80
            title.font = .systemFont(ofSize: 22, weight: .bold)
            title.textColor = .white
            title.text  = "Stock"
            title.textAlignment = .center
            
            return title
        }()
        
        let subtitlelabel : UILabel = {
            let subtitle = UILabel()
            subtitle.textAlignment = .center
            subtitle.translatesAutoresizingMaskIntoConstraints = false
            subtitle.adjustsFontSizeToFitWidth = true
            subtitle.minimumScaleFactor = 0.80
            subtitle.font = .systemFont(ofSize: 16, weight: .regular)
            subtitle.textColor = .white
            subtitle.text = "Live"
            return subtitle
        }()
        
       
        
        let substack : UIStackView = {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.distribution = .fill
            stack.spacing = 4
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()
        
        let mainstackView : UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.distribution = .fill
            stack.spacing = 4
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()

        
        substack.addArrangedSubview(subtitlelabel)
        substack.addArrangedSubview(liveimage)
        
        mainstackView.addArrangedSubview(titlelable)
        mainstackView.addArrangedSubview(substack)
        
        titleView.addSubview(mainstackView)
        
        self.navigationItem.titleView = titleView
       
        NSLayoutConstraint.activate([
        
            mainstackView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
            mainstackView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
            liveimage.widthAnchor.constraint(equalToConstant: 16),
            liveimage.heightAnchor.constraint(equalToConstant: 16)
        
        ])
    }
}
extension HomeViewController : uiUpdatation {
    func maxWidthUpdate(value: CGFloat) {
        self.homeTableView.reloadData()
    }
    
    func getLastestClosePrice(_ data : [convertData]) -> String {
        guard let number = data.first?.close else {return ""}
        return String.numberFormattor(number)
    }
    
    
}

extension HomeViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.cellData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockTableViewCell", for: indexPath) as!  stockTableViewCell
        if let data = cellData?[indexPath.row] {
            cell.updateCell(data: data)
        }
       
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            if let sym = cellData?[indexPath.row].symbol {
                localPresistance.shared.deleteData(sym)
            }
            
            
            self.cellData?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            tableView.endUpdates()
        } else if editingStyle == .insert {
            tableView.beginUpdates()
            self.cellData?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            tableView.endUpdates()
        }
    }
    
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let data = cellData?[indexPath.row] else {return}
        
        let vc = stockDetailsViewController(symbol: data.symbol , companyName: data.companyName)
        
        let nav = UINavigationController(rootViewController: vc)
        
        self.present(nav, animated: true)
        
    }
    
    
}

extension String {
    
    static func numberFormattor(_ value : Double) -> String {
        let numberFormattor = NumberFormatter.changePercentageFormattor
        return numberFormattor.string(from: NSNumber(value: value)) ?? "\(value)"
    }
    
    
}

extension NumberFormatter {
    
    static let changePercentageFormattor : NumberFormatter = {
        let number = NumberFormatter()
        number.numberStyle = .decimal
        number.maximumFractionDigits = 2
        number.minimumFractionDigits = 2
        return number
    }()
    
}

extension Array where Element == convertData {
    func getChangePercentage() -> Double {
        var latestDate = self[0].date
        
        guard let latest = self.first?.close , let prior = self.first(where: { item in
            !Calendar.current.isDate(item.date, inSameDayAs: latestDate)
        })?.close else {return 0}
        
        let different = 1 - (prior/latest)
        return different
    }
}
