import Foundation
import ReerCodable

@Codable
@SnakeCase
public struct User {
	public var id: UserID
	
	public var firstName: String
	
	public var lastName: String?
	
	public var deactivated: FutureProof<DeactivatedStatus>?

	/// Always non-nil for Smithereen, always nil for OpenVK
	public var activityPubID: URL?
	
	public var domain: String?
	
	public var screenName: String?
	
	public var status: String?
	
	public var url: URL?

	var nickname: String?
	
	var maidenName: String?

	@CodingKey("sex")
	public var gender: Gender?

	public var birthday: Birthday?
	
	public var homeTown: String?

	public var relation: FutureProof<RelationshipStatus>?

	public var relationPartner: RelationshipPartner?

	@CodingKey("custom")
	public var customFields: [CustomProfileField] = []

	public var city: String?

	public var matrix: String?

	public var xmpp: String?

	public var telegram: String?

	public var signal: String?

	public var twitter: String?

	public var instagram: String?

	public var facebook: String?

	public var vkontakte: String?

	public var snapchat: String?

	public var discord: String?

	public var git: URL?

	public var mastodon: String?

	public var pixelfed: String?
	
	public var phoneNumber: String?

	public var email: String?

	public var site: URL?

	public var activities: String?

	public var interests: String?

	public var music: String?

	public var movies: String?

	public var tv: String?

	public var books: String?

	public var games: String?

	public var quotes: String?

	public var about: String?

	public var personal: PersonalViews?

	@FlexibleType
	public var online: Bool?

	@FlexibleType
	public var onlineMobile: Bool?

	public var lastSeen: LastSeen?

	@FlexibleType
	public var blocked: Bool?

	@FlexibleType
	public var blockedByMe: Bool?

	@FlexibleType
	public var canPost: Bool?

	@FlexibleType
	public var canSeeAllPosts: Bool?

	@FlexibleType
	public var canSendFriendRequest: Bool?

	@FlexibleType
	public var canWritePrivateMessage: Bool?

	public var mutualCount: Int?

	@FlexibleType
	public var isFriend: Bool?

	@FlexibleType
	public var isFavorite: Bool?

	public var lists: [FriendListID] = []

	@FlexibleType
	public var isHiddenFromFeed: Bool?

	public var followersCount: Int?

	@FlexibleType
	public var isNoIndex: Bool?

	public var wallDefault: WallMode?

	@CodingKey("photo_50")
	public var photo50: URL?

	@CodingKey("photo_100")
	public var photo100: URL?

	@CodingKey("photo_200")
	public var photo200: URL?

	@CodingKey("photo_400")
	public var photo400: URL?

	@CodingKey("photo_200_orig")
	public var photo200Orig: URL?

	@CodingKey("photo_400_orig")
	public var photo400Orig: URL?

	public var photoMaxOrig: URL?

	public var photoMax: URL?

	public var photoID: PhotoID?

	public var timezone: TimeZone?

	public var firstNameNom: String?
	public var firstNameGen: String?
	public var firstNameDat: String?
	public var firstNameAcc: String?
	public var firstNameIns: String?
	public var firstNameAbl: String?

	public var lastNameNom: String?
	public var lastNameGen: String?
	public var lastNameDat: String?
	public var lastNameAcc: String?
	public var lastNameIns: String?
	public var lastNameAbl: String?

	public var nicknameNom: String?
	public var nicknameGen: String?
	public var nicknameDat: String?
	public var nicknameAcc: String?
	public var nicknameIns: String?
	public var nicknameAbl: String?

	public var counters: Counters?
}

extension User {
	public enum DeactivatedStatus: String, Codable {
		case banned
		case hidden
		case deleteds
	}

	// Smithereen uses string values, VK and OpenVK — integer values
	@Codable
	public enum Gender: String {
		@CodingCase(match: .string("male"), .int(2))
		case male

		@CodingCase(match: .string("female"), .int(1))
		case female

		@CodingCase(match: .string("other"))
		case other
	}

	public struct Birthday: Codable {
		var day: Int
		var month: Int
		var year: Int?

		public func encode(to encoder: any Encoder) throws {
			var container = encoder.singleValueContainer()
			if let year {
				try container.encode("\(day).\(month).\(year)")
			} else {
				try container.encode("\(day).\(month)")
			}
		}

		public init(from decoder: any Decoder) throws {
			let container = try decoder.singleValueContainer()
			let components = try container.decode(String.self).split(separator: ".", maxSplits: 2)
			let error = "Invalid date, expected format DD.MM.YYYY or DD.MM"
			if components.count >= 2 || components.count <= 3 {
				day = try parseInt(components[0], container, error: error)
				month = try parseInt(components[1], container, error: error)
				if components.count == 3 {
					year = try parseInt(components[2], container, error: error)
				}
			} else {
				throw DecodingError.dataCorruptedError(in: container, debugDescription: error)
			}
		}
	}

	// Smithereen uses string values, VK and OpenVK — integer values
	@Codable
	public enum RelationshipStatus: String {
		@CodingCase(match: .string("single"), .int(1))
		case single

		@CodingCase(match: .string("in_relationship"), .int(2))
		case inRelationship = "in_relationship"

		@CodingCase(match: .string("engaged"), .int(3))
		case engaged

		@CodingCase(match: .string("married"), .int(4))
		case married

		@CodingCase(match: .string("complicated"), .int(5))
		case complicated

		@CodingCase(match: .string("actively_searching"), .int(6))
		case activelySearching = "actively_searching"

		@CodingCase(match: .string("in_love"), .int(7))
		case inLove = "in_love"

		@CodingCase(match: .int(8))
		case civilMarriage = "in_civil_marriage"
	}

	public struct RelationshipPartner: Codable {
		public var id: UserID
		public var name: String
	}

	public struct CustomProfileField: Codable {
		public var name: String
		public var value: String		
	}

	@Codable
	@SnakeCase
	public struct PersonalViews {
		public var political: FutureProof<PoliticalViews>?
		public var religion: String?
		public var inspiredBy: String?
		public var peopleMain: FutureProof<PeoplePriority>?
		public var lifeMain: FutureProof<PersonalPriority>?
		public var smoking: FutureProof<HabitsViews>?
		public var alcohol: FutureProof<HabitsViews>?
	}

	@Codable
	public enum PoliticalViews: String {
		@CodingCase(match: .string("communist"), .int(1))
		case communist

		@CodingCase(match: .string("socialist"), .int(2))
		case socialist

		@CodingCase(match: .string("moderate"), .int(3))
		case moderate

		@CodingCase(match: .string("liberal"), .int(4))
		case liberal

		@CodingCase(match: .string("conservative"), .int(5))
		case conservative

		@CodingCase(match: .string("monarchist"), .int(6))
		case monarchist

		@CodingCase(match: .string("ultraconservative"), .int(7))
		case ultraconservative

		@CodingCase(match: .string("apathetic"), .int(8))
		case apathetic

		@CodingCase(match: .string("libertarian"), .int(9))
		case libertarian
	}

	@Codable
	public enum PeoplePriority: String {
		@CodingCase(match: .string("intellect_creativity"), .int(1))
		case intellectCreativity = "intellect_creativity"

		@CodingCase(match: .string("kindness_honesty"), .int(2))
		case kindnessHonesty = "kindness_honesty"

		@CodingCase(match: .string("health_beauty"), .int(3))
		case healthBeauty = "health_beauty"

		@CodingCase(match: .string("wealth_power"), .int(4))
		case wealthPower = "wealth_power"

		@CodingCase(match: .string("courage_persistence"), .int(5))
		case couragePersistence = "courage_persistence"

		@CodingCase(match: .string("humor_life_love"), .int(6))
		case humorLifeLove = "humor_life_love"
	}

	@Codable
	public enum PersonalPriority: String {
		@CodingCase(match: .string("family_children"), .int(1))
		case familyChildren = "family_children"

		@CodingCase(match: .string("career_money"), .int(2))
		case careerMoney = "career_money"
		
		@CodingCase(match: .string("entertainment_leisure"), .int(3))
		case entertainmentLeisure = "entertainment_leisure"
		
		@CodingCase(match: .string("science_research"), .int(4))
		case scienceResearch = "science_research"
		
		@CodingCase(match: .string("improving_world"), .int(5))
		case improvingWorld = "improving_world"

		@CodingCase(match: .string("personal_development"), .int(6))
		case personalDevelopment = "personal_development"

		@CodingCase(match: .string("beauty_art"), .int(7))
		case beautyArt = "beauty_art"
		
		@CodingCase(match: .string("fame_influence"), .int(8))
		case fameInfluence = "fame_influence"
	}

	@Codable
	public enum HabitsViews: String {
		@CodingCase(match: .string("very_negative"), .int(1))
		case veryNegative = "very_negative"
		
		@CodingCase(match: .string("negative"), .int(2))
		case negative
		
		@CodingCase(match: .string("tolerant"), .int(3))
		case tolerant
		
		@CodingCase(match: .string("neutral"), .int(4))
		case neutral
		
		@CodingCase(match: .string("positive"), .int(5))
		case positive
	}

	@Codable
	@SnakeCase
	public struct LastSeen {
		@DateCoding(.secondsSince1970)
		public var time: Date

		public var platform: FutureProof<Platform>

		@Codable
		public enum Platform: String {
			@CodingCase(match: .string("mobile"), .int(1))
			case mobile

			@CodingCase(match: .string("desktop"), .int(7))
			case desktop
		}
	}

	@Codable
	public enum FriendStatus: String {
		@CodingCase(match: .string("none"), .int(0))
		case none

		@CodingCase(match: .string("following"), .int(1))
		case following

		@CodingCase(match: .string("followed_by"), .int(2))
		case followedBy = "followed_by"

		@CodingCase(match: .string("friends"), .int(3))
		case friends
		
		@CodingCase(match: .string("follow_requested"))
		case followRequested = "follow_requested"
	}

	public enum WallMode: String, Codable {
		case owner
		case all
	}

	@Codable
	@SnakeCase
	public struct Counters {
		public var albums: Int = 0
		public var videos: Int = 0
		public var audios: Int = 0
		public var photos: Int = 0
		public var friends: Int = 0
		public var groups: Int = 0
		public var onlineFriends: Int = 0
		public var mutualFriends: Int = 0
		public var userVideos: Int = 0
		public var userPhotos: Int = 0
		public var followers: Int = 0
		public var subscriptions: Int = 0
	}
}

extension User.RelationshipStatus {
	public var canHavePartner: Bool {
		switch self {
		case .single, .activelySearching:
			return false
		default:
			return true
		}
	}

	public var needsPartnerApproval: Bool {
		return canHavePartner && self != .inLove
	}
}
