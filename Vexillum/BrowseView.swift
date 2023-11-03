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
    @State private var showAlert = false
    @State private var showingEditListSheet = false
    @State private var showingFilterOptionsSheet = false
    
    var bunch: Bunch?
    
    @State private var selectedSortIndex = 0
    @State private var isReverse = false
    
    @State private var selectedContinents = Constants.continents
    
    @State private var fromYear = 0000
    @State private var toYear = Calendar.current.component(.year, from: Date())
    
    @State private var selectedAspectRatios = Constants.aspectRatios
    
    var ascendingText: String {
        switch selectedSortIndex {
        case 1:
            return "Oldest First"
        case 2:
            return "Shortest First"
        case 3:
            return "Least First"
        default:
            return "Ascending"
        }
    }
    var descendingText: String {
        switch selectedSortIndex {
        case 1:
            return "Newest First"
        case 2:
            return "Longest First"
        case 3:
            return "Most First"
        default:
            return "Descending"
        }
    }
    
    var searchResults: Array<Flag> {
        
        var localFlags: [Flag] = []
        
        if bunch != nil {
            localFlags = bunch!.flags!.allObjects as! [Flag]
        } else {
            localFlags = flags.filter { $0 == $0 }
        }
        
        localFlags = localFlags.filter {
            for continent in $0.continent! {
                if selectedContinents.contains((continent as AnyObject).continentName!) {
                    return true
                }
            }
            return false
        }
        
        localFlags = localFlags.filter {
            $0.inception >= fromYear && $0.inception <= toYear
        }
        
        localFlags = localFlags.filter {
            selectedAspectRatios.contains($0.aspectRatio!)
        }
        
        if !searchText.isEmpty {
            localFlags = localFlags.filter {
                $0.countryName!.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        switch selectedSortIndex {
        case 1:
            localFlags = localFlags.sorted(by: { $0.inception < $1.inception })
        case 2:
            localFlags = localFlags.sorted(by: {
                let zero = $0.aspectRatio!.components(separatedBy: ":").map{Double($0)}
                let zero_ratio = zero[1]!/zero[0]!
                let one = $1.aspectRatio!.components(separatedBy: ":").map{Double($0)}
                let one_ratio = one[1]!/one[0]!
                
                return zero_ratio < one_ratio
            })
        case 3:
            localFlags = localFlags.sorted(by: { $0.colours!.count < $1.colours!.count })
        default:
            localFlags = localFlags.sorted(by: { $0.countryName! < $1.countryName! })
        }
        
        if isReverse {
            localFlags = localFlags.reversed()
        }
        
        return localFlags
    }
    
    var title: String {
        if let bunch = bunch {
            return bunch.bunchName!
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
        var destination: any View
        
        var body: some View {
            NavigationLink(destination: AnyView(destination)) {
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
        ScrollView {
            LazyVGrid(columns: layout) {
                ForEach(searchResults, id: \.self) { flag in
                    CellContent(
                        flagId: flag.flagId!,
                        countryName: flag.countryName!,
                        color: Color(
                            red: flag.averageRed/255,
                            green: flag.averageGreen/255,
                            blue: flag.averageBlue/255
                        ),
                        destination: FlagView(flag: flag)
                    )
                    .contextMenu {
                        if bunch != nil {
                            Button(role: .destructive) {
                                removeFromBunch(flag: flag)
                                PersistenceController.shared.save()
                            } label: {
                                Label("Remove From List", systemImage: "text.badge.minus")
                            }
                        }
                    }
                }
                .id(UUID())
            }
            .searchable(text: $searchText)
            .disableAutocorrection(true)
            .textInputAutocapitalization(.never)
            .padding(.horizontal)
        }
        .navigationTitle(title)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    showingFilterOptionsSheet.toggle()
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                }
                Menu {
                    Picker(selection: $selectedSortIndex) {
                        Text("Country").tag(0)
                        Text("Year of Inception").tag(1)
                        Text("Aspect Ratio").tag(2)
                        Text("Number of Colors").tag(3)
                    } label: {
                        Text("Sorting Option")
                    }
                    Picker(selection: $isReverse) {
                        Text(ascendingText).tag(false)
                        Text(descendingText).tag(true)
                    } label: {
                        Text("Sorting Option")
                    }
                } label: {
                    Image(systemName: "arrow.up.arrow.down.circle")
                }
                if bunch != nil {
                    Menu {
                        Button {
                            showingEditListSheet.toggle()
                        } label: {
                            Label("Edit List Info", systemImage: "pencil")
                        }
                        Button (role: .destructive) {
                            self.showAlert = true
                        } label: {
                            Label("Delete List", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Delete list \"\(bunch!.bunchName!)\"?"),
                primaryButton: .destructive(Text("Delete")) {
                    let _bunch = bunches.filter{ $0.bunchName == bunch!.bunchName! }[0]
                    managedObjectContext.delete(_bunch)
                },
                secondaryButton: .cancel()
            )
        }
        .sheet(isPresented: $showingEditListSheet) {
            NewListSheetView(editBunch: bunch)
        }
        .sheet(isPresented: $showingFilterOptionsSheet) {
            FilterOptionsSheetView(
                selectedContinents: $selectedContinents,
                fromYear: $fromYear,
                toYear: $toYear,
                selectedAspectRatios: $selectedAspectRatios
            )
        }
    }
    
    func removeFromBunch(flag: Flag) {
        
        var _flags = bunch!.flags!.allObjects
        
        if _flags.contains(where: { $0 as! NSObject == flag }) {
            _flags.removeAll { $0 as! NSObject == flag }
            bunches.filter{ $0.bunchName == bunch!.bunchName! }[0].flags = NSSet(array: _flags)
            print("Removed from the list.")
        } else {
            print("Not in the list.")
        }
    }
}

struct BrowseView_Previews: PreviewProvider {
    static var previews: some View {
        BrowseView()
    }
}
