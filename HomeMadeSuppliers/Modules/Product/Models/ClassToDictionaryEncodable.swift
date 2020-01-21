//
//  ClassToDictionaryEncodable.swift
//  HomeMadeSuppliers
//
//  Created by apple on 10/29/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import Foundation

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
