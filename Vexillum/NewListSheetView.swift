//
//  NewListSheetView.swift
//  Vexillum
//
//  Created by Saad Anis on 22/07/2022.
//

import SwiftUI

struct NewListSheetView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var localTitle: String = ""
    
    private var title: String {
        localTitle.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    let columns = [
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0)
    ]
    
    let items = [
        // Basic
        "flag.fill", "heart.fill", "hand.thumbsup.fill", "hand.thumbsdown.fill", "flame.fill",
        // Shapes
        "circle.fill", "square.fill", "triangle.fill", "seal.fill", "shield.fill",
        "rectangle.fill", "oval.fill", "cross.fill", "diamond.fill", "pentagon.fill",
        // Travel
        "pin.fill", "location.fill", "map.fill", "bookmark.fill", "suitcase.fill",
        "airplane", "globe.americas.fill", "globe.europe.africa.fill", "globe.asia.australia.fill", "binoculars.fill",
        // Nature
        "leaf.fill", "drop.fill", "bolt.fill", "pawprint.fill", "cloud.fill",
        "sun.max.fill", "moon.fill", "moon.stars.fill", "wind", "snowflake",
        // People
        "house.fill", "person.fill", "person.2.fill", "person.3.fill", "face.smiling.fill",
        "eyes", "mustache.fill", "mouth.fill", "hand.raised.fill", "hands.clap.fill",
        // Formatting
        "paintbrush.pointed.fill","paintpalette.fill", "scissors", "paintbrush.fill", "eyedropper.halffull",
        "signature", "textformat", "scribble.variable", "rectangle.dashed", "aspectratio.fill",
        // Miscellaneous
        "fork.knife", "cup.and.saucer.fill", "takeoutbag.and.cup.and.straw.fill", "shippingbox.fill", "gift.fill",
        "dice.fill", "crown.fill", "guitars.fill", "tortoise.fill", "hare.fill"
    ]
    
    let colors = [
        Color.red, Color.orange, Color.yellow, Color.green,
        Color.mint, Color.teal, Color.cyan, Color.blue, Color.indigo,
        Color.purple
    ]
    
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
        "brown": .brown
    ]
    
    func getColorColor(colorName: String) -> Color {
        return dictColor[colorName]!
    }
    
    func getColorName(colorColor: Color) -> String {
        return dictColor.someKey(forValue: colorColor)!
    }
    
    @State private var selectedItem: String = ""
    @State private var selectedColor: Color = Color.accentColor
    
    var body2: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                HStack {
                    Spacer()
                    VStack {
                        Image(systemName: selectedItem)
                            .font(.title)
                            .padding(.bottom, 5)
                            .frame(minHeight: 35, maxHeight: 35)
                        Text(title == "" ? "Untitled" : title)
                            .font(.headline)
                    }
                    .foregroundColor(selectedColor)
                    Spacer()
                }
                .padding(20)
                .background(selectedColor.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                VStack {
                    TextField("Title", text:  $localTitle)
                        .padding(10)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(colors, id:\.self) { color in
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height: 40)
                                .foregroundColor(color)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(selectedColor == color ? .primary : Color.gray.opacity(0.1))
                                )
                        }
                        .padding(5)
                        .onTapGesture {
                            selectedColor = color
                        }
                    }
                }
                .padding(10)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(items, id:\.self) { item in
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height: 40)
                                .foregroundColor(selectedItem == item ? selectedColor.opacity(0.1) : Color.gray.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(selectedItem == item ? .primary : Color.gray.opacity(0.1))
                                )
                            Image(systemName: item)
                                .foregroundColor(selectedColor)
                        }
                        .padding(5)
                        .onTapGesture {
                            selectedItem = item
                        }
                    }
                }
                .padding(10)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(.horizontal)
            .navigationTitle("New List")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(selectedColor)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Create") {
                        if createNewList() {
                            dismiss()
                        } else {
                            
                        }
                    }
                    .foregroundColor(selectedColor)
                }
            }
            .onAppear {
                print(Array(dictColor.values))
                selectedItem = items[0]
                selectedColor = colors[0]
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                HStack {
                    Spacer()
                    VStack(alignment: .center) {
                        Image(systemName: selectedItem)
                            .font(.title)
                            .padding(.bottom, 5)
                            .frame(minHeight: 38, maxHeight: 38)
                        Text(title == "" ? "Untitled" : title)
                            .font(.headline)
                    }
                    .foregroundColor(selectedColor)
                    .padding()
                    Spacer()
                }
                .listRowBackground(selectedColor.opacity(0.2))
                
                Section {
                    TextField("List Name", text: $localTitle)
                        .disableAutocorrection(true)
                        .autocapitalization(.words)
                }

                Section {
                    LazyVGrid(columns: columns, spacing: 0) {
                        ForEach(colors, id:\.self) { color in
                            RoundedRectangle(cornerRadius: 8)
                                .frame(height: 40)
                                .foregroundColor(color)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(selectedColor == color ? .primary : Color.gray.opacity(0.0), lineWidth: 2)
                                )
                                .onTapGesture(perform: {
                                    selectedColor = color
                                })
                                .padding(5)
                        }
                    }
                    .listRowInsets(.init(top: 5, leading: 5, bottom: 5, trailing: 5))
                }

                Section {
                    LazyVGrid(columns: columns, spacing: 0) {
                        ForEach(items, id:\.self) { item in
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .frame(height: 40)
                                    .foregroundColor(selectedItem == item ? selectedColor.opacity(0.2) : Color.gray.opacity(0.2))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(selectedItem == item ? selectedColor : Color.gray.opacity(0.0), lineWidth: 2)
                                    )
                                Image(systemName: item)
                                    .foregroundColor(selectedItem == item ? selectedColor : Color.primary)
                            }
                            .onTapGesture {
                                selectedItem = item
                            }
                            .padding(5)
                        }
                    }
                    .listRowInsets(.init(top: 5, leading: 5, bottom: 5, trailing: 5))
                }
            }
            .navigationTitle("New List")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if createNewList() {
                            dismiss()
                        } else {
//                            TODO: Show an error for failure.
                        }
                    } label: {
                        Text("Create")
                            .bold()
                    }
                    .disabled(title == "")
                }
            }
            .onAppear {
                selectedItem = items[0]
                selectedColor = colors[0]
            }
        }
    }
    
    func createNewList() -> Bool {
        
        let trimmedTitle = title
        
        if trimmedTitle.count > 0 {
            if trimmedTitle != Constants.favoritesString || trimmedTitle != "All Flags" {
                let newBunch = Bunch(context: managedObjectContext)
                newBunch.bunchName = trimmedTitle
                newBunch.bunchIconName = selectedItem
                newBunch.bunchColorName = getColorName(colorColor: selectedColor)
                return true
            }
        }
        print(title)
        print(selectedItem)
        print(selectedColor)
        return false
    }
}


struct NewListSheetView_Previews: PreviewProvider {
    static var previews: some View {
        NewListSheetView()
    }
}
