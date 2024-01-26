//
//  String+Extension.swift
//  SampleNewsProj
//
//  Created by Jennifer Eve Curativo on 1/26/24.
//

import Foundation

extension String {
    func removingSubranges(startChar: Character, endChar: Character) -> String {
        var copy = self
        copy.removeSubranges(startChar: startChar, endChar: endChar)
        return copy
    }

    mutating func removeSubranges(startChar: Character, endChar: Character) {
        var startIndex: String.Index?
        
        self
            .indices
            .reduce(into: [ClosedRange<String.Index>](), {
                if let index = startIndex {
                    if self[$1] == endChar {
                        $0.append(index...$1)
                        startIndex = nil
                    }
                } else if self[$1] == startChar {
                    startIndex = $1
                }
            })
            .reversed()
            .forEach { self.removeSubrange($0) }
    }
}
