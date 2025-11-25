protocol Documentable {
	var doc: String? { get set }
}

extension Documentable {
	func doc(_ text: String?) -> Self {
		copyWith(self, \.doc, text)
	}
}
