//
//  FilterOptionsSheetView.swift
//  Vexillum
//
//  Created by Saad Anis on 28/08/2022.
//

import SwiftUI

struct FilterOptionsSheetView: View {
    @Environment(\.dismiss) var dismiss
    
    let columns = [
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0)
    ]
    
    let continents = [
        "Asia",
        "Europe",
        "Africa",
        "North America",
        "South America",
        "Oceania"
    ]
    
    @Binding var selectedContinents: [String]
    
    @Binding var isFiltered: Bool
    
    private let filterOptionTypes = [
        "Country Name",
        "Continent",
        "Year of Inception",
        "Aspect Ratio",
        "Colours"
    ]
    
    @State private var selectedContinent = 1
    
    var body: some View {
        NavigationView {
            Form {
                HStack {
                    Text("Continent")
                    Spacer()
                    Picker(selection: $selectedContinent) {
                        Text("Any").tag(0)
                        Text("Specific").tag(1)
                    } label: {
                        Label("Continent", systemImage: "map.fill")
                    }
                    .pickerStyle(.menu)
                }
                
                if selectedContinent == 1 {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(0..<continents.count, id:\.self) { i in
                                Button {
                                    if selectedContinents.contains(continents[i]) {
                                        selectedContinents.remove(
                                            at: selectedContinents.firstIndex(of: continents[i])!
                                        )
                                    } else {
                                        selectedContinents.append(continents[i])
                                    }
                                } label: {
                                    Text(continents[i])
                                        .foregroundColor(.primary)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(
                                            selectedContinents.contains(continents[i])
                                            ? Color.accentColor
                                            : Color.secondary.opacity(0.2)
                                        )
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                                .padding(.leading, i == 0 ? nil : 0)
                                .padding(.trailing, i == continents.count - 1 ? nil : 0)
                                .padding(.vertical, nil)
                            }
                        }
                    }
                    .listRowInsets(EdgeInsets())
                }
            }
            .navigationTitle("Filter Options")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
//                        isFiltered.toggle()
                        dismiss()
                    }
                }
            }
        }
    }
}

//struct FilterOptionsSheetView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        FilterOptionsSheetView(isFiltered: $isFiltered)
//    }
//}

