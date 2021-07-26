//
//  FlagsView.swift
//  Vexillum
//
//  Created by Saad Anis on 7/26/21.
//

import SwiftUI

struct FlagsView: View {
	
	let countryCodes = ["ca","np"]
	
    var body: some View {
		List {
//			Label {
//				Text("Flag")
//			} icon: {
//				Image("ca")
//					.resizable()
//			}
			ForEach(countryCodes, id: \.self) { code in
				HStack {
					Image(code)
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(maxWidth: 70, maxHeight: 27.5, alignment: .center)
					Text(code)
				}
			}
		}
			.navigationBarTitle(Text("Flags"))
    }
}

struct FlagsView_Previews: PreviewProvider {
    static var previews: some View {
        FlagsView()
    }
}
