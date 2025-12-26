public protocol PotentiallyOptional<Wrapped> {
	associatedtype Wrapped

	var _optional: Wrapped? { get }

	init?(_fromOptional optional: Wrapped?)
}

extension PotentiallyOptional where Wrapped == Self {
	public var _optional: Wrapped? { self }
	public init?(_fromOptional optional: Wrapped?) {
		if let value = optional {
			self = value
		} else {
			return nil
		}
	}
}

extension Optional: PotentiallyOptional {
	public var _optional: Wrapped? { self }
	public init(_fromOptional optional: Wrapped?) {
		self = optional
	}
}

package protocol PropertyWrapperWithPotentiallyOptional {
	associatedtype WrappedValue: PotentiallyOptional

	var wrappedValue: WrappedValue { get }

	init(wrappedValue: WrappedValue)
}

extension PropertyWrapperWithPotentiallyOptional where WrappedValue.Wrapped: PotentiallyOptional {
	package var _optional: WrappedValue.Wrapped? { wrappedValue._optional }

	package init?(_fromOptional optional: WrappedValue.Wrapped?) {
		if let value = WrappedValue(_fromOptional: optional) {
			self.init(wrappedValue: value)
		} else {
			return nil
		}
	}
}

extension PropertyWrapperWithPotentiallyOptional {
	package init(from decoder: any Decoder, body: (SingleValueDecodingContainer) throws -> WrappedValue.Wrapped?) throws {
		let container = try decoder.singleValueContainer()
		let optional =  try body(container)
		if let value = WrappedValue(_fromOptional: optional) {
			self.init(wrappedValue: value)
		} else {
			throw DecodingError.valueNotFound(
				Bool.self,
				DecodingError.Context(codingPath: container.codingPath, debugDescription: "Expected a non-nil value")
			)
		}
	}
}

extension PropertyWrapperWithPotentiallyOptional {
	package func encode<R: Encodable>(
		to encoder: any Encoder,
		transformValue: (WrappedValue.Wrapped, _ codingPath: [any CodingKey]) throws -> R,
	) throws {
		var container = encoder.singleValueContainer()
		if let value = wrappedValue._optional {
			try container.encode(transformValue(value, container.codingPath))
		} else {
			try container.encodeNil()
		}
	}
}

extension KeyedEncodingContainer {
	package mutating func encode<PropertyWrapper: PropertyWrapperWithPotentiallyOptional & Encodable>(
		_ value: PropertyWrapper,
		forKey key: KeyedEncodingContainer<K>.Key
	) throws {
		let isPresent = value.wrappedValue._optional != nil
		try encodeIfPresent(isPresent ? value : nil, forKey: key)
	}
}

extension KeyedDecodingContainer {
	package func decode<PropertyWrapper: PropertyWrapperWithPotentiallyOptional & Decodable>(
		_ type: PropertyWrapper.Type,
		forKey key: KeyedDecodingContainer<K>.Key
	) throws -> PropertyWrapper
		where PropertyWrapper.WrappedValue: ExpressibleByNilLiteral
	{
		return try decodeIfPresent(PropertyWrapper.self, forKey: key) ?? PropertyWrapper(wrappedValue: nil)
	}
}
