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
			NSSortDescriptor(keyPath: \Flag.averageBlue, ascending: false),
			NSSortDescriptor(keyPath: \Flag.favorite, ascending: false)
		]
	) var flags: FetchedResults<Flag>
	
	// The flags_left_indices list contains the incides of the flags that will be on the left side in each row.
	// For example, [0,2,4,...]
	// It is initialized in the onAppear() function.
	@State private var flags_left_indices = [Int]()
	
	var title: String
	
	var body: some View {
		ScrollView(.vertical) {
			LazyVStack(alignment:.leading) {
				ForEach(flags_left_indices, id: \.self) { x in
					HStack(alignment: .top) {
						Spacer()
						FlagCardView(index: x)
						FlagCardView(index: x+1)
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
	
	func saveData() {
		print("Attempting to save data.")
		do {
			if managedObjectContext.hasChanges {
				try managedObjectContext.save()
			}
		} catch {
			fatalError("Issue.")
		}
	}
}

struct FlagCardView: View {
	
	@Environment(\.managedObjectContext) var managedObjectContext
	@FetchRequest(
		entity: Flag.entity(),
		sortDescriptors: [
			NSSortDescriptor(keyPath: \Flag.countryName, ascending: true),
			NSSortDescriptor(keyPath: \Flag.imageData, ascending: false),
			NSSortDescriptor(keyPath: \Flag.averageRed, ascending: false),
			NSSortDescriptor(keyPath: \Flag.averageGreen, ascending: false),
			NSSortDescriptor(keyPath: \Flag.averageBlue, ascending: false),
			NSSortDescriptor(keyPath: \Flag.favorite, ascending: false)
		]
	) var flags: FetchedResults<Flag>
	
	let index: Int
	
	var body: some View {
		CardView(name: flags[index].countryName!, imageData: flags[index].imageData!, color: Color(red: flags[index].averageRed, green:flags[index].averageGreen, blue: flags[index].averageBlue), contextMenuItems: [MenuItemInfo(title: flags[index].favorite ? "Remove from Favorites" : "Add to Favorites", systemImageName: flags[index].favorite ? "star.slash.fill" : "star", action: {
			flags[index].favorite = !flags[index].favorite
			saveData()
		}, defaultStyle: flags[index].favorite ? false : true)], destination: AnyView(Text(flags[index].countryName!)))
		.frame(maxHeight: .infinity)
	}
	
	func saveData() {
		print("Attempting to save data.")
		do {
			if managedObjectContext.hasChanges {
				try managedObjectContext.save()
			}
		} catch {
			fatalError("Issue.")
		}
	}
}

struct FlagsView_Previews: PreviewProvider {
	static var previews: some View {
		FlagsView(title: "All Flags")
	}
}
