//
//  VehicleTableViewCell.swift
//  Car list
//
//  Created by Alexey Horokhov on 07.11.2019.
//  Copyright © 2019 Alexey Horokhov. All rights reserved.
//

import UIKit

final class VehicleTableViewCell: UITableViewCell {

    // MARK: Properties

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var vinLabel: UILabel!
    @IBOutlet private weak var engineTypeLabel: UILabel!
    @IBOutlet private weak var fuelLabel: UILabel!
    @IBOutlet private weak var exteriorLabel: UILabel!
    @IBOutlet private weak var interiorLabel: UILabel!

    // MARK: Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()
        numberLabel.text = nil
        addressLabel.text = nil
        nameLabel.text = nil
        vinLabel.text = nil
        engineTypeLabel.text = nil
        fuelLabel.text = nil
        exteriorLabel.text = nil
        interiorLabel.text = nil
    }

    // MARK: Public

    func updateWithItem(item: Vehicle) {
        addressLabel.text = "Address: \(item.address ?? ""))"
        nameLabel.text = "Name: \(item.name ?? "" )"
        vinLabel.text = "Vin: \(item.vin ?? "")"
        engineTypeLabel.text = "Engine Type: \(item.engineType ?? "")"
        fuelLabel.text = "Fuel: \(item.fuelAmount ?? 0)"
        exteriorLabel.text = "Exterior: \(item.exterior ?? "")"
        interiorLabel.text = "Interior: \(item.interior ?? "")"
    }

}
