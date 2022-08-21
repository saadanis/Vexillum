//
//  FlagView.swift
//  Vexillum
//
//  Created by Saad Anis on 12/25/21.
//

import SwiftUI

struct FlagView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    //	@FetchRequest(
    //		entity: Flag.entity(),
    //		sortDescriptors: [
    //			NSSortDescriptor(keyPath: \Flag.countryName, ascending: true),
    //			NSSortDescriptor(keyPath: \Flag.favorite, ascending: false)
    //		]
    //	) var flags: FetchedResults<Flag>
    
    @FetchRequest(
        entity: Bunch.entity(),
        sortDescriptors: []
    ) var bunches: FetchedResults<Bunch>
    
    var flag: Flag
    
    @State var averageColor = Color.primary
    @State var colours = [Colour]()
    @State var continents = [Continent]()
    
    @State var otherBunches: [Bunch] = []
    
    @State private var showingNewListSheetViewSheet = false
    
    @State var aspectRatioWidth = 20.0
    @State var aspectRatioHeight = 10.0
    
    let cornerRadius = 15.0
    
    let pasteboard = UIPasteboard.general
    
    var body: some View {
        List {
            Section {
                HStack {
                    if(flag.countryName! == "Nepal"){
                        Spacer()
                    }
                    Image(flag.flagId!)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: flag.countryName! == "Nepal" ? 200 : .infinity)
                    //                        .padding()
                    if(flag.countryName! == "Nepal"){
                        Spacer()
                    }
                }
                .listRowBackground(averageColor.opacity(0.0))
                .listRowInsets(.init(top: 0,
                                     leading: 0,
                                     bottom: 0,
                                     trailing: 0))
                .contextMenu {
                    Button {
                        pasteboard.image = UIImage(named: flag.flagId!)
                    } label: {
                        Label("Copy Image", systemImage: "rectangle.on.rectangle")
                    }
                    Button {
                        UIImageWriteToSavedPhotosAlbum(UIImage(named: flag.flagId!)!, nil, nil, nil)
                    } label: {
                        Label("Save Image", systemImage: "square.and.arrow.down")
                    }
                }
            }
            if (flag.nickname != nil) {
                Section("Name") {
                    HStack {
                        Label {
                            Text("Nickname")
                        } icon: {
                            Image(systemName: "signature")
                                .foregroundColor(averageColor)
                        }
                        Spacer()
                        Text(String(flag.nickname!))
                    }
                    .contextMenu {
                        Button {
                            pasteboard.string = flag.nickname!
                        } label: {
                            Label("Copy", systemImage: "doc.on.doc")
                        }
                    }

                }
            }
            Section("Location") {
                HStack(alignment: .top) {
                    Label {
                        Text("Country")
                    } icon: {
                        Image(systemName: "pin.fill")
                            .foregroundColor(averageColor)
                    }
                    Spacer()
                    Text(flag.countryName!.capitalized)
                        .multilineTextAlignment(.trailing)
                }
                .padding(.vertical, 6)
                .contextMenu {
                    Button {
                        pasteboard.string = flag.countryName!
                    } label: {
                        Label("Copy", systemImage: "doc.on.doc")
                    }
                }
                HStack(alignment: .top) {
                    Label {
                        Text("Continent")
                    } icon: {
                        Image(systemName: "map.fill")
                            .foregroundColor(averageColor)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 6) {
                        ForEach(continents, id:\.self) { continent in
                            Text(continent.continentName!.capitalized)
                        }
                    }
                }
                .padding(.vertical, 6)
                .contextMenu {
                    Button {
                        var continentString = ""
                        for continent in continents {
                            continentString = continentString + continent.continentName!.capitalized + " "
                        }
                        pasteboard.string = continentString.trimmingCharacters(in: .whitespacesAndNewlines)
                    } label: {
                        Label("Copy", systemImage: "doc.on.doc")
                    }
                }
            }
            Section("Date") {
                HStack {
                    Label {
                        Text("Year of Inception")
                    } icon: {
                        Image(systemName: "calendar")
                            .foregroundColor(averageColor)
                    }
                    Spacer()
                    Text(String(flag.inception))
                }
                .contextMenu {
                    Button {
                        pasteboard.string = String(flag.inception)
                    } label: {
                        Label("Copy", systemImage: "doc.on.doc")
                    }
                }
            }
            Section("Size") {
                HStack {
                    Label {
                        Text("Aspect Ratio")
                    } icon: {
//                        RoundedRectangle(cornerRadius: 2)
//                            .stroke(averageColor, lineWidth: 2)
//                            .frame(width: aspectRatioWidth, height: aspectRatioHeight)
                        Image(systemName: "aspectratio")
                            .foregroundColor(averageColor)
                    }
                    Spacer()
//                    Button(action: {
//                        pasteboard.string = flag.aspectRatio!
//                    }) {
                        Text(flag.aspectRatio!)
//                    }
                }
                .contextMenu {
                    Button {
                        pasteboard.string = flag.aspectRatio!
                    } label: {
                        Label("Copy", systemImage: "doc.on.doc")
                    }
                }
            }
            Section("Colours") {
                ForEach(colours, id: \.self) { colour in
                    HStack {
                        Label {
                            Text(colour.colourName!.capitalized)
                        } icon: {
                            Image(systemName: "square.fill")
                                .foregroundColor(Color(hex: colour.colourHex!))
                        }
                        Spacer()
                        Text("#\(colour.colourHex!)")
                            .font(.body.monospaced())
                    }
                    .contextMenu {
                        Button {
                            pasteboard.string = colour.colourName!
                        } label: {
                            Label("Copy Colour Name", systemImage: "doc.on.doc")
                        }
                        Button {
                            pasteboard.string = colour.colourHex!
                        } label: {
                            Label("Copy Hex Triplet", systemImage: "number")
                        }
                    }
                }
            }
        }
        .navigationTitle(flag.countryName!)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        showingNewListSheetViewSheet.toggle()
                    } label: {
                        Label("Create New List", systemImage: "plus")
                    }
                    ForEach(otherBunches) { bunch in
                        Button {
                            addToBunch(flag: flag, bunch: bunch)
                        } label: {
                            Label(bunch.bunchName!, systemImage: bunch.bunchIconName!)
                        }
                    }
                } label: {
                    Text("Add To List")
                }
                Button {
                    for bunch in bunches {
                        if (bunch.bunchName == Constants.favoritesString) {
                            if isFavorite(flag: flag) {
                                print("unfavoriting")
                                removeFromBunch(flag: flag, bunch: bunch)
                            } else {
                                print("favoriting")
                                addToBunch(flag: flag, bunch: bunch)
                            }
                        }
                    }
                    print()
                    for bunch in bunches {
                        print(bunch.bunchName!)
                        let _flags = bunch.flags!.allObjects
                        for _flag in _flags {
                            print((_flag as AnyObject).countryName)
                        }
                    }
                    saveData()
                } label: {
                    Image(systemName: isFavorite(flag: flag) ? "star.fill" : "star")
                }
            }
        }
        .onAppear {
            
            // Get all other bunches.
            var locOtherBunches: [Bunch] = []
            for bunch in bunches {
                if bunch.bunchName != Constants.favoritesString {
                    locOtherBunches.append(bunch)
                }
            }
            otherBunches = locOtherBunches
            
            if colours.count == 0 {
                for case let colour as Colour in flag.colours! {
                    colours.append(colour)
                }
            }
            //            averageColor = Color(red: flag.averageRed/255, green: flag.averageGreen/255, blue: flag.averageBlue/255)
            
            if continents.count == 0 {
                for case let continent as Continent in flag.continent! {
                    continents.append(continent)
                }
            }
            
            let aspectRatioArray = flag.aspectRatio!.split(separator: ":")
            aspectRatioWidth = Double(aspectRatioArray[1]) ?? 20
            aspectRatioHeight = Double(aspectRatioArray[0]) ?? 10
            
            //            var aspectRatioMultiplier = 15 / aspectRatioHeight
            
            //            aspectRatioWidth = ( aspectRatioWidth * 15 ) / aspectRatioHeight
            //            aspectRatioHeight = 15
            
            aspectRatioHeight = (aspectRatioHeight*20)/aspectRatioWidth
            aspectRatioWidth = 20
            
            //            while (aspectRatioHeight*aspectRatioMultiplier < 15) {
            //                aspectRatioMultiplier = aspectRatioMultiplier + 1
            //            }
            //            aspectRatioHeight = aspectRatioHeight * aspectRatioMultiplier
            //            aspectRatioWidth = aspectRatioWidth * aspectRatioMultiplier
            print(aspectRatioWidth)
            print(aspectRatioHeight)
            
        }
        .sheet(isPresented: $showingNewListSheetViewSheet) {
            NewListSheetView()
        }
    }
    
    func isFavorite(flag: Flag) -> Bool {
        for bunch in bunches {
            if (bunch.bunchName == Constants.favoritesString) {
                let _flags = bunch.flags!.allObjects
                if _flags.contains(where: { $0 as! NSObject == flag }) {
                    return true
                } else {
                    return false
                }
            }
        }
        return false
    }
    
    func addToBunch(flag: Flag, bunch: Bunch) {
        var _flags = bunch.flags!.allObjects
        
        if _flags.contains(where: { $0 as! NSObject == flag }) {
            print("Already in the list.")
        } else {
            _flags.append(flag)
            bunch.flags = NSSet(array: _flags)
            print("Added to the list.")
        }
    }
    
    func removeFromBunch(flag: Flag, bunch: Bunch) {
        var _flags = bunch.flags!.allObjects
        
        if _flags.contains(where: { $0 as! NSObject == flag }) {
            _flags.removeAll { $0 as! NSObject == flag }
            bunch.flags = NSSet(array: _flags)
            print("Removed from the list.")
        } else {
            print("Not in the list.")
        }
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

struct FlagView_Previews: PreviewProvider {
    static var previews: some View {
        FlagView(flag: Flag())
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
