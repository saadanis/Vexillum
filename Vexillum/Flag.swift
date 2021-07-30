//
//  Flag.swift
//  Vexillum
//
//  Created by Saad Anis on 7/26/21.
//

import Foundation
import SwiftUI

// These structs are used in retreiving flag data from the web service.

struct FlagImported: Codable {
	var country_name: String
	var image_url: String
}

struct Flags: Codable {
	var flags: [FlagImported]
}
