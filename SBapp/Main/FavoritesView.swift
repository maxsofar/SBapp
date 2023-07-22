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

     var body: some View {
         VStack {
             List (favoriteCourses) { course in
                 NavigationLink(destination:
                    CourseView(course: course)
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
//        FavoritesView(courses: testCourses)
//    }
//}
