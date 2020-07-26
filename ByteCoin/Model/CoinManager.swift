//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Artem Tkachuk on 7/25/20.
//  Copyright © 2020 Artem Tkachuk. All rights reserved.
//

import Foundation

//MARK: - CoinManagerDelegate
protocol CoinManagerDelegate {
    func didReceiveCoinPrice(_ CoinManager: CoinManager, _ price: Double, _ currency: String)
    func didFailWithError(_ CoinManager: CoinManager,  _ error: Error)
}

//MARK: - CoinManager
struct CoinManager {
    //MARK: - Variables
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = ProcessInfo.processInfo.environment["apiKey"]!
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate?
    
    //MARK: - getCoinPrice()
    func getCoinPrice(for currency: String) {
        let requestURL = baseURL + "/" + currency + "?" + "apikey=\(apiKey)"
        performRequest(with: requestURL)
    }
    
    //MARK: - performRequest()
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, respose, error) in
                if error != nil {
                    self.delegate?.didFailWithError(self, error!)
                    return
                } else {
                    if let safeData = data {
                        if let decodedData = self.parseJSON(safeData) {
                            let price = decodedData.rate
                            let currency = decodedData.asset_id_quote
                            self.delegate?.didReceiveCoinPrice(self, price, currency)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    //MARK: - parseJSON()
    func parseJSON(_ data: Data) -> CoinData? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            return decodedData
        } catch {
            delegate?.didFailWithError(self, error)
            return nil
        }
    }
}
