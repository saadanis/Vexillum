//
//  ContentView.swift
//  Vexillum
//
//  Created by Saad Anis on 7/25/21.
//

import SwiftUI

struct ContentView: View {
	
	let screenSize: CGRect = UIScreen.main.bounds
	
	let lists: [[Flags]] = []
	
	var body: some View {
		NavigationView {
			VStack(alignment: .leading){
				
				Text("Favorites")
					.font(.headline)
				HStack {
					CardView(name: "No Favorites", iconName: "star", color: .secondary)
				}
				.frame(maxHeight: screenSize.width/3)
				
				Text("Lists")
					.font(.headline)
				if lists.count > 0 {
					// If there are custom lists.
					ScrollView(.horizontal) {
						HStack {
							NavigationLink(destination: FlagsView(title: "All Flags")) {
								CardView(name: "All Flags", iconName: "flag", color: .accentColor, minWidth: screenSize.width/3)
							}
							Button(action: { }) {
								CardView(name: "Create", iconName: "plus", color: .accentColor, minWidth: screenSize.width/3)
							}
						}
						.frame(maxHeight: screenSize.width/3)
					}
				} else {
					// If there are no custom lists.
					HStack {
						NavigationLink(destination: FlagsView(title: "All Flags")) {
							CardView(name: "All Flags", iconName: "flag", color: .accentColor, minWidth: screenSize.width/3)
						}
						Button(action: { }) {
							CardView(name: "Create", iconName: "plus", color: .accentColor, minWidth: screenSize.width/3)
						}
					}
					.frame(maxHeight: screenSize.width/3)
				}
				
				Text("Others")
					.font(.headline)
				HStack {
					NavigationLink(destination: Text("Principles")) {
						CardView(name: "Principles", iconName: "checkmark.seal", color: .accentColor)
					}
					NavigationLink(destination: GlossaryView()) {
						CardView(name: "Glossary", iconName: "text.book.closed", color: .accentColor)
					}
					NavigationLink(destination: AboutView()) {
						CardView(name: "About", iconName: "info.circle", color: .accentColor)
					}
				}
				.frame(maxHeight: screenSize.width/4)
				
				Spacer()
			}
			.padding()
			.navigationBarTitle(Text("Vexillum"))
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
