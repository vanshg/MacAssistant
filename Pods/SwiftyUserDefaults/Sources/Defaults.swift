//
// SwiftyUserDefaults
//
// Copyright (c) 2015-2018 Radosław Pietruszewski, Łukasz Mróz
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import Foundation

/// Global shortcut for `UserDefaults.standard`
///
/// **Pro-Tip:** If you want to use shared user defaults, just
///  redefine this global shortcut in your app target, like so:
///  ~~~
///  var Defaults = UserDefaults(suiteName: "com.my.app")!
///  ~~~

public let Defaults = UserDefaults.standard

public extension UserDefaults {

    /// Returns `true` if `key` exists
    func hasKey<T>(_ key: DefaultsKey<T>) -> Bool {
        return object(forKey: key._key) != nil
    }

    /// Removes value for `key`
    func remove<T>(_ key: DefaultsKey<T>) {
        removeObject(forKey: key._key)
    }

    /// Removes all keys and values from user defaults
    /// Use with caution!
    /// - Note: This method only removes keys on the receiver `UserDefaults` object.
    ///         System-defined keys will still be present afterwards.
    public func removeAll() {
        for (key, _) in dictionaryRepresentation() {
            removeObject(forKey: key)
        }
    }
}

internal extension UserDefaults {

    func number(forKey key: String) -> NSNumber? {
        return object(forKey: key) as? NSNumber
    }

    func decodable<T: Decodable>(forKey key: String) -> T? {
        guard let decodableData = data(forKey: key) else { return nil }

        return try? JSONDecoder().decode(T.self, from: decodableData)
    }

    func set<T: Encodable>(encodable: T, forKey key: String) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(encodable) {
            set(data, forKey: key)
        } else {
            assertionFailure("Encodable \(T.self) is not _actually_ encodable to any data...Please fix 😭")
        }
    }
}
