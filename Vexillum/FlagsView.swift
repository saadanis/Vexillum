//
//  FlagsView.swift
//  Vexillum
//
//  Created by Saad Anis on 7/26/21.
//

import SwiftUI

struct FlagsView: View {
	
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
	
	var title: String
	
	@State var localFlags: [Flag] = []
	
	@State private var searchText = ""
	
	@State private var showingDeleteListAlert = false
	
	let columns = [
		GridItem(.flexible()),
		GridItem(.flexible())
	]
	
	var body: some View {
		ScrollView(.vertical) {
			LazyVGrid(columns: columns, spacing: 12) {
				ForEach(searchResults, id: \.self) { flag in
					FlagCardView(flag: flag)
				}
			}
			.padding(.horizontal)
		}
		.searchable(text: $searchText)
		.navigationTitle(title)
		.disableAutocorrection(true)
		.textInputAutocapitalization(.never)
		.toolbar {
			ToolbarItemGroup(placement: .navigationBarTrailing) {
//				Button {
//
//				}  label: {
//					Image(systemName: "arrow.up.arrow.down.circle")
//				}
//				Button {
//
//				}  label: {
//					Image(systemName: "line.3.horizontal.decrease.circle")
//				}
				if title != "All Flags" {
					Menu {
						Button(role: .destructive) {
							deleteBunch()
							showingDeleteListAlert = true
						} label: {
							Label("Delete List", systemImage: "trash")
						}
					} label: {
						Image(systemName: "ellipsis.circle")
					}
				}
			}
		}
		.onAppear {
			if title != "All Flags" {
				for bunch in bunches {
					if bunch.bunchName == title {
						localFlags = bunch.flags!.allObjects as! [Flag]
					}
				}
			} else {
				localFlags = flags.filter {
					$0.countryName == $0.countryName
				}
			}
		}
		.alert("Delete list \"\(title)\"?", isPresented: $showingDeleteListAlert) {
			Button("Delete", role: .destructive) {
				
				self.presentationMode.wrappedValue.dismiss()
			}
			Button("Cancel", role: .cancel) { }
		} message: {
			Text("This will delete the list permanently.")
		}
	}
	
	func deleteBunch() {
		for bunch in bunches {
			if bunch.bunchName == title {
				managedObjectContext.delete(bunch)
				break
			}
		}
	}
	
	var searchResults: Array<Flag> {
		
		if searchText.isEmpty {
			return localFlags.filter {
				$0.countryName != nil
			}
		} else {
			return localFlags.filter {
				$0.countryName!.localizedCaseInsensitiveContains(searchText)
			}
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

struct FlagCardView: View {
	
	@Environment(\.managedObjectContext) var managedObjectContext
	
	let flag: Flag
	
	let screenSize: CGRect = UIScreen.main.bounds
	
	var body: some View {
		CardView(name: flag.countryName!, imageName: flag.flagId!, color: Color(red: flag.averageRed/255, green:flag.averageGreen/255, blue: flag.averageBlue/255), destination: AnyView(FlagView(flag: flag)))
			.frame(minHeight: screenSize.width/3, maxHeight: screenSize.width/3)
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

struct FlagsView_Previews: PreviewProvider {
	static var previews: some View {
//		FlagsView(flags: FetchedResults<Flag>, title: "All Flags")
		Text("")
	}
}
