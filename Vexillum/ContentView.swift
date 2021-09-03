//
//  ContentView.swift
//  Vexillum
//
//  Created by Saad Anis on 7/25/21.
//

import SwiftUI

struct ContentView: View {
	
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
	
	let screenSize: CGRect = UIScreen.main.bounds
	
	let lists: [[Flags]] = []
		
	var body: some View {
		NavigationView {
			ScrollView {
				VStack(alignment: .leading){
					
					Text("Favorites")
						.font(.headline)
					if favoritesExist() {
						ScrollView(.horizontal, showsIndicators: false) {
							HStack {
								ForEach(flags, id: \.self) { flag in
									if flag.favorite {
										CardView(name: flag.countryName!, imageData: flag.imageData!, color:
													Color(red: flag.averageRed,
														  green:flag.averageGreen,
														  blue: flag.averageBlue
													), minWidth: screenSize.width/2.5, contextMenuItems: [MenuItemInfo(title: "Remove from Favorites", systemImageName: "star.slash.fill", action: {
														flag.favorite = !flag.favorite
														saveData()
													}, defaultStyle: false)], destination: AnyView(Text(flag.countryName!)))
									}
								}
							}
						}
					} else {
						VStack {
							Image(systemName: "star")
								.font(.title)
								.foregroundColor(.secondary)
							Text("No Favorites")
								.font(.none)
								.foregroundColor(.primary)
								.lineLimit(1)
								.truncationMode(.middle)
						}
						.padding()
						.frame(minWidth: screenSize.width/2.5, maxWidth: .infinity, maxHeight: .infinity)
						.background(RoundedRectangle(cornerRadius: 20.0, style: .continuous)
										.fill(Color.secondary)
										.opacity(0.3))
						.frame(minHeight: screenSize.width/4)
					}
					
					Text("Lists")
						.font(.headline)
					if lists.count == 0 {
						// If there are custom lists.
						ScrollView(.horizontal, showsIndicators: false) {
							HStack {
								CardView(name: "All Flags", iconName: "flag", color: .accentColor, minWidth: screenSize.width/2.5, destination: AnyView(FlagsView(title: "All Flags")))
								CardView(name: "Create", iconName: "plus", color: .accentColor, minWidth: screenSize.width/2.5, destination: AnyView(Text("Create")))
							}
							.frame(minHeight: screenSize.width/4)
						}
					} else {
						// If there are no custom lists.
						HStack {
							CardView(name: "All Flags", iconName: "flag", color: .accentColor, minWidth: screenSize.width/2.5, destination: AnyView(FlagsView(title: "All Flags")))
							CardView(name: "Create", iconName: "plus", color: .accentColor, minWidth: screenSize.width/2.5, destination: AnyView(Text("Create")))
						}
						.frame(minHeight: screenSize.width/4)
					}
					
					Text("Glossary")
						.font(.headline)
					ScrollView(.horizontal, showsIndicators: false) {
						HStack {
							CardView(name: "Types", iconName: "checkerboard.rectangle", color: .red, minWidth: screenSize.width/2.5, destination: AnyView(Text("Types")))
							CardView(name: "Elements", iconName: "paintbrush.pointed", color: .blue, minWidth: screenSize.width/2.5, destination: AnyView(Text("Elements")))
							CardView(name: "Patterns", iconName: "cross", color: .green, minWidth: screenSize.width/2.5, destination: AnyView(Text("Patterns")))
							CardView(name: "Techniques", iconName: "building.columns", color: .yellow, minWidth: screenSize.width/2.5, destination: AnyView(Text("Techniques")))
						}
						.frame(minHeight: screenSize.width/4)
					}
					
					Text("Others")
						.font(.headline)
					HStack {
						CardView(name: "Principles", iconName: "checkmark.seal", color: .accentColor, minWidth: screenSize.width/2.5, destination: AnyView(Text("Principles")))
						CardView(name: "About", iconName: "info.circle", color: .accentColor, minWidth: screenSize.width/2.5, destination: AnyView(AboutView()))
						
					}
					.frame(minHeight: screenSize.width/4)
					
					Spacer()
				}
			}
			.padding(.horizontal)
			.navigationBarTitle(Text("Vexillum"))
		}
	}
	
	func favoritesExist() -> Bool {
		for flag in flags {
			if flag.favorite {
				return true
			}
		}
		return false
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

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
