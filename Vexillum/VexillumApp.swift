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
                ListsView()
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

struct Constants {
    static let colorDictionary: [String: Color] = [
        "primary": .primary,
        "red": .red,
        "orange": .orange,
        "yellow": .yellow,
        "green": .green,
        "mint": .mint,
        "teal": .teal,
        "cyan": .cyan,
        "blue": .blue,
        "indigo": .indigo,
        "purple": .purple,
        "pink": .pink,
        "brown": .brown
    ]
}

extension Dictionary where Value: Equatable {
    func someKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}
