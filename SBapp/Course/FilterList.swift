//
//  FilterList.swift
//  SBapp
//
//  Created by Max on 14/07/2023.
//

import SwiftUI

struct FilterList: View {
    let course: Course
    @Binding var selectedTag: String?
    @Binding var showingModal: Bool
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .leading) {
            Text("Filter by Topic")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.horizontal, 30)
                .padding(.top, 40)
            List {
                Section {
                    filterButton(title: "All", tag: nil)
                }
                ForEach(course.lectureTags, id: \.self) { tag in
                    filterButton(title: tag, tag: tag)
                }
                ForEach(course.tutorialTags, id: \.self) { tag in
                    filterButton(title: tag, tag: tag)
                }
            }
            .padding(.top, -20)
        }
        .background(colorScheme == .light ? Color(UIColor.secondarySystemBackground) : Color(UIColor.systemGroupedBackground))
    }

    private func filterButton(title: String, tag: String?) -> some View {
        Button {
            selectedTag = tag
            showingModal = false
        } label: {
            HStack {
                if title == "All" {
                    Text(LocalizedStringKey(title))
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                } else {
                    Text(title)
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                }
                if selectedTag == tag {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}





//struct FilterList_Previews: PreviewProvider {
//    static var previews: some View {
//        @State var selectedTag: String?
//        @State  var showingModal = false
//        FilterList(course: coursesList[0], selectedTag: $selectedTag, showingModal: $showingModal)
//    }
//}
