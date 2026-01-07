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

	func testCreatePostURLEncodedFormBody() throws {
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
			encodeBodyAs: .urlEncodedForm,
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

	func testCreatePostJSONBody() throws {
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
				--header "Content-Type: application/json" \
				--data "{\"attachments\":[{\"photo_id\":\"asdg\",\"type\":\"photo\"}],\"message\":\"Hello World!&q=1\",\"owner_id\":1,\"text_format\":\"plain\"}" \
				"https://example.com/api/method/wall.post?v=1.0"
			"""#
		}
	}

	func testGetUserURLEncodedFormBody() throws {
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
			encodeBodyAs: .urlEncodedForm,
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

	func testGetUserJSONBody() throws {
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
				--header "Content-Type: application/json" \
				--data "{\"fields\":[\"relation\",\"about\",\"about\"],\"relation_case\":\"acc\",\"user_ids\":[1,2,3]}" \
				"https://example.com/api/method/users.get?v=1.0"
			"""#
		}
	}

	func testCreatePollURLEncodedFormBody() throws {
		let urlRequest = try URLRequest(
			host: "example.com",
			request: Polls.Create(
				ownerID: ActorID(GroupID(rawValue: 42)),
				question: "Cats or dogs?",
				answers: ["Cats", "Dogs"],
				anonymous: true,
				multiple: true,
				endDate: Date("2025-12-26T13:24:35Z", strategy: .iso8601),
			),
			globalParameters: GlobalRequestParameters(apiVersion: .v1_0),
			encodeBodyAs: .urlEncodedForm,
		)
		assertInlineSnapshot(of: urlRequest, as: .curl) {
			#"""
			curl \
				--request POST \
				--header "Accept: application/json" \
				--header "Content-Type: application/x-www-form-urlencoded" \
				--data "anonymous=true&answers=%5B%22Cats%22%2C%22Dogs%22%5D&end_date=1766755475&multiple=true&owner_id=-42&question=Cats%20or%20dogs%3F" \
				"https://example.com/api/method/polls.create?v=1.0"
			"""#
		}
	}

	func testCreatePollJSONBody() throws {
		let urlRequest = try URLRequest(
			host: "example.com",
			request: Polls.Create(
				ownerID: ActorID(GroupID(rawValue: 42)),
				question: "Cats or dogs?",
				answers: ["Cats", "Dogs"],
				anonymous: true,
				multiple: true,
				endDate: Date("2025-12-26T13:24:35Z", strategy: .iso8601),
			),
			globalParameters: GlobalRequestParameters(apiVersion: .v1_0),
		)
		assertInlineSnapshot(of: urlRequest, as: .curl) {
			#"""
			curl \
				--request POST \
				--header "Accept: application/json" \
				--header "Content-Type: application/json" \
				--data "{\"anonymous\":true,\"answers\":[\"Cats\",\"Dogs\"],\"end_date\":1766755475,\"multiple\":true,\"owner_id\":-42,\"question\":\"Cats or dogs?\"}" \
				"https://example.com/api/method/polls.create?v=1.0"
			"""#
		}
	}

	func testHTTPWithPort() throws {
		let urlRequest = try URLRequest(
			host: "example.com",
			port: 8080,
			useHTTPS: false,
			request: Server.GetInfo(),
			globalParameters: GlobalRequestParameters(apiVersion: .v1_0),
		)
		assertInlineSnapshot(of: urlRequest, as: .curl) {
			#"""
			curl \
				--request POST \
				--header "Accept: application/json" \
				"http://example.com:8080/api/method/server.getInfo?v=1.0"
			"""#
		}
	}

	func testSaveProfileInfoAllUnspecifiedURLEncodedFormBody() throws {
		let urlRequest = try URLRequest(
			host: "example.com",
			port: 8080,
			useHTTPS: false,
			request: Account.SaveProfileInfo(
				firstName: "",
				nickname: "",
				lastName: "",
				maidenName: "",
				sex: .unspecified,
				bdate: .unspecified,
				hometown: "",
				relation: .unspecified,
				relationPartnerID: .unspecified,
			),
			globalParameters: GlobalRequestParameters(apiVersion: .v1_0),
			encodeBodyAs: .urlEncodedForm,
		)
		assertInlineSnapshot(of: urlRequest, as: .curl) {
			#"""
			curl \
				--request POST \
				--header "Accept: application/json" \
				--header "Content-Type: application/x-www-form-urlencoded" \
				--data "bdate=&first_name=&hometown=&last_name=&maiden_name=&nickname=&relation=none&relation_partner_id=&sex=none" \
				"http://example.com:8080/api/method/account.saveProfileInfo?v=1.0"
			"""#
		}
	}

	func testSaveProfileInfoAllUnspecifiedJSONBody() throws {
		let urlRequest = try URLRequest(
			host: "example.com",
			port: 8080,
			useHTTPS: false,
			request: Account.SaveProfileInfo(
				firstName: "",
				nickname: "",
				lastName: "",
				maidenName: "",
				sex: .unspecified,
				bdate: .unspecified,
				hometown: "",
				relation: .unspecified,
				relationPartnerID: .unspecified,
			),
			globalParameters: GlobalRequestParameters(apiVersion: .v1_0),
		)
		assertInlineSnapshot(of: urlRequest, as: .curl) {
			#"""
			curl \
				--request POST \
				--header "Accept: application/json" \
				--header "Content-Type: application/json" \
				--data "{\"bdate\":\"\",\"first_name\":\"\",\"hometown\":\"\",\"last_name\":\"\",\"maiden_name\":\"\",\"nickname\":\"\",\"relation\":\"none\",\"relation_partner_id\":\"\",\"sex\":\"none\"}" \
				"http://example.com:8080/api/method/account.saveProfileInfo?v=1.0"
			"""#
		}
	}

	func testSaveProfileInfoAllSpecifiedURLEncodedFormBody() throws {
		let urlRequest = try URLRequest(
			host: "example.com",
			port: 8080,
			useHTTPS: false,
			request: Account.SaveProfileInfo(
				firstName: "Jane",
				lastName: "Doe",
				sex: .specified(.female),
				bdate: .specified(Birthday(day: 1, month: 1, year: 2000)),
				hometown: "New York City",
				relation: .specified(.inLove),
				relationPartnerID: .specified(UserID(rawValue: 1)),
			),
			globalParameters: GlobalRequestParameters(apiVersion: .v1_0),
			encodeBodyAs: .urlEncodedForm,
		)
		assertInlineSnapshot(of: urlRequest, as: .curl) {
			#"""
			curl \
				--request POST \
				--header "Accept: application/json" \
				--header "Content-Type: application/x-www-form-urlencoded" \
				--data "bdate=01.01.2000&first_name=Jane&hometown=New%20York%20City&last_name=Doe&relation=in_love&relation_partner_id=1&sex=female" \
				"http://example.com:8080/api/method/account.saveProfileInfo?v=1.0"
			"""#
		}
	}

	func testSaveProfileInfoAllSpecifiedJSONBody() throws {
		let urlRequest = try URLRequest(
			host: "example.com",
			port: 8080,
			useHTTPS: false,
			request: Account.SaveProfileInfo(
				firstName: "Jane",
				lastName: "Doe",
				sex: .specified(.female),
				bdate: .specified(Birthday(day: 1, month: 1, year: 2000)),
				hometown: "New York City",
				relation: .specified(.inLove),
				relationPartnerID: .specified(UserID(rawValue: 1)),
			),
			globalParameters: GlobalRequestParameters(apiVersion: .v1_0),
		)
		assertInlineSnapshot(of: urlRequest, as: .curl) {
			#"""
			curl \
				--request POST \
				--header "Accept: application/json" \
				--header "Content-Type: application/json" \
				--data "{\"bdate\":\"01.01.2000\",\"first_name\":\"Jane\",\"hometown\":\"New York City\",\"last_name\":\"Doe\",\"relation\":\"in_love\",\"relation_partner_id\":1,\"sex\":\"female\"}" \
				"http://example.com:8080/api/method/account.saveProfileInfo?v=1.0"
			"""#
		}
	}

	func testEditGroupURLEncodedFormBody() throws {
		let urlRequest = try URLRequest(
			host: "example.com",
			port: 8080,
			useHTTPS: false,
			request: Groups.Edit(
				groupID: GroupID(rawValue: 1),
				name: "My event",
				description: "<p>Hello!</p>",
				screenName: "myevent",
				site: .specified(URL(string: "http://example.com")!),
				accessType: .closed,
				startDate: .specified(Date(timeIntervalSince1970: 10000)),
				finishDate: .specified(Date(timeIntervalSince1970: 20000)),
				place: "New York City",
				wall: .open,
				photos: .restricted,
				board: .disabled,
			),
			globalParameters: GlobalRequestParameters(apiVersion: .v1_0),
			encodeBodyAs: .urlEncodedForm,
		)
		assertInlineSnapshot(of: urlRequest, as: .curl) {
			#"""
			curl \
				--request POST \
				--header "Accept: application/json" \
				--header "Content-Type: application/x-www-form-urlencoded" \
				--data "access_type=closed&board=disabled&description=%3Cp%3EHello%21%3C%2Fp%3E&finish_date=20000&group_id=1&name=My%20event&photos=restricted&place=New%20York%20City&screen_name=myevent&site=http%3A%2F%2Fexample.com&start_date=10000&wall=open" \
				"http://example.com:8080/api/method/groups.edit?v=1.0"
			"""#
		}
	}

	func testEditGroupJSONBody() throws {
		let urlRequest = try URLRequest(
			host: "example.com",
			port: 8080,
			useHTTPS: false,
			request: Groups.Edit(
				groupID: GroupID(rawValue: 1),
				name: "My event",
				description: "<p>Hello!</p>",
				screenName: "myevent",
				site: .specified(URL(string: "http://example.com")!),
				accessType: .closed,
				startDate: .specified(Date(timeIntervalSince1970: 10000)),
				finishDate: .specified(Date(timeIntervalSince1970: 20000)),
				place: "New York City",
				wall: .open,
				photos: .restricted,
				board: .disabled,
			),
			globalParameters: GlobalRequestParameters(apiVersion: .v1_0),
		)
		assertInlineSnapshot(of: urlRequest, as: .curl) {
			#"""
			curl \
				--request POST \
				--header "Accept: application/json" \
				--header "Content-Type: application/json" \
				--data "{\"access_type\":\"closed\",\"board\":\"disabled\",\"description\":\"<p>Hello!<\/p>\",\"finish_date\":20000,\"group_id\":1,\"name\":\"My event\",\"photos\":\"restricted\",\"place\":\"New York City\",\"screen_name\":\"myevent\",\"site\":\"http:\/\/example.com\",\"start_date\":10000,\"wall\":\"open\"}" \
				"http://example.com:8080/api/method/groups.edit?v=1.0"
			"""#
		}
	}
}
