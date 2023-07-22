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
//                .onAppear{
//                    print("lectureTags content:")
//                    print(course.lectureTags)
//                    print("tutorialTags content:")
//                    print(course.tutorialTags)
//                }
            
            List {
                Section {
                    filterButton(title: "All", tag: nil)
                }
                ForEach(Array(course.lectureTags.keys.sorted()), id: \.self) { weekNumber in
                    if let lectureBadges = course.lectureTags[weekNumber] {
                        ForEach(lectureBadges, id: \.self) { lectureBadge in
                            filterButton(title: lectureBadge, tag: lectureBadge)
                        }
                    }
                    if let tutorialBadges = course.tutorialTags[weekNumber] {
                        ForEach(tutorialBadges, id: \.self) { tutorialBadge in
                            if !(course.lectureTags[weekNumber]?.contains(tutorialBadge) ?? false) {
                                filterButton(title: tutorialBadge, tag: tutorialBadge)
                            }
                        }
                    }
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





struct FilterList_Previews: PreviewProvider {
    static var previews: some View {
        @State var selectedTag: String?
        @State  var showingModal = false
        FilterList(course: testCourses[0], selectedTag: $selectedTag, showingModal: $showingModal)
    }
}
