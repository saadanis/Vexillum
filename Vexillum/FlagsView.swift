//
//  FlagsView.swift
//  Vexillum
//
//  Created by Saad Anis on 7/26/21.
//

import SwiftUI

struct FlagsView: View {
	
	@Environment(\.managedObjectContext) var managedObjectContext
	@FetchRequest(
		entity: Flag.entity(),
		sortDescriptors: [
			NSSortDescriptor(keyPath: \Flag.countryName, ascending: true),
			NSSortDescriptor(keyPath: \Flag.imageData, ascending: false)
		]
	) var flags: FetchedResults<Flag>
	
	var title: String
	
	var body: some View {
		List {
			ForEach(flags, id: \.self) { flag in
				HStack {
					Image(uiImage: UIImage(data: Data(base64Encoded: flag.imageData! as String, options: .ignoreUnknownCharacters)!)!)
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(maxWidth: 60, maxHeight: 22)
					Text(flag.countryName ?? "Unknown")
				}
			}
		}
		.navigationBarTitle(Text(title))
	}
}

struct FlagsView_Previews: PreviewProvider {
	static var previews: some View {
		FlagsView(title: "All Flags")
	}
}
