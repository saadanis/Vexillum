//
//  GlossaryView.swift
//  Vexillum
//
//  Created by Saad Anis on 7/30/21.
//

import SwiftUI

// Deprecated.

struct GlossaryView: View {
	var body: some View {
			VStack {
				HStack {
					CardView(name: "Types", iconName: "checkerboard.rectangle", color: .red, destination: AnyView(Text("Text")))
					CardView(name: "Elements", iconName: "paintbrush.pointed", color: .blue, destination: AnyView(Text("Text")))
				}
				.padding(.horizontal)
				HStack {
					CardView(name: "Patterns", iconName: "cross", color: .green, destination: AnyView(Text("Text")))
					CardView(name: "Techniques", iconName: "building.columns", color: .yellow, destination: AnyView(Text("Text")))
				}
				.padding(.horizontal)
			}
		.navigationBarTitle("Glossary")
	}
}

struct GlossaryView_Previews: PreviewProvider {
	static var previews: some View {
//		NavigationView {
			GlossaryView()
//		}
	}
}
