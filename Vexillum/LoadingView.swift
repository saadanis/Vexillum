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
		sortDescriptors: [
			NSSortDescriptor(keyPath: \Flag.countryName, ascending: true),
			NSSortDescriptor(keyPath: \Flag.imageData, ascending: false),
			NSSortDescriptor(keyPath: \Flag.averageRed, ascending: false),
			NSSortDescriptor(keyPath: \Flag.averageGreen, ascending: false),
			NSSortDescriptor(keyPath: \Flag.averageBlue, ascending: false)
		]
	) var flags: FetchedResults<Flag>
	@Binding var dataIsLoaded: Bool
	
	@State private var progressPercent = 0.0
	@State private var flagsImported = [FlagImported]()
	@State private var numberOfFlags = 0
	@State private var flagImage = UIImage(systemName: "rectangle.slash")
	@State private var numberOfFlagsProcessed = 0.0
	@State private var currentMessage = "Intializing"
	@State private var dataExists = false
	
	var body: some View {
		VStack(alignment: .leading) {
			if dataExists {
				Image(systemName: "flag")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(maxWidth: .infinity, maxHeight: 100, alignment: .center)
				Text("By Saad Anis")
					.font(.caption)
					.frame(maxWidth: .infinity, alignment: .center)
					.padding(.top)
			} else {
				if currentMessage == "Intializing" {
					Image(systemName: "square.and.arrow.down")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(maxWidth: .infinity, maxHeight: 70, alignment: .center)
				} else if currentMessage == "Finalizing" {
					Image(systemName: "face.smiling")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(maxWidth: .infinity, maxHeight: 70, alignment: .center)
				} else {
					Image(uiImage: (flagImage ?? UIImage(systemName: "rectangle.slash"))!)
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(maxWidth: .infinity, maxHeight: 70, alignment: .center)
				}
				ProgressView("\(currentMessage)", value: progressPercent, total:100)
					.font(.headline)
					.lineLimit(1)
					.padding(.horizontal)
				VStack(alignment: .leading) {
					Label {
						Text("\(numberOfFlags)")
					} icon: {
						Image(systemName: "square.and.arrow.down")
							.frame(maxWidth: 15, alignment: .center)
					}
					Label {
						Text("\(Int(numberOfFlagsProcessed))")
					} icon: {
						Image(systemName: "hourglass")
							.frame(maxWidth: 15, alignment: .center)
					}
				}
				.font(.caption)
			}
		}
		.padding()
		.onAppear() {
			if(flags.count < 100) {
				loadData()
			} else {
				dataExists = true
				dataIsLoaded = true
			}
		}
	}
	
	func loadData() {
		guard let url = URL(string: "https://flask-vexillum.herokuapp.com/vexillum") else {
			print("Invalid URL")
			return
		}
		
		let request = URLRequest(url: url)
		
		URLSession.shared.dataTask(with: request) { data, response, error in
			if let data = data {
				if let decodedResponse = try? JSONDecoder().decode(Flags.self, from: data) {
					DispatchQueue.main.async {
						flagsImported = decodedResponse.flags
						numberOfFlags = flagsImported.count
						progressPercent = 2.5
						
						// The SVG Part:
						flagsImported.forEach { flag in
							var components = URLComponents(string: "https://flask-vexillum.herokuapp.com/convert")!
							components.queryItems = [
								URLQueryItem(name: "country_name", value: flag.country_name),
								URLQueryItem(name: "image_url", value: flag.image_url)
							]
							let request = URLRequest(url: components.url!)
							
							let task = URLSession.shared.dataTask(with: request) { data, response, error in
								if let data = data {
									processFlagData(flag: flag, data: data)
									return
								} else {
									print("Fetch (for \(flag.country_name)) failed: \(error?.localizedDescription ?? "Unknown error")")
									
									// Retry request.
									URLSession.shared.dataTask(with: request) { data, response, error in
										if let data = data {
											processFlagData(flag: flag, data: data)
											return
										}
									}.resume()
								}
							}
							task.resume()
						}
					}
					return
				}
			}
			print("Fetch (for list) failed: \(error?.localizedDescription ?? "Unknown error")")
			
		}.resume()
	}
	
	func processFlagData(flag: FlagImported, data: Data) {
		currentMessage = "Processing flag of \(flag.country_name)"
		flagImage = UIImage(data: data)
		
		// Create local instance of Flag object.
		let _flag = Flag(context: managedObjectContext)
		_flag.countryName = flag.country_name
		_flag.imageData = flagImage?.pngData()?.base64EncodedString()
		
		numberOfFlagsProcessed += 1.0
		progressPercent = 95 * (numberOfFlagsProcessed / Double(numberOfFlags))
		
		if(Int(numberOfFlagsProcessed) == numberOfFlags) {
			currentMessage = "Finalizing"
			addAverageColors()
			saveData()
		}
	}
	
	func saveData() {
		flagImage = UIImage(systemName: "face.smiling")
		print("Attempting to remove duplicates.")
		removeDuplicates()
		print("Attempting to save data.")
		for flag in flags {
			if flag.imageData == nil {
				fatalError("ImageData is nil for \(flag.countryName ?? "Unknown").")
			}
		}
		do {
			if managedObjectContext.hasChanges {
				try managedObjectContext.save()
			}
		} catch {
			fatalError("Issue.")
		}
		progressPercent = 100
		dataIsLoaded = true
	}
	
	func addAverageColors() {
		
		flags.forEach { flag in
			let uiImage = UIImage(data: Data(base64Encoded: flag.imageData! as String, options: .ignoreUnknownCharacters)!)!
			let averageColor = uiImage.averageColor
			flag.averageRed = Double(averageColor?.rgba.red ?? 0)
			flag.averageGreen = Double(averageColor?.rgba.green ?? 0)
			flag.averageBlue = Double(averageColor?.rgba.blue ?? 0)
			
			print("R: \(flag.averageRed) G: \(flag.averageGreen) B: \(flag.averageBlue) ")
		}
	}
	
	func removeDuplicates() {
		flags.forEach { flag in
			var count = 0
			flags.forEach { _flag in
				if _flag.countryName == flag.countryName {
					count+=1
				}
			}
			if count >= 2 {
				managedObjectContext.delete(flag)
			}
		}
	}
}

struct LoadingView_Previews: PreviewProvider {
	
	static var previews: some View {
		LoadingView(dataIsLoaded: .constant(false))
	}
}
