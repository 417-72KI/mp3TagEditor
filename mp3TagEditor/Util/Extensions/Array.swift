//
//  Array.swift
//  mp3TagEditor
//
//  Created by 417.72KI on 2020/12/30.
//

import Foundation

extension Array {
    enum SingleOrMultipleValues<T> {
        case none
        case singleValue(T)
        case multipleValues([T])
    }

    func singleOrMultipleValues<T: Equatable>(keyPath: KeyPath<Element, T>) -> SingleOrMultipleValues<T> {
        guard !isEmpty else { return .none }

        func allEquals(_ values: [T]) -> Bool {
            true
        }
        var values = map { $0[keyPath: keyPath] }
        let first = values.removeFirst()

        if !values.contains(where: { $0 != first }) {
            return .singleValue(first)
        }
        return .multipleValues(values)
    }
}
