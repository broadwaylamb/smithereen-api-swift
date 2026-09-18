//
//  CustomDebugStringRepresentable.swift
//  SmithereenAPI
//
//  Created by Sergej.Jaskiewicz on 18.09.2026.
//

extension User: CustomDebugStringConvertible {
	public var debugDescription: String {
		var res = firstName
		if let nickname {
			res += " "
			res += nickname
		}
		if let lastName {
			res += " "
			res += lastName
		}
		if let maidenName {
			res += " ("
			res += maidenName
			res += ")"
		}
		return res
	}
}

extension Group: CustomDebugStringConvertible {
	public var debugDescription: String {
		name
	}
}
