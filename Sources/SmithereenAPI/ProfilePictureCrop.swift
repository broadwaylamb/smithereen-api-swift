public struct AvatarCropRects: Hashable, Codable, Sendable {

	/// The rectangular area displayed on the desktop website.
	public var crop: ImageRect

	/// The square area **within the rectangular area** ``crop``,
	// used in most places where profile pictures are displayed.
	public var square: ImageRect

	public init(crop: ImageRect, square: ImageRect) {
		self.crop = crop
		self.square = square
	}

	private enum CodingKeys: String, CodingKey {
		case cropX1 = "crop_x1"
		case cropY1 = "crop_y1"
		case cropX2 = "crop_x2"
		case cropY2 = "crop_y2"
		case squareX1 = "square_x1"
		case squareY1 = "square_y1"
		case squareX2 = "square_x2"
		case squareY2 = "square_y2"
	}

	public func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(crop.x1, forKey: .cropX1)
		try container.encode(crop.y1, forKey: .cropY1)
		try container.encode(crop.x2, forKey: .cropX2)
		try container.encode(crop.y2, forKey: .cropY2)
		try container.encode(square.x1, forKey: .squareX1)
		try container.encode(square.y1, forKey: .squareY1)
		try container.encode(square.x2, forKey: .squareX2)
		try container.encode(square.y2, forKey: .squareY2)
	}

	public init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		crop = ImageRect(
			x1: try container.decode(Double.self, forKey: .cropX1),
			y1: try container.decode(Double.self, forKey: .cropY1),
			x2: try container.decode(Double.self, forKey: .cropX2),
			y2: try container.decode(Double.self, forKey: .cropY2),
		)
		square = ImageRect(
			x1: try container.decode(Double.self, forKey: .squareX1),
			y1: try container.decode(Double.self, forKey: .squareY1),
			x2: try container.decode(Double.self, forKey: .squareX2),
			y2: try container.decode(Double.self, forKey: .squareY2),
		)
	}
}
