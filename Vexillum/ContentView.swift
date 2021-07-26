//
//  ContentView.swift
//  Vexillum
//
//  Created by Saad Anis on 7/25/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                List {
					Section(header: Text("Favorites")) {
						NavigationLink(
							destination: Text("Default"),
							label: {
								Label {
									Text("Canada")
								} icon: {
									Image("ca")
										.resizable()
										.aspectRatio(contentMode: .fill)
								}
							})
					}
                    Section(header: Text("Lists")) {
						NavigationLink(
							destination: Text("Default"),
							label: {
								Label("All Flags", systemImage: "flag")
							})
						Button(action:{}) { Label("Add Custom List",systemImage: "plus")
							.foregroundColor(.accentColor)
						}
                    }
					Section(header: Text("Others")) {
						NavigationLink(
							destination: Text("Default"),
							label: {
								Label("Principles of Flag Design", systemImage: "checkmark.seal")
							})
						NavigationLink(
							destination: Text("Glossary"),
							label: {
								Label("Glossary", systemImage: "text.book.closed")
							})
						NavigationLink(
							destination: AboutView(),
							label: {
								Label("About", systemImage: "info.circle")
							})
					}
                }
            }
                .navigationBarTitle(Text("Vexillum"))

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
