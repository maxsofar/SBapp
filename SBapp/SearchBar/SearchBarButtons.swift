//
//  SearchBarBackground.swift
//  SBapp
//
//  Created by Max on 30/06/2023.
//

import SwiftUI

func dismissKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}


struct SearchBarButtons: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var isEditing: Bool
    @Binding var searchText: String
    @Binding var backButton: Bool
    @Binding var alignment: Bool
    @Binding var showList: Bool
    var body: some View {
        HStack {
            if backButton {
                Button {
                    backButton = false
                    dismissKeyboard()
                    searchText = ""
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isEditing = false
                        alignment = false
                        showList = false
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
    }
}

struct SearchBarBackground_Previews: PreviewProvider {
    static var previews: some View {
        ContainerView()
    }
    struct ContainerView: View {
        @State var isEditing = false
        @State var searchText = ""
        @State var backButton = true
        @State var alignment: Bool = false
        @State var showList = false

        var body: some View {
            SearchBarButtons(
                isEditing: $isEditing,
                searchText: $searchText,
                backButton: $backButton,
                alignment: $alignment,
                showList: $showList
            )
                .previewLayout(.fixed(width: UIScreen.main.bounds.width, height: 60))
                .padding([.horizontal], 20)
        }
    }
}
