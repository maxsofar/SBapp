//
//  TagFilter.swift
//  SBapp
//
//  Created by Max on 23/06/2023.
//

import SwiftUI

struct TagFilter: View {
    let tags = ["tag1", "tag2", "tag3"]
    @State private var selectedTag = "tag1"
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List(tags, id: \.self) { tag in
                HStack {
                    Text(tag)
                    Spacer()
                    if tag == selectedTag {
                        Image(systemName: "checkmark")
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedTag = tag
                    dismiss()
                }
            }
            .navigationBarTitle("Choose a tag")
        }
    }
}

struct TagFilter_Previews: PreviewProvider {
    static var previews: some View {
        TagFilter()
    }
}
