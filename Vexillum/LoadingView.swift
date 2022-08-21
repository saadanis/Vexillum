//
//  LoadingView.swift
//  Vexillum
//
//  Created by Saad Anis on 7/28/21.
//

import SwiftUI
import Foundation

struct LoadingView: View {
	
	@Environment(\.managedObjectContext) var managedObjectContext
	
	@FetchRequest(
		entity: Flag.entity(),
		sortDescriptors: []
	) var flags: FetchedResults<Flag>
	
	@FetchRequest(
		entity: Colour.entity(),
		sortDescriptors: []
	) var colours: FetchedResults<Colour>
	
	@FetchRequest(
		entity: Continent.entity(),
		sortDescriptors: []
	) var continents: FetchedResults<Continent>
	
	@FetchRequest(entity: Bunch.entity(),
				  sortDescriptors: []
	) var bunches: FetchedResults<Bunch>
	
	
	@Binding var dataIsLoaded: Bool
	
	var body: some View {
		VStack {
//			Image("Vexillum_SC")
//				.resizable()
//				.frame(width: 80, height: 80)
//				.cornerRadius(20)
            Text("Loading View")
		}
		.padding()
		.onAppear() {
			
			// Load the JSON files.
			let flagsJSON = loadJSON()
			let coloursJSON = loadJSONColours()
			let continentsJSON = loadJSONContinents()
			
			// Temporary delete alls.
			for flag in flags {
				managedObjectContext.delete(flag)
			}
			for colour in colours {
				managedObjectContext.delete(colour)
			}
			for continent in continents {
				managedObjectContext.delete(continent)
			}
			for bunch in bunches {
				managedObjectContext.delete(bunch)
			}
			saveData()
			
			// Add the JSON continents to CoreData if there are more JSON continents.
			if (continentsJSON.count > continents.count) {
				for continentJSON in continentsJSON {
					if(continents.filter{ $0.continentName == continentJSON }.isEmpty) {
						let continent = Continent(context: managedObjectContext)
						continent.continentName = continentJSON
					}
				}
			}
			saveData()
			
			// Add the JSON colours to CoreData if there are more JSON colours.
			if (coloursJSON.count > colours.count) {
				for colourJSON in coloursJSON {
					if(colours.filter{ $0.colourHex == colourJSON.colour_hex }.isEmpty) {
						let colour = Colour(context: managedObjectContext)
                        colour.colourHex = colourJSON.colour_hex
                        colour.colourName = colourJSON.colour_name
					}
				}
			}
			saveData()
			
			// Add the JSON flags to CoreData if there are more JSON flags.
			if (flagsJSON.count > flags.count) {
				for flagJSON in flagsJSON {
					if(flags.filter{$0.countryName == flagJSON.country_name}.isEmpty) {
						let flag = Flag(context: managedObjectContext)
						flag.countryName = flagJSON.country_name
						flag.flagId = flagJSON.flag_id
						flag.countryId = flagJSON.country_id
						flag.inception = Int32(flagJSON.inception)
						flag.imageUrl = flagJSON.image_url
						flag.nickname = flagJSON.nickname
						flag.averageRed = Double(flagJSON.average_red)
						flag.averageGreen = Double(flagJSON.average_green)
						flag.averageBlue = Double(flagJSON.average_blue)
						flag.favorite = false
                        flag.aspectRatio = flagJSON.aspect_ratio
						
						var _colours = [Colour]()
						for colourHex in flagJSON.colours {
							_colours.append(colours.first(where: {$0.colourHex! == colourHex})!)
						}
						flag.colours = NSSet(array: _colours)
                        
						var _continents = [Continent]()
						for continentName in flagJSON.continent {
							_continents.append(continents.first(where: {$0.continentName! == continentName})!)
						}
						flag.continent = NSSet(array: _continents)
					}
				}
			}
			
            if(bunches.filter{$0.bunchName == Constants.favoritesString}.isEmpty) {
				print("Favorites list does not exist; Creating.")
				let bunch = Bunch(context: managedObjectContext)
                bunch.bunchName = Constants.favoritesString
				bunch.bunchIconName = "star"
				bunch.bunchColorName = "red"
			}
			
			// Temporary: Create a new bunch.
			if(bunches.filter{$0.bunchName == "My Top Four"}.isEmpty) {
				let bunch = Bunch(context: managedObjectContext)
				bunch.bunchName = "My Top Four"
				bunch.bunchIconName = "hand.thumbsup.fill"
				bunch.bunchColorName = "green"
                bunch.bunchOrder = 0
			}
            if(bunches.filter{$0.bunchName == "My Bottom Four"}.isEmpty) {
                let bunch = Bunch(context: managedObjectContext)
                bunch.bunchName = "My Bottom Four"
                bunch.bunchIconName = "hand.thumbsdown.fill"
                bunch.bunchColorName = "red"
                bunch.bunchOrder = 1
            }
			
			// Save the newly updated data (in CoreData).
			saveData()
			
			for flag in flags {
				print()
				print(flag.countryName)
				print(flag.flagId)
				print(flag.countryId)
				print(flag.inception)
				print(flag.imageUrl)
				print(flag.nickname)
				for case let colour as Colour in flag.colours! {
					print(colour.colourHex)
				}
				for case let continent as Continent in flag.continent! {
					print(continent.continentName)
				}
				print(flag.averageRed)
				print(flag.averageGreen)
				print(flag.averageBlue)
			}
			
			for bunch in bunches {
				print()
				print(bunch.bunchName)
				print(bunch.bunchIconName)
                for case let _flag as Flag in bunch.flags! {
                    print(_flag.countryName)
                }
			}
			
			dataIsLoaded = true
		}
	}
	
	func loadJSON() -> [FlagJSON] {
		
		let flagsJSON: [FlagJSON] = load("flags.json")
		
		func load<T: Decodable>(_ filename: String) -> T {
			let data: Data
			
			guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
			else {
				fatalError("Couldn't find \(filename) in main bundle.")
			}
			
			do {
				data = try Data(contentsOf: file)
			} catch {
				fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
			}
			
			do {
				let decoder = JSONDecoder()
				return try decoder.decode(T.self, from: data)
			} catch {
				fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
			}
		}
		
		return flagsJSON
	}
	
	func loadJSONColours() -> [ColourJSON] {
		
		let coloursJSON: [ColourJSON] = load("colours.json")
		
		func load<T: Decodable>(_ filename: String) -> T {
			let data: Data
			
			guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
			else {
				fatalError("Couldn't find \(filename) in main bundle.")
			}
			
			do {
				data = try Data(contentsOf: file)
			} catch {
				fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
			}
			
			do {
				let decoder = JSONDecoder()
				return try decoder.decode(T.self, from: data)
			} catch {
				fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
			}
		}
		
		return coloursJSON
	}
	
	func loadJSONContinents() -> [String] {
		let continentsJSON: [String] = load("continents.json")
		
		func load<T: Decodable>(_ filename: String) -> T {
			let data: Data
			
			guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
			else {
				fatalError("Couldn't find \(filename) in main bundle.")
			}
			
			do {
				data = try Data(contentsOf: file)
			} catch {
				fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
			}
			
			do {
				let decoder = JSONDecoder()
				return try decoder.decode(T.self, from: data)
			} catch {
				fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
			}
		}
		
		return continentsJSON
	}
	
	func saveData() {
		do {
			if managedObjectContext.hasChanges {
				print("There are changes; Saving data.")
				try managedObjectContext.save()
			}
		} catch {
			fatalError("Issue in saving data.")
		}
	}
	
}

struct LoadingView_Previews: PreviewProvider {
	
	static var previews: some View {
        LoadingView(dataIsLoaded: .constant(false))
	}
}
