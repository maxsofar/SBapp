//
//  FavoritesView.swift
//  SBapp
//
//  Created by Max on 06/07/2023.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var courses: Courses
    @State private var favoriteCourses: [Course] = []
    @State private var selectedTag: String?

     var body: some View {
         VStack {
             List (favoriteCourses) { course in
                 NavigationLink(destination:
                    LessonsView(course: course, selectedTag: $selectedTag)
                        .toolbar {
                            ToolbarItemGroup {
                                ToolbarButtons(course: course, selectedTag: .constant(nil), showFilterButton: .constant(true))
                            }
                        }
                 ) {
                     Text(course.name)
                 }
             }
             .onAppear {
                 favoriteCourses = courses.courses.filter{$0.isFavorite}
             }
         }
         .navigationTitle("Favorites")
         .navigationBarTitleDisplayMode(.large)
     }
 }

//struct FavoritesView_Previews: PreviewProvider {
//    static var previews: some View {
////        @StateObject var courses = Courses()
//        let viewModel = CourseViewModel(numberOfWeeks: 13)
//        return FavoritesView(viewModel: viewModel)
//    }
//}
