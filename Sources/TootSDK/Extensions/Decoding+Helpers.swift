//
//  Decoding+Helpers.swift
//  Created by Łukasz Rutkowski on 18/03/2023.
//

import Foundation

extension KeyedDecodingContainerProtocol {
    func decodeIntFromString(forKey key: Key) throws -> Int {
        do {
            return try decode(Int.self, forKey: key)
        } catch {
            let string = try decode(String.self, forKey: key)
            if let int = Int(string) {
                return int
            }
            throw error
        }
    }
}
