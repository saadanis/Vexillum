//
//  Flag.swift
//  Vexillum
//
//  Created by Saad Anis on 7/26/21.
//

import Foundation
import SwiftUI

struct FlagJSON: Decodable {
	var country_name: String
	var image_url: String
	var flag_id: String
	var country_id: String
	var genre: [String]?
	var aspect_ratio: String
	var color: [String]
    var colours: [String]
	var depicts: [String]?
	var inception: Int
	var nickname: String?
	var continent: [String]
	var average_red: Int
	var average_green: Int
	var average_blue: Int
    var visible: Bool
}

struct ColourJSON: Decodable {
	var colour_hex: String
    var colour_name: String
}

struct FilterOption: Identifiable {
    var id = UUID()
    var type: String
    var values: [String]
    var isUnion: Bool
}
