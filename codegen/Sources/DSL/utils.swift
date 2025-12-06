import Foundation

extension String {
	// Copied from https://github.com/swiftlang/swift-foundation/blob/57b6c0c3e56e4d2627ebe02a3d311c2569ded61a/Sources/FoundationEssentials/JSON/JSONDecoder.swift#L121
	func convertFromSnakeCase() -> String {
		guard !isEmpty else { return self }

		// Find the first non-underscore character
		guard let firstNonUnderscore = firstIndex(where: { $0 != "_" }) else {
			// Reached the end without finding an _
			return self
		}

		// Find the last non-underscore character
		var lastNonUnderscore = index(before: endIndex)
		while lastNonUnderscore > firstNonUnderscore && self[lastNonUnderscore] == "_" {
			formIndex(before: &lastNonUnderscore)
		}

		let keyRange = firstNonUnderscore...lastNonUnderscore
		let leadingUnderscoreRange = startIndex..<firstNonUnderscore
		let trailingUnderscoreRange = index(after: lastNonUnderscore)..<endIndex

		let components = self[keyRange].split(separator: "_")
		var joinedString: String
		if components.count == 1 {
			// No underscores in key, leave the word as is - maybe already camel cased
			joinedString = String(self[keyRange])
		} else {
			joinedString = components[0].lowercased()
			for component in components[1...] {
				if component == "id" {
					joinedString += "ID"
				} else if component == "ids" {
					joinedString += "IDs"
				} else {
					joinedString += component.capitalized
				}
			}
		}

		// Do a cheap isEmpty check before creating and appending potentially empty strings
		let result: String
		if (leadingUnderscoreRange.isEmpty && trailingUnderscoreRange.isEmpty) {
			result = joinedString
		} else if (!leadingUnderscoreRange.isEmpty && !trailingUnderscoreRange.isEmpty) {
			// Both leading and trailing underscores
			result = String(self[leadingUnderscoreRange]) + joinedString + String(self[trailingUnderscoreRange])
		} else if (!leadingUnderscoreRange.isEmpty) {
			// Just leading
			result = String(self[leadingUnderscoreRange]) + joinedString
		} else {
			// Just trailing
			result = joinedString + String(self[trailingUnderscoreRange])
		}
		return result
	}
}

extension StringProtocol {
	var capitalizedFirstChar: String {
		var result = ""
		if let first = first {
			result += first.uppercased()
		}
		result += dropFirst()
		return result
	}
}

func copyWith<T, S>(_ value: T, _ keyPath: WritableKeyPath<T, S>, _ newValue: S) -> T {
	var value = value
	value[keyPath: keyPath] = newValue
	return value
}
