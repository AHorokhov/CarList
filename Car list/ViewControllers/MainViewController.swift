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
        setupTableView()
        setupMap()
    }

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

    private func setupTableView() {
//        mainTableView.register(cellType: VehicleTableViewCell.self)
    }

    private func setupMap() {
        guard let mapVC = UIStoryboard(name: "Map", bundle: nil).instantiateViewController(withIdentifier: "mapVC") as? MapViewController else { return }
        self.mapVC = mapVC
    }

    @IBAction func showMap(_ sender: Any) {
        navigationController?.pushViewController(mapVC, animated: true)
    }

}

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

