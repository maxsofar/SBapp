//
//  test.swift
//  SBapp
//
//  Created by Max on 15/07/2023.
//

import SwiftUI

struct test: View {
    @State private var selection = 0
    @State private var showingModal = false
    @State private var selectedTag: String?
    @State var showFilterButton = true
    
    @State private var scrapeProgress: Float = 0
    @State private var showActivityIndicator = false
    
    @ObservedObject var course: Course
    let singleTabWidth: CGFloat = 140
    @Environment(\.colorScheme) var colorScheme
    
    init(course: Course) {
        self.course = course
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.init(white: 0.95)) // Change this to your desired background color
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
            TabView(selection: $selection) {
                LessonsView(course: course, selectedTag: $selectedTag)
                    .tabItem {
                        Label("Lessons", systemImage: "list.bullet")
                    }
//                    .background(colorScheme == .light ? Color.init(white: 0.95) : .clear)
                    .tag(0)
                
                
                ExamsView(course: course)
                    .tabItem {
                        Label("Exams", systemImage: "doc.text")
                    }
                    .tag(1)
            }
            
            .navigationTitle(course.name)
            .navigationBarTitleDisplayMode(.large)
//            .toolbar {
//                ToolbarItemGroup {
//                    ToolbarButtons(course: course, selectedTag: $selectedTag, showFilterButton: $showFilterButton)
//                }
//            }
            .onChange(of: selection) { newValue in
                       // Update the showFilterButton property when the selected tab changes
                       showFilterButton = (newValue == 0)
           }
////                ProgressView(value: scrapeProgress)
//            if showActivityIndicator {
//                ActivityIndicatorView()
//            }
//
//        }
//
//        .onAppear {
//            //                course.scrape { progress in
//            //                            scrapeProgress = progress
//            //                }
//            showActivityIndicator = true
//
//            course.scrape(){
//
//                showActivityIndicator = false
//            }
//        }
    }
}


struct BackButton: View {
    var body: some View {
        HStack {
            Image(systemName: "chevron.left")
            Text("Back")
        }
    }
}


struct CourseView_Previews:
    PreviewProvider {
    static var previews: some View {
        NavigationView {
            test(course: testCourses[0])
//                .navigationBarItems(leading: BackButton())
            }
        
    }
}
