//
//  Vehicle.swift
//  Car list
//
//  Created by Alexey Horokhov on 04.11.2019.
//  Copyright © 2019 Alexey Horokhov. All rights reserved.
//

import Foundation
import MapKit

struct VehicleList: Decodable {

    enum CodingKeys: String, CodingKey {
        case placemarks
    }

    let items: [Vehicle]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        items = try container.decode([Vehicle].self, forKey: .placemarks)
    }
}

class Vehicle: NSObject, Decodable, MKAnnotation {

    let address: String?
    let coordinates: [Double]?
    let engineType: String?
    let exterior: String?
    let fuelAmount: Int?
    let interior: String?
    let name: String?
    let vin: String?

    var subtitle: String? {
        return "Fuel left \(fuelAmount ?? 0)"
    }

    var title: String? {
        return name
    }
    
    var coordinate: CLLocationCoordinate2D {
        guard let coordinates = self.coordinates, coordinates.indices.contains(0), coordinates.indices.contains(1) else { return CLLocationCoordinate2D() }
        let location = CLLocationCoordinate2D(latitude: coordinates[1], longitude: coordinates[0])
        return location
    }

    enum CodingKeys: String, CodingKey {
        case address
        case coordinates
        case engineType
        case exterior
        case interior
        case fuel
        case name
        case vin
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        address = try! container.decode(String.self, forKey: .address)
        coordinates = try? container.decode([Double].self, forKey: .coordinates)
        engineType = try? container.decode(String.self, forKey: .engineType)
        exterior = try? container.decode(String.self, forKey: .exterior)
        fuelAmount = try? container.decode(Int.self, forKey: .fuel)
        interior = try? container.decode(String.self, forKey: .interior)
        name = try? container.decode(String.self, forKey: .name)
        vin = try? container.decode(String.self, forKey: .vin)
    }
}

extension Vehicle {

    static func decode(data: Data) throws -> Vehicle {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(Vehicle.self, from: data)
    }

}
