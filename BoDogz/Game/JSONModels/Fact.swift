import Foundation

struct Fact : Codable {
    let facts : [String]?
    let success : Bool?

    enum CodingKeys: String, CodingKey {

        case facts = "facts"
        case success = "success"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        facts = try values.decodeIfPresent([String].self, forKey: .facts)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
    }

}
