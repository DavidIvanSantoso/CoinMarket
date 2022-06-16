//
//  coinData.swift
//  UAS_IOS_C14190040
//
//  Created by Athalia Gracia Santoso on 14/06/22.
//

struct coinModel:Decodable{
    let data:[coinData]
}
struct coinData:Decodable{
    let coinName:String
    let coinImage:String
    let coinPriceUSD:Double
    let coidID:String
}
