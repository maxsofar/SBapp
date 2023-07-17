//
//  CustomDisclosureGroup.swift
//  SBapp
//
//  Created by Max on 16/07/2023.
//

import SwiftUI

struct CustomDisclosureGroup<Label: View, Content: View>: View {
    let label: Label
    let content: Content
    @State private var isExpanded = false
    
    init(@ViewBuilder label: () -> Label, @ViewBuilder content: () -> Content) {
        self.label = label()
        self.content = content()
    }
    
    var body: some View {
        VStack {
            Button(action: { withAnimation { isExpanded.toggle() } }) {
                HStack {
                    label
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.forward")
                }
                .padding()
            }
            if isExpanded {
                content
                    .transition(.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity), removal: .move(edge: .top).combined(with: .opacity)))
            }
        }
    }
}



struct CustomDisclosureGroup_Previews: PreviewProvider {
    static var previews: some View {
        CustomDisclosureGroup(label: {
            Text("Disclosure")
        }, content: {
            VStack {
                // Your content here
                Link(destination: URL(string: "https://www.example.com")!) {
                    Label("Link", systemImage: "link")
                        .labelStyle(CustomLabelStyle())
                }
            }
        })
        .groupBoxStyle(AutoColorGroupBoxStyle())
        .background(Color.init(white: 0.8))
        .frame(minWidth: 200, minHeight: 100)
    }
}
