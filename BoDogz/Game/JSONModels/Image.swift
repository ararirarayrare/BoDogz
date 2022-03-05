import Foundation

struct Image : Codable {
	let id : String?
	let width : Int?
	let height : Int?
	let url : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case width = "width"
		case height = "height"
		case url = "url"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		width = try values.decodeIfPresent(Int.self, forKey: .width)
		height = try values.decodeIfPresent(Int.self, forKey: .height)
		url = try values.decodeIfPresent(String.self, forKey: .url)
	}

}
