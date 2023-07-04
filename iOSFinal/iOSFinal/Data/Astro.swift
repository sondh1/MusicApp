
import Foundation
struct Astro : Codable {
	let sunrise : String?
	let sunset : String?
	let moonrise : String?
	let moonset : String?
	let moon_phase : String?
	let moon_illumination : String?

	enum CodingKeys: String, CodingKey {

		case sunrise = "sunrise"
		case sunset = "sunset"
		case moonrise = "moonrise"
		case moonset = "moonset"
		case moon_phase = "moon_phase"
		case moon_illumination = "moon_illumination"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		sunrise = try values.decodeIfPresent(String.self, forKey: .sunrise)
		sunset = try values.decodeIfPresent(String.self, forKey: .sunset)
		moonrise = try values.decodeIfPresent(String.self, forKey: .moonrise)
		moonset = try values.decodeIfPresent(String.self, forKey: .moonset)
		moon_phase = try values.decodeIfPresent(String.self, forKey: .moon_phase)
		moon_illumination = try values.decodeIfPresent(String.self, forKey: .moon_illumination)
	}

}
