import Foundation
struct List : Codable {
	let weight : Weight?
	let height : Height?
	let id : Int?
	let name : String?
	let bredFor : String?
	let breedGroup : String?
	let lifeSpan : String?
	let temperament : String?
	let origin : String?
	let referenceImageId : String?
	let image : Image?

	enum CodingKeys: String, CodingKey {

		case weight = "weight"
		case height = "height"
		case id = "id"
		case name = "name"
		case bredFor = "bred_for"
		case breedGroup = "breed_group"
		case lifeSpan = "life_span"
		case temperament = "temperament"
		case origin = "origin"
		case referenceImageId = "reference_image_id"
		case image = "image"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		weight = try values.decodeIfPresent(Weight.self, forKey: .weight)
		height = try values.decodeIfPresent(Height.self, forKey: .height)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
        bredFor = try values.decodeIfPresent(String.self, forKey: .bredFor)
        breedGroup = try values.decodeIfPresent(String.self, forKey: .breedGroup)
        lifeSpan = try values.decodeIfPresent(String.self, forKey: .lifeSpan)
		temperament = try values.decodeIfPresent(String.self, forKey: .temperament)
		origin = try values.decodeIfPresent(String.self, forKey: .origin)
        referenceImageId = try values.decodeIfPresent(String.self, forKey: .referenceImageId)
		image = try values.decodeIfPresent(Image.self, forKey: .image)
	}

}
