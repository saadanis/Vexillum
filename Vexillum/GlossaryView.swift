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
					CardView(name: "Types", iconName: "checkerboard.rectangle", color: .red)
					CardView(name: "Elements", iconName: "paintbrush.pointed", color: .blue)
				}
				.padding(.horizontal)
				HStack {
					CardView(name: "Patterns", iconName: "cross", color: .green)
					CardView(name: "Techniques", iconName: "building.columns", color: .yellow)
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
