//
//  Networking.swift
//  Skillbox_diploma_step2
//
//  Created by Roman on 20.09.2021.
//

import Foundation
import Alamofire

class MainCategories: Codable {
    
    let categories: [String : CategoriesFromCatalog]
 
    required init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        categories = try container.decode( [String : CategoriesFromCatalog].self )
    }
    
}


class CategoriesFromCatalog: Codable {
    let name: String
    let sortOrder: Int
    let image: String
    let iconImage: String
    let iconImageActive: String
}












//// MARK: - WelcomeValue
//class WelcomeValue: Codable {
//    let name: String
//    let sortOrder: SortOrder
//    let image: String
//    let iconImage: String
//    let iconImageActive: String
//    let subcategories: [Subcategory]
//
//    enum CodingKeys: String, CodingKey {
//        case name
//        case sortOrder
//        case image
//        case iconImage
//        case iconImageActive
//        case subcategories
//    }
//
//    init(name: String, sortOrder: SortOrder, image: String, iconImage: String, iconImageActive: String, subcategories: [Subcategory]) {
//        self.name = name
//        self.sortOrder = sortOrder
//        self.image = image
//        self.iconImage = iconImage
//        self.iconImageActive = iconImageActive
//        self.subcategories = subcategories
//    }
//}
//
//// MARK: WelcomeValue convenience initializers and mutators
//
//extension WelcomeValue {
//    convenience init(data: Data) throws {
//        let me = try newJSONDecoder().decode(WelcomeValue.self, from: data)
//        self.init(name: me.name, sortOrder: me.sortOrder, image: me.image, iconImage: me.iconImage, iconImageActive: me.iconImageActive, subcategories: me.subcategories)
//    }
//
//    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
//        guard let data = json.data(using: encoding) else {
//            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
//        }
//        try self.init(data: data)
//    }
//
//    convenience init(fromURL url: URL) throws {
//        try self.init(data: try Data(contentsOf: url))
//    }
//
//    func with(
//        name: String? = nil,
//        sortOrder: SortOrder? = nil,
//        image: String? = nil,
//        iconImage: String? = nil,
//        iconImageActive: String? = nil,
//        subcategories: [Subcategory]? = nil
//    ) -> WelcomeValue {
//        return WelcomeValue(
//            name: name ?? self.name,
//            sortOrder: sortOrder ?? self.sortOrder,
//            image: image ?? self.image,
//            iconImage: iconImage ?? self.iconImage,
//            iconImageActive: iconImageActive ?? self.iconImageActive,
//            subcategories: subcategories ?? self.subcategories
//        )
//    }
//
//    func jsonData() throws -> Data {
//        return try newJSONEncoder().encode(self)
//    }
//
//    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
//        return String(data: try self.jsonData(), encoding: encoding)
//    }
//}
//
//enum SortOrder: Codable {
//    case integer(Int)
//    case string(String)
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if let x = try? container.decode(Int.self) {
//            self = .integer(x)
//            return
//        }
//        if let x = try? container.decode(String.self) {
//            self = .string(x)
//            return
//        }
//        throw DecodingError.typeMismatch(SortOrder.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for SortOrder"))
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        switch self {
//        case .integer(let x):
//            try container.encode(x)
//        case .string(let x):
//            try container.encode(x)
//        }
//    }
//}
//
//// MARK: - Subcategory
//class Subcategory: Codable {
//    let id: SortOrder
//    let iconImage: String
//    let sortOrder: SortOrder
//    let name: String
//    let type: TypeEnum
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case iconImage
//        case sortOrder
//        case name
//        case type
//    }
//
//    init(id: SortOrder, iconImage: String, sortOrder: SortOrder, name: String, type: TypeEnum) {
//        self.id = id
//        self.iconImage = iconImage
//        self.sortOrder = sortOrder
//        self.name = name
//        self.type = type
//    }
//}
//
//// MARK: Subcategory convenience initializers and mutators
//
//extension Subcategory {
//    convenience init(data: Data) throws {
//        let me = try newJSONDecoder().decode(Subcategory.self, from: data)
//        self.init(id: me.id, iconImage: me.iconImage, sortOrder: me.sortOrder, name: me.name, type: me.type)
//    }
//
//    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
//        guard let data = json.data(using: encoding) else {
//            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
//        }
//        try self.init(data: data)
//    }
//
//    convenience init(fromURL url: URL) throws {
//        try self.init(data: try Data(contentsOf: url))
//    }
//
//    func with(
//        id: SortOrder? = nil,
//        iconImage: String? = nil,
//        sortOrder: SortOrder? = nil,
//        name: String? = nil,
//        type: TypeEnum? = nil
//    ) -> Subcategory {
//        return Subcategory(
//            id: id ?? self.id,
//            iconImage: iconImage ?? self.iconImage,
//            sortOrder: sortOrder ?? self.sortOrder,
//            name: name ?? self.name,
//            type: type ?? self.type
//        )
//    }
//
//    func jsonData() throws -> Data {
//        return try newJSONEncoder().encode(self)
//    }
//
//    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
//        return String(data: try self.jsonData(), encoding: encoding)
//    }
//}
//
//enum TypeEnum: String, Codable {
//    case category = "Category"
//    case collection = "Collection"
//}
//
//typealias Welcome = [String: WelcomeValue]
//
//extension Dictionary where Key == String, Value == WelcomeValue {
//    init(data: Data) throws {
//        self = try newJSONDecoder().decode(Welcome.self, from: data)
//    }
//
//    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
//        guard let data = json.data(using: encoding) else {
//            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
//        }
//        try self.init(data: data)
//    }
//
//    init(fromURL url: URL) throws {
//        try self.init(data: try Data(contentsOf: url))
//    }
//
//    func jsonData() throws -> Data {
//        return try newJSONEncoder().encode(self)
//    }
//
//    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
//        return String(data: try self.jsonData(), encoding: encoding)
//    }
//}
//
//// MARK: - Helper functions for creating encoders and decoders
//
//func newJSONDecoder() -> JSONDecoder {
//    let decoder = JSONDecoder()
//    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
//        decoder.dateDecodingStrategy = .iso8601
//    }
//    return decoder
//}
//
//func newJSONEncoder() -> JSONEncoder {
//    let encoder = JSONEncoder()
//    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
//        encoder.dateEncodingStrategy = .iso8601
//    }
//    return encoder
//}

