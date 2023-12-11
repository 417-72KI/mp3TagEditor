//
//  Sequence.swift
//  mp3TagEditor
//
//  Created by 417.72KI on 2020/12/30.
//

import Foundation

extension Sequence {
    public func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>, ascending: Bool = true) -> [Element] {
        sorted { ascending ? $0[keyPath: keyPath] < $1[keyPath: keyPath] : $0[keyPath: keyPath] > $1[keyPath: keyPath] }
    }

    public func sorted<T: Comparable>(by keyPath: KeyPath<Element, T?>, ascending: Bool = true) -> [Element] {
        sorted {
            guard let l = $0[keyPath: keyPath],
                  let r = $1[keyPath: keyPath] else { return false }
            return ascending ? l < r : l > r
        }
    }
}

extension Array {
    public mutating func sort<T: Comparable>(by keyPath: KeyPath<Element, T>, ascending: Bool = true) {
        sort { ascending ? $0[keyPath: keyPath] < $1[keyPath: keyPath] : $0[keyPath: keyPath] > $1[keyPath: keyPath] }
    }

    public mutating func sort<T: Comparable>(by keyPath: KeyPath<Element, T?>, ascending: Bool = true) {
        sort {
            guard let l = $0[keyPath: keyPath],
                  let r = $1[keyPath: keyPath] else { return false }
            return ascending ? l < r : l > r
        }
    }
}
