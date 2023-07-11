//
//  SearchBarBackground.swift
//  SBapp
//
//  Created by Max on 30/06/2023.
//

import SwiftUI

struct SearchBarButtons: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var isEditing: Bool
    @Binding var searchText: String
    @Binding var showPlaceholderText: Bool
    @Binding var backButton: Bool
    @Binding var alignment: Bool
    var body: some View {
//        GeometryReader { geometry in
            HStack {
                if backButton {
                    Button {
                        backButton = false
                        withAnimation(.easeInOut(duration: 0.5)) {
                            searchText = ""
                            isEditing = false
                            alignment = false
                            dismissKeyboard()
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            showPlaceholderText = true
                        }
                    } label: {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(Color.init(white: 0.5))
                    }
                }
                Spacer()
                if  searchText.isEmpty {
                    Spacer()
                    Image(systemName: "magnifyingglass")
                        .scaleEffect(1.2)
                        .foregroundColor(colorScheme == .dark ? Color.init(white: 0.8) : Color.init(white: 0.5))
                } else if backButton {
                    Spacer()
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.app.fill")
                            .scaleEffect(1.1)
                            .foregroundColor(Color.init(white: 0.5))
                    }
                }
            }
//        }
    }
}

struct SearchBarBackground_Previews: PreviewProvider {
    static var previews: some View {
        ContainerView()
    }
    struct ContainerView: View {
        @State private var isEditing = false
        @State var offset: CGFloat = 0
        @State var searchText = ""
        @State var showPlaceholderText = true
        @State var backButton = true
        @State var alignment: Bool = false
        var body: some View {
            SearchBarButtons(isEditing: $isEditing, searchText: $searchText, showPlaceholderText: $showPlaceholderText, backButton: $backButton, alignment: $alignment)
                .previewLayout(.fixed(width: 400, height: 60))
                .padding([.horizontal], 20)
        }
    }
}
