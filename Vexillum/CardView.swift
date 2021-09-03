//
//  CardView.swift
//  Vexillum
//
//  Created by Saad Anis on 7/31/21.
//

import SwiftUI

struct CardView: View {
	let name: String
	let iconName: String?
	let imageData: String?
	let color: Color
	let minWidth: CGFloat?
	let contextMenuItems: [MenuItemInfo]
	let destination: AnyView
	
	var body: some View {
		NavigationLink(destination: destination) {
			VStack {
				if iconName != nil {
					Image(systemName: iconName ?? "xmark.octagon")
						.font(.title)
						.foregroundColor(color)
				}
				if imageData != nil {
					Image(uiImage: UIImage(data: Data(base64Encoded: imageData! as String, options: .ignoreUnknownCharacters)!)!)
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(minHeight: 50, maxHeight: 50)
				}
				Text(name)
					.font(.none)
					.foregroundColor(.primary)
					.lineLimit(1)
					.truncationMode(.middle)
			}
		}
		.padding()
		.frame(minWidth: minWidth, maxWidth: .infinity, maxHeight: .infinity)
		.background(RoundedRectangle(cornerRadius: 20.0, style: .continuous)
						.fill(color)
						.opacity(0.3))
		.contextMenu {
			ForEach(contextMenuItems, id: \.title) { contextMenuItem in
				Button {
					contextMenuItem.action()
				} label: {
					Label {
						Text(contextMenuItem.title)
							.foregroundColor(Color.red)
							.background(Color.blue)
					} icon: {
						Image(systemName: contextMenuItem.systemImageName)
							.foregroundColor(Color.blue)
					}
				}
			}
		}
	}
	
	init(name: String, color: Color, destination: AnyView) {
		self.name = name
		self.iconName = nil
		self.imageData = nil
		self.color = color
		self.minWidth = nil
		self.contextMenuItems = []
		self.destination = destination
	}
	init(name: String, iconName:String, color: Color, destination: AnyView) {
		self.name = name
		self.iconName = iconName
		self.imageData = nil
		self.color = color
		self.minWidth = nil
		self.contextMenuItems = []
		self.destination = destination
	}
	init(name: String, iconName:String, color: Color, minWidth: CGFloat, destination: AnyView) {
		self.name = name
		self.iconName = iconName
		self.imageData = nil
		self.color = color
		self.minWidth = minWidth
		self.contextMenuItems = []
		self.destination = destination
	}
	init(name: String, imageData:String, color: Color, destination: AnyView) {
		self.name = name
		self.iconName = nil
		self.imageData = imageData
		self.color = color
		self.minWidth = nil
		self.contextMenuItems = []
		self.destination = destination
	}
	init(name: String, imageData:String, color: Color, contextMenuItems: [MenuItemInfo], destination: AnyView) {
		self.name = name
		self.iconName = nil
		self.imageData = imageData
		self.color = color
		self.minWidth = nil
		self.contextMenuItems = contextMenuItems
		self.destination = destination
	}
	init(name: String, imageData:String, color: Color, minWidth: CGFloat, contextMenuItems: [MenuItemInfo], destination: AnyView) {
		self.name = name
		self.iconName = nil
		self.imageData = imageData
		self.color = color
		self.minWidth = minWidth
		self.contextMenuItems = contextMenuItems
		self.destination = destination
	}
}

struct MenuItemInfo {
	let title: String
	let systemImageName: String
	let action: () -> Void
	let defaultStyle: Bool
}

extension UIImage {
	var averageColor: UIColor? {
		guard let inputImage = CIImage(image: self) else { return nil }
		let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)
		
		guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
		guard let outputImage = filter.outputImage else { return nil }
		
		var bitmap = [UInt8](repeating: 0, count: 4)
		let context = CIContext(options: [.workingColorSpace: kCFNull])
		context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
		
		return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
	}
}

extension UIColor {
	var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
		var red: CGFloat = 0
		var green: CGFloat = 0
		var blue: CGFloat = 0
		var alpha: CGFloat = 0
		getRed(&red, green: &green, blue: &blue, alpha: &alpha)
		
		return (red, green, blue, alpha)
	}
}

struct CardView_Previews: PreviewProvider {
	static var previews: some View {
		CardView(name: "Preview", color: .orange, destination: AnyView(Text("Preview")))
	}
}
