protocol HasSerialName {
	var serialName: String { get }
	var customSwiftName: String? { get set }
}

extension HasSerialName {
	var swiftName: String {
		customSwiftName ?? serialName.convertFromSnakeCase()
	}

	func swiftName(_ name: String) -> Self {
		copyWith(self, \.customSwiftName, name)
	}
}
