//
//  PersistenceController.swift
//  Vexillum
//
//  Created by Saad Anis on 7/30/21.
//

import Foundation
import SwiftUI
import CoreData

struct PersistenceController {
	// A singleton for our entire app to use.
	static let shared = PersistenceController()
	
	// Storage for Core Data
	let container: NSPersistentContainer
	
	//A test configuration for SwiftUI previews
	static var preview: PersistenceController = {
		let controller = PersistenceController(inMemory: true)
		
		// Create 10 example flags
		for _ in 0..<10 {
			let flag = Flag(context: controller.container.viewContext)
			flag.countryName = "United Country"
			flag.imageData = UIImage(systemName: "rectangle.slash")!.jpegData(compressionQuality: 1.0)!.base64EncodedString()
		}
		
		return controller
	}()
	
	// An initializer to load Core Data, optionally able to to use an in-memory store.
	init(inMemory: Bool = false) {
		container = NSPersistentContainer(name: "Model")
		
		if inMemory {
			container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
		}
		
		container.loadPersistentStores { description, error in
			if let error = error {
				fatalError("Error: \(error.localizedDescription)")
			}
		}
	}
	
	func save() {
		let context = container.viewContext
		
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				print("Unable to save data.")
			}
		}
	}
}
