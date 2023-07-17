//
//  test.swift
//  SBapp
//
//  Created by Max on 15/07/2023.
//

import SwiftUI

struct ToolbarButtons: View {
    @ObservedObject var course: Course
    @Binding var selectedTag: String?
    @Binding var showFilterButton: Bool
    @State var showingModal = false
    
    var body: some View {
        HStack {
            favoriteButton
            if showFilterButton {
                filterButton
            }
        }
    }
    
    private var favoriteButton: some View {
        Button{
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            course.makeFavorite()
        } label: {
            Image(systemName: course.isFavorite ? "star.fill" : "star")
                .scaleEffect(1.2)
        }
    }
    
    private var filterButton: some View {
        Button() {
            showingModal.toggle()
        } label: {
            Image(systemName: selectedTag == nil ? "line.3.horizontal.decrease.circle"
                    : "line.3.horizontal.decrease.circle.fill"
            )
                .scaleEffect(1.2)
        }
        .sheet(isPresented: $showingModal) {
            FilterList(course: course, selectedTag: $selectedTag, showingModal: $showingModal)
        }
    }
}


struct CourseView: View {
    @State private var selection = 0
    @State private var showingModal = false
    @State private var selectedTag: String?
    @State var showFilterButton = true
    @ObservedObject var course: Course
    let singleTabWidth: CGFloat = 140

    var body: some View {
        GeometryReader {vGeometry in
            ZStack {
                TabView(selection: $selection) {
                    LessonsView(course: course, selectedTag: $selectedTag)
                        .tabItem {
                            Label("Lessons", systemImage: "list.bullet")
                        }
                        .tag(0)
                    ExamsView(course: course)
                        .tabItem {
                            Label("Exams", systemImage: "doc.text")
                        }
                        .tag(1)
                }
                .navigationTitle(course.name)
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItemGroup {
                        ToolbarButtons(course: course, selectedTag: $selectedTag, showFilterButton: $showFilterButton)
                    }
                }
                .onChange(of: selection) { newValue in
                           // Update the showFilterButton property when the selected tab changes
                           showFilterButton = (newValue == 0)
               }
                
                RoundedRectangle(cornerRadius: 20)
                    .offset(x: (selection != 0)
                            ? -vGeometry.size.width * 0.25 : vGeometry.size.width * 0.25,
                            y: vGeometry.size.height * 0.425
                    )
                    .frame(width: singleTabWidth, height: 3)
                    .foregroundColor(.blue)
                    .animation(.spring(response: 0.5, dampingFraction: 0.55, blendDuration: 0), value: selection)
            }
        }
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


struct test_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CourseView(course: testCourses[0])
                .navigationBarItems(leading: BackButton())
            }
    }
}
