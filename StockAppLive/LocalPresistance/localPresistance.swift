//
//  localPresistance.swift
//  StockAppLive
//
//  Created by Test on 10/06/25.
//

import Foundation
import CoreData
import UIKit

struct presistanceConstantKey {
    static let isOnboarded = "isOnboarded"
}

class localPresistance {
    
    static let shared = localPresistance()
    let context = ((UIApplication.shared.delegate) as! AppDelegate).persistentContainer.viewContext
    var userdefault = UserDefaults.standard
    
    let appdelegatecontext  = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    
    var symbolList : [String] {
      //  userdefault.removeObject(forKey: presistanceConstantKey.isOnboarded)
        if isOnBoarded == false {
            userdefault.setValue(true, forKey: presistanceConstantKey.isOnboarded)
            setUpDefaultData()
        }
        
        let request : NSFetchRequest<WatchListModel> = WatchListModel.fetchRequest()
        var datum = [WatchListModel]()
        do{
            datum = try context.fetch(request)
        }catch {
            
        }
        
        let symbols = datum.compactMap{$0.symbol}
        return symbols
    }
    
    var isOnBoarded : Bool {
        return userdefault.bool(forKey: presistanceConstantKey.isOnboarded)
    }
    
    func addwatchList(symbol : String , description : String) {
        
      let watchlist =  SelectedWatchList(context: context)
        
        watchlist.symbol = symbol
        watchlist.companyDescription = description
        do{
            try context.save()
        }catch {
            print("watchlist not saved")
        }
        
    }
    
    
    func cotainsWatchList(symbol : String) -> Bool{
        let request :  NSFetchRequest<SelectedWatchList> =  SelectedWatchList.fetchRequest()
        
        request.predicate = NSPredicate(format: "symbol == %@", symbol)
        let data : SelectedWatchList?
        do {
            data = try context.fetch(request).first
            return data?.symbol == symbol
        }catch {
            return false
        }
    }
    
    
    
    func setUpDefaultData() {
        
      
        var data: [String: String] = [
            "DIS": "The Walt Disney Company",
            "EA": "Electronic Arts Inc.",
            "FTNT": "Fortinet Inc.",
            "MNST": "Monster Beverage Corp.",
            "PYPL": "PayPal Holdings Inc.",
            "SBUX": "Starbucks Corp.",
            "ZG": "Zillow Group Inc.",
            "AAPL": "Apple Inc.",
            "MSFT": "Microsoft Corporation",
            "GOOGL": "Alphabet Inc. (Class A)",
            "GOOG": "Alphabet Inc. (Class C)",
            "AMZN": "Amazon.com Inc.",
            "TSLA": "Tesla Inc.",
            "NVDA": "NVIDIA Corporation",
            "META": "Meta Platforms Inc.",
            "NFLX": "Netflix Inc.",
            "INTC": "Intel Corporation",
            "ADBE": "Adobe Inc.",
            "CRM": "Salesforce Inc.",
            "CSCO": "Cisco Systems Inc.",
            "PEP": "PepsiCo Inc.",
            "KO": "Coca-Cola Company",
            "BAC": "Bank of America Corp.",
            "JPM": "JPMorgan Chase & Co.",
            "WMT": "Walmart Inc.",
            "T": "AT&T Inc.",
            "VZ": "Verizon Communications Inc.",
            "XOM": "Exxon Mobil Corp.",
            "CVX": "Chevron Corporation",
            "BA": "Boeing Co.",
            "NKE": "Nike Inc.",
            "MCD": "McDonald's Corporation",
            "ORCL": "Oracle Corporation",
            "QCOM": "Qualcomm Inc.",
            "IBM": "International Business Machines",
            "TXN": "Texas Instruments Inc.",
            "UBER": "Uber Technologies Inc.",
            "LYFT": "Lyft Inc.",
            "ABNB": "Airbnb Inc.",
            "SHOP": "Shopify Inc.",
            "ROKU": "Roku Inc.",
            "PLTR": "Palantir Technologies Inc.",
            "SNOW": "Snowflake Inc.",
            "BABA": "Alibaba Group Holding Ltd.",
            "JD": "JD.com Inc.",
            "PFE": "Pfizer Inc.",
            "MRNA": "Moderna Inc.",
            "JNJ": "Johnson & Johnson",
            "UNH": "UnitedHealth Group Inc.",
            "CVS": "CVS Health Corp.",
            "TGT": "Target Corporation",
            "LOW": "Lowe's Companies Inc.",
            "HD": "Home Depot Inc.",
            "COST": "Costco Wholesale Corp.",
            "SIRI": "Sirius XM Holdings Inc.",
            "F": "Ford Motor Company",
            "GM": "General Motors Company",
            "DE": "Deere & Company"
        ]


        
        var stockData = [WatchListModel]()
        
        for(name,value) in data {
            let insertData = WatchListModel(context: context)
            insertData.symbol = name
            insertData.value = value
            stockData.append(insertData)
        }
        
        do{
            try context.save()
        }
        catch {
            fatalError("not saved locally")
        }
    }
    
    
    func deleteData(_ symbol : String) {
        
        let request : NSFetchRequest<WatchListModel> = WatchListModel.fetchRequest()
        
        request.predicate = NSPredicate(format: "symbol == %@", symbol)
        
        do{
            let stock = try context.fetch(request)
            if let deleteData = stock.first {
                context.delete(deleteData)
                do{
                    try context.save()
                    context.refreshAllObjects()
                }catch {
                    fatalError()
          
                }
            }
        }catch {
            
        }
    }
    
    
}



