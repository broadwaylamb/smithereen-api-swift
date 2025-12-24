import Foundation
import Hammond
import InlineSnapshotTesting
import SmithereenAPI
import XCTest

class URLRequestSnapshotTests: XCTestCase {
	func testWithTokenInHeader() throws {
		let urlRequest = try URLRequest(
			host: "example.com",
			request: Server.GetInfo(),
			globalParameters: GlobalRequestParameters(
				apiVersion: .v1_0,
				accessToken: AccessToken(rawValue: "MyToken"),
			),
		)
		assertInlineSnapshot(of: urlRequest, as: .curl) {
			#"""
			curl \
				--request POST \
				--header "Accept: application/json" \
				--header "Authorization: Bearer MyToken" \
				"https://example.com/api/method/server.getInfo?v=1.0"
			"""#
		}
	}

	func testWithTokenInQuery() throws {
		let urlRequest = try URLRequest(
			host: "example.com",
			request: Server.GetInfo(),
			globalParameters: GlobalRequestParameters(
				apiVersion: .v1_0,
				accessToken: AccessToken(rawValue: "My Token&q=1"),
			),
			passAccessTokenInHeader: false,
		)
		assertInlineSnapshot(of: urlRequest, as: .curl) {
			#"""
			curl \
				--request POST \
				--header "Accept: application/json" \
				"https://example.com/api/method/server.getInfo?access_token=My%20Token%26q%3D1&v=1.0"
			"""#
		}
	}

	func testWithEmptyHost() throws {
		let urlRequest = try URLRequest(
			host: "",
			request: Server.GetInfo(),
			globalParameters: GlobalRequestParameters(apiVersion: .v1_0),
		)
		assertInlineSnapshot(of: urlRequest, as: .curl) {
			#"""
			curl \
				--request POST \
				--header "Accept: application/json" \
				"https:///api/method/server.getInfo?v=1.0"
			"""#
		}
	}

	func testCreatePost() throws {
		let urlRequest = try URLRequest(
			host: "example.com",
			request: Wall.Post(
				ownerID: ActorID(rawValue: 1),
				message: "Hello World!&q=1",
				textFormat: .plain,
				attachments: [.photo(PhotoID(rawValue: "asdg"))],
			),
			globalParameters: GlobalRequestParameters(
				apiVersion: .v1_0,
				accessToken: AccessToken(rawValue: "MyToken"),
			),
		)
		assertInlineSnapshot(of: urlRequest, as: .curl) {
			#"""
			curl \
				--request POST \
				--header "Accept: application/json" \
				--header "Authorization: Bearer MyToken" \
				--header "Content-Type: application/x-www-form-urlencoded" \
				--data "attachments=%5B%7B%22photo_id%22%3A%22asdg%22%2C%22type%22%3A%22photo%22%7D%5D&message=Hello%20World%21%26q%3D1&owner_id=1&text_format=plain" \
				"https://example.com/api/method/wall.post?v=1.0"
			"""#
		}
	}

	func testGetUser() throws {
		let urlRequest = try URLRequest(
			host: "example.com",
			request: Users.Get(
				userIDs: [UserID(rawValue: 1), UserID(rawValue: 2), UserID(rawValue: 3)],
				fields: [.relation, .about, .about],
				relationCase: .accusative,
			),
			globalParameters: GlobalRequestParameters(
				apiVersion: .v1_0,
				accessToken: AccessToken(rawValue: "MyToken"),
			),
		)
		assertInlineSnapshot(of: urlRequest, as: .curl) {
			#"""
			curl \
				--request POST \
				--header "Accept: application/json" \
				--header "Authorization: Bearer MyToken" \
				--header "Content-Type: application/x-www-form-urlencoded" \
				--data "fields=relation%2Cabout%2Cabout&relation_case=acc&user_ids=1%2C2%2C3" \
				"https://example.com/api/method/users.get?v=1.0"
			"""#
		}
	}
}
