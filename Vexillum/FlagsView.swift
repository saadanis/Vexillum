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
			NSSortDescriptor(keyPath: \Flag.imageData, ascending: false),
			NSSortDescriptor(keyPath: \Flag.averageRed, ascending: false),
			NSSortDescriptor(keyPath: \Flag.averageGreen, ascending: false),
			NSSortDescriptor(keyPath: \Flag.averageBlue, ascending: false)
		]
	) var flags: FetchedResults<Flag>
	
	// The flags_left_indices list contains the incides of the flags that will be on the left side in each row.
	// For example, [0,2,4,...]
	// It is initialized in the onAppear() function.
	@State private var flags_left_indices = [Int]()
	
	var title: String
	
	var body: some View {
		ScrollView(.vertical) {
			VStack(alignment:.leading) {
				ForEach(flags_left_indices, id: \.self) { x in
					HStack(alignment: .top) {
						Spacer()
						NavigationLink(destination: Text("")) {
							CardView(name: flags[x].countryName!, imageData: flags[x].imageData!, color:
										Color(red: flags[x].averageRed,
											  green:flags[x].averageGreen,
											  blue: flags[x].averageBlue
										))
						}
						.frame(maxHeight: .infinity)
						NavigationLink(destination: Text("")) {
							CardView(name: flags[x+1].countryName!, imageData: flags[x+1].imageData!, color: Color(
								red: flags[x+1].averageRed,
								green:flags[x+1].averageGreen,
								blue: flags[x+1].averageBlue
							))
						}
						.frame(maxHeight: .infinity)
						Spacer()
					}
				}
			}
		}
		.navigationBarTitle(Text(title))
		.onAppear() {
			(0..<flags.count/2).forEach({ i in
				flags_left_indices.append(i*2)
			})
		}
	}
}

struct FlagsView_Previews: PreviewProvider {
	static var previews: some View {
		FlagsView(title: "All Flags")
	}
}
