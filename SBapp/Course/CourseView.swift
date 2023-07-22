//
//  test.swift
//  SBapp
//
//  Created by Max on 19/07/2023.
//

import SwiftUI

struct NoBlinkButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

struct CourseView: View {
    @State private var selection = 0
    @State private var showingModal = false
    @State private var selectedTag: String?
    @State var showFilterButton = true
    
    @State private var scrapeProgress: Float = 0
    
    @ObservedObject var course: Course
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            if selection == 0 {
                LessonsView(course: course, selectedTag: $selectedTag)
                    .background(colorScheme == .light ? Color.init(white: 0.95) : .clear)
                    .transition(.move(edge: .leading))
            } else {
                ExamsView(course: course)
                    .transition(.move(edge: .trailing))
            }
            
            // Custom tab bar
            VStack {
                Spacer()
                ZStack() {
                    HStack {
                        Button {
                            withAnimation(.easeInOut(duration: 0.35)){
                                selection = 0
                            }
                        } label: {
                            Label("Lessons", systemImage: "list.bullet")
                        }
                        .frame(maxWidth: .infinity)
                        .buttonStyle(NoBlinkButtonStyle())
                        .foregroundColor(selection == 0 ? .accentColor : .primary)
                        
                        Button{
                            withAnimation(.easeInOut(duration: 0.35)){
                                selection = 1
                            }
                        } label: {
                            Label("Exams", systemImage: "doc.text")
                        }
                        .frame(maxWidth: .infinity)
                        .buttonStyle(NoBlinkButtonStyle())
                        .foregroundColor(selection == 1 ? .accentColor : .primary)
                        
                    }
                    .frame(height: 45)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 100, height: 3)
                        .foregroundColor(.blue)
                        .position(x: selection == 0 ? UIScreen.main.bounds.width / 4 : UIScreen.main.bounds.width / 4 * 3)
                        .animation(.spring(response: 0.5, dampingFraction: 0.55, blendDuration: 0), value: selection)
                }
                .background(.bar)
            .frame(height: 45)
            }
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
    }
}


struct Course_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CourseView(course: testCourses[0])
        }
    }
}
