//
//  Root.swift
//  Rick and Morty
//
//  Created by Tim on 9/29/20.
//  Copyright © 2020 Tim. All rights reserved.
//

import Foundation

struct Root: Codable {
    var results: [Results]
}

struct Results: Codable {
    let name: String
    let status: String
    let species: String
    let image: String
}

//I had a problem with the location. I think i figured how to fix it. It envolves CodingKeys and that should fix Nested JSON


