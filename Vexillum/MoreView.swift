//
//  MoreView.swift
//  Vexillum
//
//  Created by Saad Anis on 09/07/2022.
//

import SwiftUI

struct MoreView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: AboutView()) {
                    Label {
                        Text("About")
                    } icon: {
                        Image(systemName: "info.circle")
                            .foregroundColor(.accentColor)
                    }
                }
            }
            .navigationTitle("More")
        }
    }
}

struct MoreView_Previews: PreviewProvider {
    static var previews: some View {
        MoreView()
    }
}
