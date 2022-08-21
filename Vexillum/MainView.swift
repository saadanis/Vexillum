//
//  NewContentView.swift
//  Vexillum
//
//  Created by Saad Anis on 07/07/2022.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            NavigationView {
                BrowseView()
            }
            .tabItem {
                Label("Browse", systemImage: "rectangle.fill.on.rectangle.fill")
            }
            ListsView()
                .tabItem {
                    Label("Lists", systemImage: "rectangle.grid.1x2.fill")
                }
            Text("Glossary")
                .tabItem {
                    Label("Glossary", systemImage: "text.book.closed")
                }
            Text("Quizzes")
                .tabItem {
                    Label("Quizzes", systemImage: "pencil.and.outline")
                }
            MoreView()
                .tabItem {
                    Label("More", systemImage: "ellipsis.circle")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
