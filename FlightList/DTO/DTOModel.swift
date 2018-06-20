//
//  DTOModel.swift
//  FlightList
//
//  Created by Валерий Коканов on 18.06.2018.
//  Copyright © 2018 mynight. All rights reserved.
//

import Foundation

struct DTOModel: Codable {
    let data: Data
    let currentPage: Int
    let totalPage: Int
    
    struct Data: Codable {
        let best: [RawData]
        let other: [RawData]
    }
    
    struct RawData: Codable {
        let time: Time
        let duration: String
        let companyName: String
        let likePercent: Int?
        let cost: Double
        let details: [Details]
    }
    
    struct Details: Codable {
        let title: String
        let date: String
        let time: Time
        let duration: String
        let options: [Option]
        let companyName: String
    }
    
    struct Time: Codable {
        let from: String
        let to: String
    }
    
    struct Option: Codable {
        let name: String
        let description: String
        let avaliable: Bool
    }
}
