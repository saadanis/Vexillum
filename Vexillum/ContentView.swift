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
			ScrollView {
				VStack(alignment: .leading){
					
					Text("Favorites")
						.font(.headline)
					HStack {
						CardView(name: "No Favorites", iconName: "star", color: .secondary)
					}
					.frame(minHeight: screenSize.width/4)
					
					Text("Lists")
						.font(.headline)
					if lists.count > 0 {
						// If there are custom lists.
						ScrollView(.horizontal, showsIndicators: false) {
							HStack {
								NavigationLink(destination: FlagsView(title: "All Flags")) {
									CardView(name: "All Flags", iconName: "flag", color: .accentColor, minWidth: screenSize.width/2.5)
								}
								Button(action: { }) {
									CardView(name: "Create", iconName: "plus", color: .accentColor, minWidth: screenSize.width/2.5)
								}
							}
							.frame(minHeight: screenSize.width/4)
						}
					} else {
						// If there are no custom lists.
						HStack {
							NavigationLink(destination: FlagsView(title: "All Flags")) {
								CardView(name: "All Flags", iconName: "flag", color: .accentColor, minWidth: screenSize.width/2.5)
							}
							Button(action: { }) {
								CardView(name: "Create", iconName: "plus", color: .accentColor, minWidth: screenSize.width/2.5)
							}
						}
						.frame(minHeight: screenSize.width/4)
					}
					
					Text("Glossary")
						.font(.headline)
					ScrollView(.horizontal, showsIndicators: false) {
						HStack {
							NavigationLink(destination: Text("Types")) {
								CardView(name: "Types", iconName: "checkerboard.rectangle", color: .red, minWidth: screenSize.width/2.5)
							}
							NavigationLink(destination: Text("Elements")) {
								CardView(name: "Elements", iconName: "paintbrush.pointed", color: .blue, minWidth: screenSize.width/2.5)
							}
							NavigationLink(destination: Text("Patterns")) {
								CardView(name: "Patterns", iconName: "cross", color: .green, minWidth: screenSize.width/2.5)
							}
							NavigationLink(destination: Text("Techniques")) {
								CardView(name: "Techniques", iconName: "building.columns", color: .yellow, minWidth: screenSize.width/2.5)
							}
						}
						.frame(minHeight: screenSize.width/4)
					}
					
					Text("Others")
						.font(.headline)
					HStack {
						NavigationLink(destination: Text("Principles")) {
							CardView(name: "Principles", iconName: "checkmark.seal", color: .accentColor)
						}
						NavigationLink(destination: AboutView()) {
							CardView(name: "About", iconName: "info.circle", color: .accentColor)
						}
					}
					.frame(minHeight: screenSize.width/4)
					
					Spacer()
				}
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
