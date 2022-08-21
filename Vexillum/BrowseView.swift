//
//  BrowseView.swift
//  Vexillum
//
//  Created by Saad Anis on 07/07/2022.
//

import SwiftUI

struct BrowseView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @FetchRequest(
        entity: Flag.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Flag.countryName, ascending: true)
        ]
    ) var flags: FetchedResults<Flag>
    
    @FetchRequest(
        entity: Bunch.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Bunch.bunchName, ascending: true)
        ]
    ) var bunches: FetchedResults<Bunch>
    
    @State private var searchText = ""
    
    var listName: String?
    
    var searchResults: Array<Flag> {
        
        var localFlags: [Flag] = []
        
        if let unwrappedListName = listName {
            for bunch in bunches {
                if bunch.bunchName == unwrappedListName {
                    localFlags = bunch.flags!.allObjects as! [Flag]
                }
            }
        } else {
            localFlags = flags.filter {
                $0.countryName == $0.countryName
            }
        }
        
        if searchText.isEmpty {
            return localFlags.filter {
                $0.countryName == $0.countryName
            }
        } else {
            return localFlags.filter { $0.countryName!.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var title: String {
        if let listName = listName {
            if listName == Constants.favoritesString {
                return "Favorites"
            } else {
                return listName
            }
        } else {
            return "National Flags"
        }
    }
    
    let layout = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    struct CellContent: View {
        var flagId: String
        var countryName: String
        var color: Color
        var destination: FlagView
        
        var body: some View {
            NavigationLink(destination: destination) {
                VStack {
                    Image("\(flagId)")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(countryName == "Nepal" ? 0 : 7)
                        .frame(height: 70)
                    Text("\(countryName)")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                }
                .padding()
                .frame(minWidth: 50, maxWidth: .infinity, minHeight: 150)
                .background(color.opacity(0.3))
                .cornerRadius(10)
            }
        }
    }
    
    var body: some View {
//        NavigationView {
            ScrollView {
                LazyVGrid(columns: layout) {
                    ForEach(searchResults, id: \.self) { flag in
                        CellContent(flagId: flag.flagId!, countryName: flag.countryName!, color: Color(red: flag.averageRed/255, green: flag.averageGreen/255, blue: flag.averageBlue/255), destination: FlagView(flag: flag))
                    }
                }
                .searchable(text: $searchText)
                .disableAutocorrection(true)
                .textInputAutocapitalization(.never)
                .padding(.horizontal)
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                        //                        Text("Filter")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {}) {
                            Label("Country Name", systemImage: "signature")
                        }
                        Button(action: {}) {
                            Label("Year of Inception", systemImage: "calendar")
                        }
                        Divider()
                        Button(action: {}) {
                            Label("Ascending", systemImage: "arrowtriangle.up")
                        }
                        Button(action: {}) {
                            Label("Descending", systemImage: "arrowtriangle.down")
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down.circle")
                        //                        Text("Sort By")
                    }
                }
            }
//        }
    }
}

struct BrowseView_Previews: PreviewProvider {
    static var previews: some View {
        BrowseView()
    }
}
