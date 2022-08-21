//
//  ListsView.swift
//  Vexillum
//
//  Created by Saad Anis on 07/07/2022.
//

// Reordering of bunches adapted from: https://stackoverflow.com/a/62239979

import SwiftUI

struct ListsView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State var smartLists = ["Big Nordic Energy", "Flags With Moons!"]
    
    @FetchRequest(
        entity: Bunch.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Bunch.bunchOrder, ascending: true),
            NSSortDescriptor(keyPath: \Bunch.bunchName, ascending: true)
        ]
    ) var bunches: FetchedResults<Bunch>
    
    var otherBunches: [Bunch] {
        bunches.filter {
            $0.bunchName != Constants.favoritesString
        }
    }
    
    @State private var showingNewListSheet = false
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: BrowseView()) {
                    Label {
                        Text("National Flags")
                    } icon: {
                        Image(systemName: "rectangle.fill.on.rectangle.fill")
                            .foregroundColor(.accentColor)
                    }
                }
//                Section {
                    NavigationLink(destination: BrowseView(listName: Constants.favoritesString)) {
                        Label {
                            Text("Favorites")
                        } icon: {
                            Image(systemName: "star.fill")
                                .foregroundColor(.accentColor)
                        }
                    }
//                }
                Section("Custom Lists") {
                    ForEach(bunches, id: \.self) { bunch in
                        NavigationLink(destination: BrowseView(listName: bunch.bunchName)) {
                            Label {
                                Text(bunch.bunchName!)
                            } icon: {
                                Image(systemName: bunch.bunchIconName!)
                                    .foregroundColor(Constants.colorDictionary[bunch.bunchColorName!])
                            }
                        }
                    }
                    .onDelete { offsets in
                        //                        otherBunches.remove(atOffsets: offsets)
                        for index in offsets {
                            let bunch = bunches[index]
                            managedObjectContext.delete(bunch)
                        }
                    }
                    .onMove( perform: bunchMove )
                }
                Section("Smart Lists") {
                    ForEach(smartLists, id: \.self) { smartList in
                        NavigationLink(destination: Text(smartList)) {
                            Label {
                                Text(smartList)
                            } icon: {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.green)
                            }
                        }                    }
                    .onDelete { offsets in
                        smartLists.remove(atOffsets: offsets)
                    }
                    .onMove(perform: smartListMove)
                }
            }
//            .id(UUID())
            .navigationTitle("Lists")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingNewListSheet.toggle()
                    }) {
                        Label("New Custom List", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingNewListSheet) {
                NewListSheetView()
            }
        }
    }
    
    private func bunchMove(from source: IndexSet, to destination: Int) {
        
        var revisedItems: [ Bunch ] = bunches.map{ $0 }
        revisedItems.move(fromOffsets: source, toOffset: destination)
        
        for reverseIndex in stride(from: revisedItems.count - 1, through: 0, by: -1) {
            revisedItems[ reverseIndex ].bunchOrder = Int16( reverseIndex )
        }
        
        print(bunches)
    }
    
    private func smartListMove(from source: IndexSet, to destination: Int) {
        smartLists.move(fromOffsets: source, toOffset: destination)
    }
}

struct ListsView_Previews: PreviewProvider {
    static var previews: some View {
        ListsView()
    }
}
