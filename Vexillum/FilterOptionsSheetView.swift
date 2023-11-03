//
//  FilterOptionsSheetView.swift
//  Vexillum
//
//  Created by Saad Anis on 28/08/2022.
//

import SwiftUI
import Combine

struct FilterOptionsSheetView: View {
    @Environment(\.dismiss) var dismiss
    
    let columns = [
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0)
    ]
    
    let continents = Constants.continents
    @Binding var selectedContinents: [String]
    @State var localSelectedContinents: [String] = []
    
    @Binding var fromYear: Int
    @Binding var toYear: Int
    @State var localFromYear = ""
    @State var localToYear = ""
    
    let aspectRatios = Constants.aspectRatios
    @Binding var selectedAspectRatios: [String]
    @State var localSelectedAspectRatios: [String] = []
    
    var body: some View {
        NavigationView {
            Form {
                //                Section("Continents") {
                //                    ScrollView(.horizontal, showsIndicators: false) {
                //                        HStack {
                //                            ForEach(0..<continents.count, id:\.self) { i in
                //                                Button {
                //                                    if localSelectedContinents.contains(continents[i]) {
                //                                        localSelectedContinents.remove(
                //                                            at: localSelectedContinents.firstIndex(of: continents[i])!
                //                                        )
                //                                    } else {
                //                                        localSelectedContinents.append(continents[i])
                //                                    }
                //                                } label: {
                //                                    Text(continents[i])
                //                                        .foregroundColor(.primary)
                //                                        .padding(.horizontal, 12)
                //                                        .padding(.vertical, 6)
                //                                        .background(
                //                                            localSelectedContinents.contains(continents[i])
                //                                            ? Color.accentColor
                //                                            : Color.secondary.opacity(0.2)
                //                                        )
                //                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                //                                }
                //                            }
                //                        }
                //                        .padding(.horizontal)
                //                    }
                //                    .listRowInsets(EdgeInsets())
                //                }
                //                Section("Continents") {
                //                    ForEach(0..<continents.count, id:\.self) { i in
                //                        Button {
                //                            if localSelectedContinents.contains(continents[i]) {
                //                                localSelectedContinents.remove(
                //                                    at: localSelectedContinents.firstIndex(of: continents[i])!
                //                                )
                //                            } else {
                //                                localSelectedContinents.append(continents[i])
                //                            }
                //                        } label: {
                //                            HStack {
                //                                Text(continents[i])
                //                                    .foregroundColor(.primary)
                //                                Spacer()
                //                                Image(systemName: localSelectedContinents.contains(continents[i]) ? "checkmark" : "")
                //                                    .font(.headline)
                //                            }
                //                        }
                //                    }
                //                }
                Section("Continents") {
                    TagCloudView(tags: continents, selectedTags: $localSelectedContinents)
                }
                Section("Year of Inception") {
                    HStack {
                        Text("From")
                        TextField(
                            String("0000"),
                            text: $localFromYear)
                        .onReceive(Just(localFromYear)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.localFromYear = filtered
                            }
                        }
                        .font(.body.monospacedDigit())
                        .fixedSize()
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            Int(localFromYear) ?? 0 > 0
                            ? Color.accentColor
                            : Color.gray.opacity(0.2)
                        )
                        .foregroundColor(Color.primary)
                        .cornerRadius(5)
                        .onReceive(Just(localFromYear)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.localFromYear = filtered
                            }
                            if localFromYear.count > 4 {
                                localFromYear = String(localFromYear.prefix(4))
                            }
                        }
                        Text("to")
                        TextField(
                            String(Calendar.current.component(.year, from: Date())),
                            text: $localToYear)
                        .font(.body.monospacedDigit())
                        .fixedSize()
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            Int(localToYear) ?? Calendar.current.component(.year, from: Date()) != Calendar.current.component(.year, from: Date())
                            ? Color.accentColor
                            : Color.gray.opacity(0.2)
                        )
                        .foregroundColor(Color.primary)
                        .cornerRadius(5)
                        .onReceive(Just(localToYear)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.localToYear = filtered
                            }
                            if localToYear.count > 4 {
                                localToYear = String(localToYear.prefix(4))
                            }
                        }
                    }
                }
                //                Section("Year of Inception") {
                //                    HStack {
                //                        Text("From")
                //                        Spacer()
                //                        TextField(
                //                            String("0000"),
                //                            text: $localFromYear)
                //                        .onReceive(Just(localFromYear)) { newValue in
                //                            let filtered = newValue.filter { "0123456789".contains($0) }
                //                            if filtered != newValue {
                //                                self.localFromYear = filtered
                //                            }
                //                        }
                //                        .font(.body.monospacedDigit())
                //                        .fixedSize()
                //                    }
                //                    HStack {
                //                        Text("To")
                //                        Spacer()
                //                        TextField(
                //                            String(Calendar.current.component(.year, from: Date())),
                //                            text: $localToYear)
                //                        .onReceive(Just(localToYear)) { newValue in
                //                            let filtered = newValue.filter { "0123456789".contains($0) }
                //                            if filtered != newValue {
                //                                self.localToYear = filtered
                //                            }
                //                        }
                //                        .font(.body.monospacedDigit())
                //                        .fixedSize()
                //                    }
                //                }
                Section("Aspect Ratio") {
                    TagCloudView(tags: aspectRatios, selectedTags: $localSelectedAspectRatios)
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
                        selectedContinents = localSelectedContinents
                        
                        fromYear = Int(localFromYear) ?? 0000
                        toYear = Int(localToYear) ?? Calendar.current.component(.year, from: Date())
                        
                        selectedAspectRatios = localSelectedAspectRatios
                        
                        dismiss()
                    }
                    .disabled(
                        !filtrationIsValid()
                    )
                }
            }
            .onAppear {
                localSelectedContinents = selectedContinents
                
                localFromYear = String(format: "%04d", fromYear)
                localToYear = String(format: "%04d", toYear)
                
                localSelectedAspectRatios = selectedAspectRatios
            }
        }
    }
    
    func filtrationIsValid() -> Bool {
        return localSelectedContinents.count > 0 &&
        Int(localFromYear) ?? 0000 < Int(localToYear) ?? Calendar.current.component(.year, from: Date()) &&
        localSelectedAspectRatios.count > 0
    }
    
    struct TagCloudView: View {
        var tags: [String]
        @Binding var selectedTags: [String]
        
        @State private var totalHeight
        = CGFloat.zero       // << variant for ScrollView/List
        //            = CGFloat.infinity   // << variant for VStack
        
        var body: some View {
            VStack {
                GeometryReader { geometry in
                    self.generateContent(in: geometry)
                }
            }
            .frame(height: totalHeight)// << variant for ScrollView/List
            //            .frame(maxHeight: totalHeight) // << variant for VStack
        }
        
        private func generateContent(in g: GeometryProxy) -> some View {
            var width = CGFloat.zero
            var height = CGFloat.zero
            
            return ZStack(alignment: .topLeading) {
                ForEach(self.tags, id: \.self) { tag in
                    self.item(for: tag)
                        .padding([.horizontal, .vertical], 4)
                        .alignmentGuide(.leading, computeValue: { d in
                            if (abs(width - d.width) > g.size.width)
                            {
                                width = 0
                                height -= d.height
                            }
                            let result = width
                            if tag == self.tags.last! {
                                width = 0 //last item
                            } else {
                                width -= d.width
                            }
                            return result
                        })
                        .alignmentGuide(.top, computeValue: {d in
                            let result = height
                            if tag == self.tags.last! {
                                height = 0 // last item
                            }
                            return result
                        })
                }
            }.background(viewHeightReader($totalHeight))
        }
        
        private func item(for text: String) -> some View {
            Button {
                if selectedTags.contains(text) {
                    selectedTags.remove(at: selectedTags.firstIndex(of: text)!)
                } else {
                    selectedTags.append(text)
                }
            } label: {
                Text(text)
                //                    .padding(.all, 5)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .font(.body)
                    .background(
                        selectedTags.contains(text)
                        ? Color.accentColor
                        : Color.gray.opacity(0.2)
                    )
                    .foregroundColor(Color.primary)
                    .cornerRadius(5)
            }
            .buttonStyle(.borderless)
        }
        
        private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
            return GeometryReader { geometry -> Color in
                let rect = geometry.frame(in: .local)
                DispatchQueue.main.async {
                    binding.wrappedValue = rect.size.height
                }
                return .clear
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

