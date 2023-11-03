//
//  ListsView.swift
//  Vexillum
//
//  Created by Saad Anis on 07/07/2022.
//

// Reordering of bunches adapted from: https://stackoverflow.com/a/62239979
// Fixed the pop-back issue using .navigationViewStyle(.stack)

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
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(0..<10) {_ in 
                            BrowseView.CellContent(flagId: "", countryName: "National Flags", color: Color.red, destination: BrowseView())
                        }
                    }
                }
                Section {
                    ForEach(bunches) { bunch in
                        NavigationLink(destination: BrowseView(bunch: bunch)) {
                            Label {
                                Text(bunch.bunchName!)
                            } icon: {
                                Image(systemName: bunch.bunchIconName!)
                                    .foregroundColor(Constants.colorDictionary[bunch.bunchColorName!])
                            }
                        }
                    }
                    .onDelete { offsets in
                        for index in offsets {
                            let bunch = bunches[index]
                            managedObjectContext.delete(bunch)
                        }
                    }
                    .onMove( perform: bunchMove )
                }
            }
            .navigationTitle("Lists")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingNewListSheet.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingNewListSheet) {
                NewListSheetView()
            }
        }
        .navigationViewStyle(.stack)
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
