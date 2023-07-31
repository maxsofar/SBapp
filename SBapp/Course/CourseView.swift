//
//  test.swift
//  SBapp
//
//  Created by Max on 19/07/2023.
//

import SwiftUI

struct CourseView: View {
    @State private var selection = 0
    @State private var selectedTag: String?
    @State private var showFilterButton = true
    @ObservedObject var course: Course
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            if selection == 0 {
                LessonsView(course: course, selectedTag: $selectedTag)
                    .background(colorScheme == .light ? Color.init(white: 0.95) : .clear)
                    .transition(.move(edge: .leading))
            } else {
//                ExamsView(course: course)
//                    .transition(.move(edge: .trailing))
            }
            VStack {
                Spacer()
                CustomTabBar(selection: $selection)
            }
        }
        //use cutom back button until long title thing fixed
//        .navigationBarBackButtonHidden(true)
//        .navigationBarItems(leading: BackButton(isTitleTooLong: course.name.count > 25))
        //---------------------
        .navigationTitle(course.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                FavoriteButton(course: course)
                if showFilterButton {
                    FilterButton(course: course, selectedTag: $selectedTag)
                }
            }
        }
        .onChange(of: selection) { newValue in
                   // Update the showFilterButton property when the selected tab changes
                   showFilterButton = (newValue == 0)
       }
    }
}


struct Course_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CourseView(course: testCourses[0])
        }
    }
}
