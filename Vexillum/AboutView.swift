//
//  AboutView.swift
//  Vexillum
//
//  Created by Saad Anis on 7/25/21.
//

import SwiftUI

struct AboutView: View {
	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 15) {
				VStack(alignment: .leading, spacing: 5) {
					Label("Hello", systemImage: "eyes")
						.font(.title2)
					Text("I am Saad, a computer science student and a hobbyist developer. Vexillum is one of my side-projects.")
						.padding(.bottom)
					Label {
						Link("Twitter", destination: URL(string: "https://twitter.com/saadxanis")!)
					} icon: {
						Image(systemName: "person.crop.circle")
							.foregroundColor(.accentColor)
					}
					Label {
						Link("Website", destination: URL(string: "https://saadanis.com")!)
					} icon: {
						Image(systemName: "network")
							.foregroundColor(.accentColor)
					}
				}
				.frame(maxWidth: .infinity)
				.padding()
				.background(
					RoundedRectangle(cornerRadius: 25, style: .continuous)
						.fill(Color.secondary)
						.opacity(0.1)
				)
				VStack(alignment: .leading, spacing: 5) {
					Label("References", systemImage: "books.vertical")
						.font(.title2)
					Text("I used the following resources to the gather relevant information about flags.")
						.minimumScaleFactor(0.5)
						.padding(.bottom)
					Label {
						Link("Wikipedia & Wikimedia Commons", destination: URL(string: "https://wikipedia.org/")!)
					} icon: {
						Image(systemName: "doc.text")
							.foregroundColor(.accentColor)
					}
					Label {
						Link("North American Vexillological Association", destination: URL(string: "https://nava.org")!)
							.minimumScaleFactor(0.5)
					} icon: {
						Image(systemName: "flag")
							.foregroundColor(.accentColor)
					}
				}
				.frame(maxWidth: .infinity)
				.padding()
				.background(
					RoundedRectangle(cornerRadius: 25, style: .continuous)
						.fill(Color.secondary)
						.opacity(0.1)
				)
				VStack(spacing: 5) {
					Text("Vexillum 0.1\n© 2021 Saad Anis")
						.font(.footnote)
						.multilineTextAlignment(.center)
					HStack {
						Image(systemName: "flame")
					}
				}
				.frame(maxWidth: .infinity)
				.padding()
				.background(
					RoundedRectangle(cornerRadius: 25, style: .continuous)
						.fill(Color.secondary)
						.opacity(0)
				)
				Spacer()
			}
		}
		.padding()
		.navigationBarTitle(Text("About"))
	}
}

struct AboutView_Previews: PreviewProvider {
	static var previews: some View {
		AboutView()
	}
}
