//
//  CoinData.swift
//  ByteCoin
//
//  Created by Artem Tkachuk on 7/25/20.
//  Copyright © 2020 Artem Tkachuk. All rights reserved.
//

import Foundation

//MARK: - CoinData
struct CoinData: Codable {
    var rate: Double
    var asset_id_quote: String
}
