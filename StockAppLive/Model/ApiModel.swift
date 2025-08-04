//
//  ApiModel.swift
//  StockAppLive
//
//  Created by Test on 09/06/25.
//

import Foundation


struct marketData: Codable {
    let open: [Double]?
    let close: [Double]?
    let high: [Double]?
    let low: [Double]?
    let volume: [Int]?
    let status: String?
    let timeInterval: [TimeInterval]?

    // ✅ Fix: Capital 'K'
    enum CodingKeys: String, CodingKey {
        case open = "o"
        case close = "c"
        case high = "h"
        case low = "l"
        case volume = "v"
        case status = "s"
        case timeInterval = "t"
    }

    // ✅ Safe, compiler-friendly logic
    var stockData: [convertData] {
        var data = [convertData]()
        let count = open?.count ?? 0

        for index in 0..<count {
            guard
                let o = open?[index],
                let c = close?[index],
                let h = high?[index],
                let l = low?[index],
                let t = timeInterval?[index],
                let v = volume?[index]
            else {
                continue
            }

            let entry = convertData(open: o, close: c, high: h, low: l, date: Date(timeIntervalSince1970: t), volume: v)
            data.append(entry)
        }

        return data.sorted { $0.date < $1.date }
    }
}



struct convertData {
    let open : Double
    let close : Double
    let high : Double
    let low : Double
    let date : Date
    let volume : Int
}






// MARK: - Welcome
struct StockDataDetails: Codable {
    let chart: Chart?
}

// MARK: - Chart
struct Chart: Codable {
    let result: [Result]?
   // let error: JSONNull?
}

// MARK: - Result
struct Result: Codable {
    let meta: Meta?
    let timestamp: [Int]?
    let indicators: Indicators?
    
    
    var stockData: [convertData] {
           var data = [convertData]()
           
           guard let quote = indicators?.quote?.first,
                 let timestamps = timestamp,
                 let opens = quote.open,
                 let closes = quote.close,
                 let highs = quote.high,
                 let lows = quote.low,
                 let volumes = quote.volume,
                 opens.count == timestamps.count else {
               return []
           }

           for i in 0..<timestamps.count {
               let date = Date(timeIntervalSince1970: TimeInterval(timestamps[i]))
               guard i < opens.count,
                     i < closes.count,
                     i < highs.count,
                     i < lows.count,
                     i < volumes.count else { continue }

               let entry = convertData(
                   open: opens[i],
                   close: closes[i],
                   high: highs[i],
                   low: lows[i],
                   date: date,
                   volume: volumes[i]
               )
               data.append(entry)
           }

           return data.sorted { $0.date < $1.date }
       }

    
}

// MARK: - Indicators
struct Indicators: Codable {
    let quote: [Quote]?
    let adjclose: [Adjclose]?
}

// MARK: - Adjclose
struct Adjclose: Codable {
    let adjclose: [Double]?
}

// MARK: - Quote
struct Quote: Codable {
    let open, close, low: [Double]? 
    let volume: [Int]?
    let high: [Double]?

    enum CodingKeys: String, CodingKey {
        case open = "open"
        case close, low, volume, high
    }
    
    var stockData : [convertData] {
        
        var data = [convertData]()
        let count = open?.count ?? 0
        
        for index in 0..<count {
            guard
                let o = open?[index],
                let c = close?[index],
                let h = high?[index],
                let l = low?[index],
                let v = volume?.first else {continue}
            
            let entry = convertData(open: o, close: c, high: h, low: l, date: Date(timeIntervalSince1970: 1234456), volume: v)
            data.append(entry)

        }
        return data.sorted { $0.date < $1.date }

    }
}

// MARK: - Meta
struct Meta: Codable {
    let currency, symbol, exchangeName, fullExchangeName: String?
    let instrumentType: String?
    let firstTradeDate, regularMarketTime: Int?
    let hasPrePostMarketData: Bool?
    let gmtoffset: Int?
    let timezone, exchangeTimezoneName: String?
    let regularMarketPrice, fiftyTwoWeekHigh, fiftyTwoWeekLow, regularMarketDayHigh: Double?
    let regularMarketDayLow: Double?
    let regularMarketVolume: Int?
    let longName, shortName: String?
    let chartPreviousClose: Double?
    let priceHint: Int?
    let currentTradingPeriod: CurrentTradingPeriod?
    let dataGranularity, range: String?
    let validRanges: [String]?
    
    var metricStockData : MetricStock {
        var data = MetricStock(regularMarketPrice: regularMarketPrice, fiftyTwoWeekHigh: fiftyTwoWeekHigh, fiftyTwoWeekLow: fiftyTwoWeekLow, regularMarketDayHigh: regularMarketDayHigh, regularMarketDayLow: regularMarketDayLow, regularMarketVolume: regularMarketVolume)
        
        return data
       
    }
}

// MARK: - CurrentTradingPeriod
struct CurrentTradingPeriod: Codable {
    let pre, regular, post: Post?
}

// MARK: - Post
struct Post: Codable {
    let timezone: String?
    let end, start, gmtoffset: Int?
}

struct MetricStock {
    let regularMarketPrice, fiftyTwoWeekHigh, fiftyTwoWeekLow, regularMarketDayHigh: Double?
    let regularMarketDayLow: Double?
    let regularMarketVolume: Int?
}

// MARK: - Encode/decode helpers

//class JSONNull: Codable, Hashable {
//
//    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
//            return true
//    }
//
//    public var hashValue: Int {
//            return 0
//    }
//
//    public init() {}
//
//    public required init(from decoder: Decoder) throws {
//            let container = try decoder.singleValueContainer()
//            if !container.decodeNil() {
//                    throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
//            }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//            var container = encoder.singleValueContainer()
//            try container.encodeNil()
//    }
//}



//struct feeds : Codable , Identifiable{
//    
//    let id : UUID
//    let title : String?
//    let description : String?
//    let source : String?
//    let image_url : String?
//    let url : String?
//  
//    
//}



struct NewsModel: Codable {
    let meta: NewsMeta
    let data: [NewList]
}

// MARK: - Datum
struct NewList: Codable {
    let uuid, title, description, keywords: String?
    let snippet: String?
    let url: String?
    let imageURL: String?
    let language, publishedAt, source: String?
    let entities: [Entity]?
   

    enum CodingKeys: String, CodingKey {
        case uuid, title, description, keywords, snippet, url
        case imageURL = "image_url"
        case language
        case publishedAt = "published_at"
        case source
        case entities
    }
}

// MARK: - Entity
struct Entity: Codable {
    let symbol, name: String?
    let exchange, exchangeLong: String?
    let country: Country?
    let type: TypeEnum?
    let industry: String?
    let matchScore, sentimentScore: Double?
    let highlights: [Highlight]?

    enum CodingKeys: String, CodingKey {
        case symbol, name, exchange
        case exchangeLong = "exchange_long"
        case country, type, industry
        case matchScore = "match_score"
        case sentimentScore = "sentiment_score"
        case highlights
    }
}

enum Country: String, Codable {
    case ar = "ar"
    case br = "br"
    case cl = "cl"
    case countryIn = "in"
    case de = "de"
    case mx = "mx"
    case us = "us"
}

// MARK: - Highlight
struct Highlight: Codable {
    let highlight: String?
    let sentiment: Double?
    let highlightedIn: HighlightedIn?

    enum CodingKeys: String, CodingKey {
        case highlight, sentiment
        case highlightedIn = "highlighted_in"
    }
}

enum HighlightedIn: String, Codable {
    case mainText = "main_text"
    case title = "title"
}

enum TypeEnum: String, Codable {
    case equity = "equity"
}

// MARK: - Meta
struct NewsMeta: Codable {
    let found, returned, limit, page: Int?
}
