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
    
    static let aspectRatios: [String] = [
        "1.2190103:1",
        "1:1",
        "13:15",
        "6:7",
        "14:17",
        "4:5",
        "3:4",
        "8:11",
        "18:25",
        "5:7",
        "7:10",
        "15:22",
        "2:3",
        "7:11",
        "5:8",
        "1:1.618",
        "11:18",
        "3:5",
        "4:7",
        "189:335",
        "11:20",
        "19:36",
        "10:19",
        "1:2",
        "11:28"
    ]
    
    static let continents: [String] = [
        "Asia",
        "Europe",
        "Africa",
        "Oceania",
        "North America",
        "South America"
    ]
}

extension Dictionary where Value: Equatable {
    func someKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}
