//
//  Manager.swift
//  Car list
//
//  Created by Alexey Horokhov on 05.11.2019.
//  Copyright © 2019 Alexey Horokhov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxAlamofire
import Alamofire

class Manager {

    static let shared = Manager()
    static let urlString = "https://wunder-test-case.s3-eu-west-1.amazonaws.com/ios/locations.json"

    func getData() -> Observable<[Vehicle]?> {
        guard let url = URL(string: Manager.urlString) else { return .just([])}
        return SessionManager.default.rx.request(.get, url)
            .data()
            .map { data -> [Vehicle]? in
                let vehicleList = try? JSONDecoder().decode(VehicleList.self, from: data)
                return vehicleList?.items
        }
    }
}
