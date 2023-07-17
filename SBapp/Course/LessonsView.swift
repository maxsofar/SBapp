//
//  CourseView.swift
//  SBapp
//
//  Created by Max on 23/06/2023.
//

import SwiftUI

struct ChecklistToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            configuration.label
            Image(systemName: configuration.isOn ? "largecircle.fill.circle" : "circle")
                .scaleEffect(1.3)
                .foregroundColor(configuration.isOn ? .accentColor : .secondary)
                .onTapGesture {
                    configuration.isOn.toggle()
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                }
        }
    }
}

struct LessonsView: View {
    @ObservedObject var course: Course
    @Binding var selectedTag: String?
    @State private var showingModal = false
    @Environment(\.colorScheme) var colorScheme

    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(1...13, id: \.self) { weekNumber in
                    if let tag = selectedTag, (course.getTags(week: weekNumber).lecture != tag && course.getTags(week: weekNumber).tutorial != tag) {
                        // Skip this week if a tag is selected and it doesn't appear in the course tags for this week
                        EmptyView()
                    } else {
                        weekDisclosureGroup(weekNumber: weekNumber)
                    }
                }
            }
            .padding(.vertical, 30)
            .padding(.horizontal, 10)
        }
        .background(colorScheme == .dark ? Color.clear : Color.init(white: 0.95))
//        .navigationTitle(course.name)
//        .navigationBarTitleDisplayMode(.large)
//        .toolbar {
//            ToolbarItemGroup {
//                favoriteButton
//                filterButton
//            }
//        }
    }
    
    private func weekDisclosureGroup(weekNumber: Int) -> some View {
        DisclosureGroup {
            WeekView(weekNumber: weekNumber, course: course)
                .padding(.vertical, 10)
        } label: {
            HStack {
                Toggle(isOn: Binding(
                    get: { course.getIsComplete(for: weekNumber) },
                    set: { newValue in
                        course.setIsComplete(newValue, for: weekNumber)
                    }
                )) {}
                .toggleStyle(ChecklistToggleStyle())

                Spacer()
                let localizedWeekString = NSLocalizedString("Week", comment: "")
                Text(localizedWeekString + " \(weekNumber)")
                    .font(.title3)
                    .foregroundColor ({
                        if (!course.getIsComplete(for: weekNumber)) {
                            return colorScheme == .dark ? Color.white : Color.black
                        } else {
                            return Color.gray
                        }
                    }())
                Spacer()
            }
//            .padding(.horizontal,10)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 10)
        .background(colorScheme == .dark ? Color.init(white: 0.1) : Color.white)
        .cornerRadius(10)
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


struct CourseView_Previews: PreviewProvider {
    static var previews: some View {
        @State var selectedTag: String?
        let testCourse = testCourses[0]
        LessonsView(course: testCourse, selectedTag: $selectedTag)
    }
}
