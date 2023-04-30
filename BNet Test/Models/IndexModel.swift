//
//  IndexModel.swift
//  BNet Test
//
//  Created by Georgy on 29.04.2023.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let drug = try? JSONDecoder().decode(Drug.self, from: jsonData)

import Foundation

// MARK: - DrugElement
struct DrugElement: Codable {
    let id: Int?
    let image: String?
    let categories: Categories?
    let name, description, documentation: String?
    let fields: [Field]?
}

// MARK: - Categories
struct Categories: Codable {
    let id: Int?
    let icon, image, name: String?
}

// MARK: - Field
struct Field: Codable {
    let type, name, value, image: String?
    let flags: Flags?
    let show, group: Int?
}

// MARK: - Flags
struct Flags: Codable {
    let html, noValue, noName, noImage: Int?
    let noWrap, noWrapName: Int?

    enum CodingKeys: String, CodingKey {
        case html
        case noValue = "no_value"
        case noName = "no_name"
        case noImage = "no_image"
        case noWrap = "no_wrap"
        case noWrapName = "no_wrap_name"
    }
}

typealias Drug = [DrugElement]

   
