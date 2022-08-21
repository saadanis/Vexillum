//
//  ContentView.swift
//  Vexillum
//
//  Created by Saad Anis on 7/25/21.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
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
    
    @State var favoritesExist = false
    
    @State var favoriteFlags: [Flag] = []
    
    @State var otherBunches: [Bunch] = []
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    @State private var showingNewListSheet = false
    @State private var showingNewSmartListSheet = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading) {
                        Text("Favorites")
                            .font(.title2)
                            .bold()
                            .padding(.leading)
                            .padding(.top)
                        if favoriteFlags.count > 0 {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(0..<favoriteFlags.count, id: \.self) { i in
                                        if i == 0 {
                                            CardView(name: favoriteFlags[i].countryName!, imageName: favoriteFlags[i].flagId!, color:
                                                        Color(red: favoriteFlags[i].averageRed/255,
                                                              green:favoriteFlags[i].averageGreen/255,
                                                              blue: favoriteFlags[i].averageBlue/255
                                                             ), minWidth: screenSize.width/2.5, destination: AnyView(FlagView(flag: favoriteFlags[i])))
                                            //												.frame(minWidth: screenSize.width/2, maxWidth: screenSize.width/2)
                                            .padding(.leading)
                                        }
                                        else if i == favoriteFlags.count-1 {
                                            CardView(name: favoriteFlags[i].countryName!, imageName: favoriteFlags[i].flagId!, color:
                                                        Color(red: favoriteFlags[i].averageRed/255,
                                                              green:favoriteFlags[i].averageGreen/255,
                                                              blue: favoriteFlags[i].averageBlue/255
                                                             ), minWidth: screenSize.width/2.5, destination: AnyView(FlagView(flag: favoriteFlags[i])))
                                            //												.frame(minWidth: screenSize.width/2, maxWidth: screenSize.width/2)
                                            .padding(.trailing)
                                        }
                                        else if i < favoriteFlags.count {
                                            CardView(name: favoriteFlags[i].countryName!, imageName: favoriteFlags[i].flagId!, color:
                                                        Color(red: favoriteFlags[i].averageRed/255,
                                                              green: favoriteFlags[i].averageGreen/255,
                                                              blue: favoriteFlags[i].averageBlue/255
                                                             ), minWidth: screenSize.width/2.5, destination: AnyView(FlagView(flag: favoriteFlags[i])))
                                            //												.frame(minWidth: screenSize.width/2, maxWidth: screenSize.width/2)
                                        }
                                    }
                                }
                                .frame(minHeight: screenSize.width/3.5)
                            }
                        } else {
                            VStack {
                                Image(systemName: "star")
                                    .font(.title)
                                    .foregroundColor(.secondary)
                                Text("No Favorites")
                                    .font(.none)
                                    .foregroundColor(.primary)
                                    .lineLimit(1)
                                    .truncationMode(.middle)
                            }
                            .padding()
                            .frame(minWidth: screenSize.width/2.5, maxWidth: .infinity, maxHeight: .infinity)
                            .background(RoundedRectangle(cornerRadius: 20.0, style: .continuous)
                                .fill(Color.secondary)
                                .opacity(0.3)
                            )
                            .frame(minHeight: screenSize.width/3.5)
                            .padding(.horizontal)
                        }
                        HStack {
                            Text("Lists")
                                .font(.title2)
                                .bold()
                                .padding(.leading)
                            Spacer()
                            Button {
                                showingNewListSheet.toggle()
                            } label: {
                                Image(systemName: "plus")
                                    .font(.title2)
                                    .padding(.trailing)
                            }
                        }
                        .padding(.top)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                CardView(name: "All Flags", iconName: "flag", color: .accentColor, minWidth: screenSize.width/2.5, destination: AnyView(FlagsView(title: "All Flags")))
                                    .padding(.leading)
                                ForEach(otherBunches) { bunch in
                                    CardView(name: bunch.bunchName!, iconName: bunch.bunchIconName!, color: getColorColor(colorName: bunch.bunchColorName!), minWidth: screenSize.width/2.5, destination: AnyView(FlagsView(title: bunch.bunchName!)))
                                }
                                //									.padding(.trailing)
                            }
                            .frame(minHeight: screenSize.width/3.5)
                        }
                        Text("Glossary")
                            .font(.title2)
                            .bold()
                            .padding(.leading)
                            .padding(.top)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                CardView(name: "Types", iconName: "checkerboard.rectangle", color: .red, minWidth: screenSize.width/2.5, destination: AnyView(Text("Types")))
                                    .padding(.leading)
                                CardView(name: "Elements", iconName: "paintbrush.pointed", color: .orange, minWidth: screenSize.width/2.5, destination: AnyView(Text("Elements")))
                                CardView(name: "Patterns", iconName: "cross", color: .yellow, minWidth: screenSize.width/2.5, destination: AnyView(Text("Patterns")))
                                CardView(name: "Techniques", iconName: "building.columns", color: .yellow, minWidth: screenSize.width/2.5, destination: AnyView(Text("Techniques")))
                                    .padding(.trailing)
                            }
                            .frame(minHeight: screenSize.width/3.5)
                        }
                        Text("Glossary")
                            .font(.title2)
                            .bold()
                            .padding(.leading)
                            .padding(.top)
                        VStack {
                            HStack {
                                NavigationLink(destination: AboutView()) {
                                    HStack {
                                        Label("Types", systemImage: "checkerboard.rectangle")
                                        Spacer()
                                    }
                                    .padding()
                                    .foregroundColor(Color.accentColor)
                                    .background(Color.accentColor.opacity(0.3))
                                    .cornerRadius(15.0)
                                }
                                HStack {
                                    NavigationLink(destination: AboutView()) {
                                        Label("Elements", systemImage: "paintbrush.pointed")
                                        Spacer()
                                    }
                                }
                                .padding()
                                .foregroundColor(.accentColor)
                                .background(Color.accentColor.opacity(0.3))
                                .cornerRadius(15.0)
                            }
                            HStack {
                                HStack {
                                    NavigationLink(destination: AboutView()) {
                                        Label("Patterns", systemImage: "cross")
                                        Spacer()
                                    }
                                }
                                .padding()
                                .foregroundColor(.accentColor)
                                .background(Color.accentColor.opacity(0.3))
                                .cornerRadius(15.0)
                                HStack {
                                    NavigationLink(destination: AboutView()) {
                                        Label("Techniques", systemImage: "building.columns")
                                        Spacer()
                                    }
                                }
                                .padding()
                                .foregroundColor(.accentColor)
                                .background(Color.accentColor.opacity(0.3))
                                .cornerRadius(15.0)
                            }
                        }
                        .padding(.horizontal)
                        
                        Text("Others")
                            .font(.title2)
                            .bold()
                            .padding(.leading)
                            .padding(.top)
                        HStack {
                            HStack {
                                NavigationLink(destination: AboutView()) {
                                    Label("Options", systemImage: "slider.horizontal.3")
                                    Spacer()
                                }
                            }
                            .padding()
                            .background(Color.accentColor.opacity(0.3))
                            .cornerRadius(15.0)
                            HStack {
                                NavigationLink(destination: AboutView()) {
                                    Label("About", systemImage: "info.circle")
                                    Spacer()
                                }
                            }
                            .padding()
                            .background(Color.accentColor.opacity(0.3))
                            .cornerRadius(15.0)
                        }
                        .padding(.horizontal)
                        
                        //					ScrollView(.horizontal, showsIndicators: false) {
                        //						HStack {
                        //							CardView(name: "Principles", iconName: "checkmark.seal", color: .accentColor, minWidth: screenSize.width/2.5, destination: AnyView(Text("Principles")))
                        //								.padding(.leading)
                        //							CardView(name: "Options", iconName: "slider.horizontal.3", color: .accentColor, minWidth: screenSize.width/2.5, destination: AnyView(Text("Options")))
                        //							CardView(name: "About", iconName: "info.circle", color: .accentColor, minWidth: screenSize.width/2.5, destination: AnyView(AboutView()))
                        //								.padding(.trailing)
                        //
                        //						}
                        //						.frame(minHeight: screenSize.width/3.5)
                        //					}
                        
                        //					Spacer()
                    }
                }
            }
//            .padding(.horizontal)
            .navigationBarTitle(Text("Vexillum"))
            .onAppear(perform: {
                self.favoritesExist = doFavoritesExist()
                self.favoriteFlags = getFavoriteFlags()
                print(favoriteFlags.count)
                self.otherBunches = getOtherBunches()
            })
            .sheet(isPresented: $showingNewListSheet, onDismiss: {
                self.otherBunches = getOtherBunches()
            }) {
                NewListSheetView()
            }
        }
    }
    
    let dictColor: [String: Color] = [
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
        "brown": .brown,
    ]
    
    func getColorColor(colorName: String) -> Color {
        return dictColor[colorName]!
    }
    
    func regetBunches() -> [Bunch] {
        @FetchRequest(
            entity: Bunch.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Bunch.bunchName, ascending: true)
            ]
        ) var newBunches: FetchedResults<Bunch>
        var locOtherBunches: [Bunch] = []
        for bunch in newBunches {
            if (bunch.bunchName != Constants.favoritesString) {
                locOtherBunches.append(bunch)
            }
        }
        return locOtherBunches
    }
    
    func getOtherBunches() -> [Bunch] {
        var locOtherBunches: [Bunch] = []
        for bunch in bunches {
            if (bunch.bunchName != Constants.favoritesString) {
                locOtherBunches.append(bunch)
            }
        }
        return locOtherBunches
    }
    
    func getFavoriteFlags() -> [Flag] {
        for bunch in bunches {
            if (bunch.bunchName == Constants.favoritesString) {
                return bunch.flags!.allObjects as! [Flag]
            }
        }
        
        return []
    }
    
    func doFavoritesExist() -> Bool {
        
        for bunch in bunches {
            if (bunch.bunchName == Constants.favoritesString) {
                return bunch.flags!.allObjects.count > 0
            }
        }
        
        return false
    }
    
    func getFirstIndex() -> Int {
        for i in 0..<flags.count {
            if flags[i].favorite {
                return i
            }
        }
        return 0
    }
    
    func getLastIndex() -> Int {
        for i in (0..<flags.count).reversed() {
            if flags[i].favorite {
                return i
            }
        }
        return flags.count - 1
    }
    
    func saveData() {
        print("Attempting to save data.")
        do {
            if managedObjectContext.hasChanges {
                try managedObjectContext.save()
            }
        } catch {
            fatalError("Issue.")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Dictionary where Value: Equatable {
    func someKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}
