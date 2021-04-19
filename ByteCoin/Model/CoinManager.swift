//
//  CoinData.swift
//  ByteCoin
//
//  Created by Gurpreet Singh on 2021-04-19.
//  Copyright © 2021 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(_ coinManager: CoinManager, coin: CoinData)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "A6D2E691-0276-44E1-8FBF-B0951DD77EE1"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    var delegate: CoinManagerDelegate?
    
    func getCoinPrice(for currency: String){
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(with: urlString)
    }
    
    func getCoinPriceUSD(){
        let urlString = "\(baseURL)/USD?apikey=\(apiKey)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        //1. Create a URL
        if let url = URL(string: urlString){
            
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
 
            //3. Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    print(error!)
                    return
                }

                if let safeData = data {
                    if let coin = parseJSON(safeData){
                        delegate?.didUpdatePrice(self, coin: coin)
                    }
                }
            }
            //4. Start the task
            task.resume()
            }
        }
    
    func parseJSON(_ data: Data) -> CoinData?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let rate = decodedData.rate
            let fiatCurrency = decodedData.asset_id_quote
            let coin = CoinData(rate: rate, asset_id_quote: fiatCurrency)
            return coin
        } catch  {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
