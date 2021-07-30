//
//  VexillumApp.swift
//  Vexillum
//
//  Created by Saad Anis on 7/25/21.
//

import SwiftUI

@main
struct VexillumApp: App {
	
	let persistenceController = PersistenceController.shared
	@Environment(\.scenePhase) var scenePhase
	
	@State var dataIsLoaded = false
	
	var body: some Scene {
		WindowGroup {
			if dataIsLoaded {
				ContentView()
					.environment(\.managedObjectContext, persistenceController.container.viewContext)
			} else {
				LoadingView(dataIsLoaded: $dataIsLoaded)
					.environment(\.managedObjectContext, persistenceController.container.viewContext)
			}
		}
		.onChange(of: scenePhase) { _ in
			persistenceController.save()
		}
	}
}
