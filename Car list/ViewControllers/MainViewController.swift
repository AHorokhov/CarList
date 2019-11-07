//
//  ViewController.swift
//  Car list
//
//  Created by Alexey Horokhov on 04.11.2019.
//  Copyright © 2019 Alexey Horokhov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// TODO: all identifiers and raw numbers can be extracted into some Constants struct.
// TODO: all meaningfull strings could be added in localizable.
// TODO: huge potential for error handling and loading overlays.
// TODO: modal presentation for map on iPad.
// TODO: infinite possibilities for design improving.
// TODO: adding base classes for UIViewController, UITableViewController
// TODO: rewrite all UI changes for using Rx(advance level)

final class MainViewController: UIViewController {

    // MARK: Properties

    @IBOutlet private weak var mainTableView: UITableView!
    @IBOutlet private weak var showMapButton: UIButton!

    private var disposeBag = DisposeBag()
    private let vehicleListRelay: BehaviorRelay<[Vehicle]> = BehaviorRelay(value: [])
    private var mapVC = MapViewController()

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchData()
        setupButton()
        setupMap()
    }

    // MARK: Private

    private func fetchData() {
        Manager.shared.getData()
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] list in
                guard let self = self, let list = list else { return }
                self.vehicleListRelay.accept(list)
                self.mapVC.updateWithList(list: list)
                self.mainTableView.reloadData()
            })
            .disposed(by: disposeBag)
    }

    private func setupButton() {
        showMapButton.setTitle("Show Map", for: .normal)
        showMapButton.layer.cornerRadius = 3
        showMapButton.layer.borderColor = UIColor.systemBlue.cgColor
        showMapButton.layer.borderWidth = 0.5
    }

    private func setupMap() {
        guard let mapVC = UIStoryboard(name: "Map", bundle: nil).instantiateViewController(withIdentifier: "mapVC") as? MapViewController else { return }
        self.mapVC = mapVC
    }

    // MARK: Actions

    @IBAction func showMap(_ sender: Any) {
        navigationController?.pushViewController(mapVC, animated: true)
    }

}

// TODO: Could be replaced with RxDataSource, same with delegate
// MARK: UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vehicleListRelay.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let vehicleCell = tableView.dequeueReusableCell(withIdentifier: "VehicleTableViewCell", for: indexPath) as? VehicleTableViewCell else { return UITableViewCell() }
        vehicleCell.numberLabel.text = "\(indexPath.row + 1)"
        vehicleCell.updateWithItem(item: vehicleListRelay.value[indexPath.row])
        return vehicleCell
    }
}

// MARK: UITableViewDelegate

extension MainViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mapVC.updateWithSelectedVehicle(vehicle: vehicleListRelay.value[indexPath.row])
        navigationController?.pushViewController(mapVC, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}

