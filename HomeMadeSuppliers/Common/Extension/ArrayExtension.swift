//
//  ArrayExtension.swift
//  HomeMadeSuppliers
//
//  Created by apple on 6/17/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import Foundation

extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}

// usage
//let a: [Int] = [1, 2, 3, 3, 3]
//let b: [Int] = [1, 3, 3, 3, 2]
//let c: [Int] = [1, 2, 2, 3, 3, 3]
//
//print(a.containsSameElements(as: b)) // true
//print(a.containsSameElements(as: c)) // false

//extension Array where Element: Equatable {
//    func equalContents(to other: [Element]) -> Bool {
//        guard self.count == other.count else {return false}
//        for e in self{
//            guard self.filter { $0 == e }.count == other.filter{ $0 == e }.count else {
//                return false
//            }
//        }
//        return true
//    }
//}


// Move Element from old to new Index

extension Array where Element: Equatable
{
    mutating func move(_ element: Element, to newIndex: Index) {
        if let oldIndex: Int = self.firstIndex(of: element) { self.move(from: oldIndex, to: newIndex) }
    }
}

extension Array
{
    mutating func move(from oldIndex: Index, to newIndex: Index) {
        // Don't work for free and use swap when indices are next to each other - this
        // won't rebuild array and will be super efficient.
        if oldIndex == newIndex { return }
        if abs(newIndex - oldIndex) == 1 { return self.swapAt(oldIndex, newIndex) }
        self.insert(self.remove(at: oldIndex), at: newIndex)
    }
}



extension Array where Element: Equatable {
    func all(where predicate: (Element) -> Bool) -> [Element]  {
        return self.compactMap { predicate($0) ? $0 : nil }
    }
}

//let grades = [8, 9, 10, 1, 2, 5, 3, 4, 8, 8]
//let goodGrades = grades.all(where: { $0 > 7 })
//print(goodGrades)
// Output: [8, 9, 10, 8, 8]


/*
 SWIFT 5
 
 Check if the element exists
 
 if array.contains(where: {$0.name == "foo"}) {
 // it exists, do something
 } else {
 //item could not be found
 }
 Get the element
 
 if let foo = array.first(where: {$0.name == "foo"}) {
 // do something with foo
 } else {
 // item could not be found
 }
 Get the element and its offset
 
 if let foo = array.enumerated().first(where: {$0.element.name == "foo"}) {
 // do something with foo.offset and foo.element
 } else {
 // item could not be found
 }
 Get the offset
 
 if let fooOffset = array.firstIndex(where: {$0.name == "foo"}) {
 // do something with fooOffset
 } else {
 // item could not be found
 }

 
 
 */
