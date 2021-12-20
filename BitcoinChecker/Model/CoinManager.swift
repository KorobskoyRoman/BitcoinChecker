//
//  CoinManager.swift
//  BitcoinChecker
//
//  Created by Roman Korobskoy on 20.12.2021.
//

import Foundation

protocol CoinManagerDelegate {
    func updateCurrency(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    let baseUrl = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "8256C7B2-7BBA-49C6-9B42-1171B4B18DD6"
    
    let currencyArray = ["AUD", "BRL", "CAD", "CNY", "EUR", "GBP", "HKD", "IDR", "ILS", "INR", "JPY", "MXN", "NOK", "NZD", "PLN", "RON", "RUB", "SEK", "SGD", "SGD", "USD", "ZAR"]
    
    var delegate: CoinManagerDelegate?
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseUrl)/\(currency)?apikey=\(apiKey)"
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let coinPrice = self.parseJSON(safeData) {
                        let currencyString = String(format: "%.2f", coinPrice)
                        self.delegate?.updateCurrency(price: currencyString, currency: currency)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            print(lastPrice)
            return lastPrice
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
