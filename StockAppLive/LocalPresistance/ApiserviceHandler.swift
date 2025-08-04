//
//  ApiserviceHandler.swift
//  StockAppLive
//
//  Created by Test on 09/06/25.
//

//https://financialmodelingprep.com/api/v3/profile/AAPL?apikey=lkSna0QHTx3hY3LfTSVyUiQfcGUwT8vK

import Foundation


enum endpoints : String {
    case search
    case topStories = "news"
    case companyNews = "company-news"
    case marketData = "quote"
    case financials = "stock/metric"
    case charts = "chart/"
    case feeds = "news/all?"
}

enum apierror : Error {
    
    case noData
    case InvalidUrl
}

class ApiserviceHandler {
    
    static let shared = ApiserviceHandler()
    
    func fetchDataForSymbol(for symbol : String, numberOfDays : TimeInterval = 7,completion : @escaping(Swift.Result<marketData,Error>)-> Void) {
        
        let today = Date().addingTimeInterval(1 * Constants.oneDay)
        let past = today.addingTimeInterval(-(numberOfDays * Constants.oneDay))
        let url = urlBuilder(endpoint: .marketData, queryParams:[
            "symbol" : symbol,
            "resolution" : "1",
            "from": "\(Int(past.timeIntervalSince1970))",
            "to" : "\(Int(today.timeIntervalSince1970))"
        ])
        
        
        
        fetchData(url: url, type: marketData.self, completion: completion)
    }
    
    
    func fetchDataForSymbolChart(for symbol : String, numberOfDays : TimeInterval = 7, completion : @escaping(Swift.Result<StockDataDetails,Error>) -> Void ) {
        
        
        let period1 = Date().addingTimeInterval(1 * Constants.oneDay)
        let period2 = period1.addingTimeInterval(-(numberOfDays * Constants.oneDay))
        
       let url =  urlBuilderChart(endpoint: .charts, symbol: symbol, queryParams: [
        
            "period2" : "\(Int(period1.timeIntervalSince1970))",
            "period1" : "\(Int(period2.timeIntervalSince1970))",
           "interval" : "1d"
        ])
        fetchData(url: url, type: StockDataDetails.self, completion: completion)
    }
    
    func urlBuilderChart(endpoint: endpoints,symbol : String, queryParams: [String: String]) -> URL? {
        
        guard var urlComponent = URLComponents(string: Constants.chartBaseUrl + endpoint.rawValue + symbol)else{return nil}
        
        urlComponent.queryItems = queryParams.compactMap{URLQueryItem(name: $0.key, value: $0.value)}
        
        if let encoded = urlComponent.percentEncodedQuery?.replacingOccurrences(of: "%20", with: "") {
            urlComponent.percentEncodedQuery = encoded
        }
       return urlComponent.url
    }
    

    
    func urlBuilder(endpoint: endpoints, queryParams: [String: String]) -> URL? {
        
        guard var urlComponent = URLComponents(string: Constants.baseUrl + endpoint.rawValue) else {return nil}
        
        urlComponent.queryItems = queryParams.compactMap{URLQueryItem(name: $0.key, value: $0.value)}
        
        urlComponent.queryItems?.append(URLQueryItem(name: "token", value: Constants.apiKey))
        
        if let encodedQuery = urlComponent.percentEncodedQuery?.replacingOccurrences(of: "%20", with: ""){
            urlComponent.percentEncodedQuery = encodedQuery
        }
        
        return urlComponent.url
    }
    
    
  
    func fetchNewsFeed(symbol : String , completion : @escaping(Swift.Result<NewsModel,Error>)-> Void) {
        let url = newsFeedUrlBuilder(endpoint: .feeds, symbol: symbol, params: [
            "symbols" : symbol,
            "language" : "en",
        ])
        
        fetchNewData(url: url, modelType: NewsModel.self, completion: completion)
        
        
    }
    
    func newsFeedUrlBuilder(endpoint : endpoints , symbol : String , params : [String : String]) -> URL {
        
        var urlcomponent = URLComponents(string: Constants.newsFeed +  endpoint.rawValue)
        
        urlcomponent?.queryItems = params.compactMap({ value in
            return URLQueryItem(name: value.key, value: value.value)
        })
        
        urlcomponent?.queryItems?.append(.init(name: "api_token", value: "21Qo6EFaARTjxRdyD6wt2rNSmaTImoEJYHiVa8Sg"))
        
        if let encoded = urlcomponent?.percentEncodedQuery?.replacingOccurrences(of: "%20", with: "&") {
            urlcomponent?.percentEncodedQuery = encoded
        }
    
        return (urlcomponent?.url!)!
    }
    
    
    func fetchNewData<T : Codable> (url : URL, modelType : T.Type, completion : @escaping(Swift.Result<T,Error>)-> Void) {
        
        let task  = URLSession.shared.dataTask(with: URLRequest(url: url)) { response, _, error in
            
            if let e = error {
                completion(.failure(e))
            }else {
                
                guard let data = response else {return completion(.failure(apierror.noData))}
                
                let jsondecoder = JSONDecoder()
                do {
                    let data = try jsondecoder.decode(T.self, from: data)
                    completion(.success(data))
                }catch {
                    completion(.failure(apierror.noData))
                }
                
            }
        }
        task.resume()
    }
    
    
    
    
    func fetchData<T : Codable>(url : URL? , type : T.Type, completion : @escaping(Swift.Result<T,Error>) -> Void ){
        guard let url = url else {
            completion(.failure(apierror.InvalidUrl))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data,response,error in
            guard let responseData = data , error == nil else {
                if let e = error {
                    completion(.failure(e))
                }else {
                    completion(.failure(apierror.noData))
                }
                return
            }
            let decoder =  JSONDecoder()
            do{
                let responseVal = try decoder.decode(T.self, from: responseData)
                completion(.success(responseVal as! T))
            }catch {
                completion(.failure(apierror.noData))
            }
        }
        task.resume()
    }
    
    
    
  
}
