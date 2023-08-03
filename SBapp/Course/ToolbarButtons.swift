//
//  ToolbarButtons.swift
//  SBapp
//
//  Created by Max on 26/07/2023.
//

import SwiftUI

struct FavoriteButton: View {
    @ObservedObject var course: Course
    
    var body: some View {
        Button{
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            course.makeFavorite()
        } label: {
            Image(systemName: course.isFavorite ? "star.fill" : "star")
                .scaleEffect(1.2)
        }
    }
}

struct FilterButton: View {
    @ObservedObject var course: Course
    @Binding var selectedTag: String?
    @State var showingModal = false
    
    var body: some View {
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


struct ToolbarButtons_Previews: PreviewProvider {
    struct PreviewView : View {
        @State var selectedTag: String? = nil
        @State var showFilterButton: Bool = true
        
        var body: some View {
            NavigationView {
                Text("Content")
                    .fontWeight(.bold)
                    .font(.largeTitle)
                    .background{
                        Color.orange
                            .frame(width: UIScreen.main.bounds.width, height: 150)
                    }
                    .toolbar {
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            FavoriteButton(course: testCourses[0])
                            FilterButton(course: testCourses[0], selectedTag: $selectedTag)
                            
                        }
                    }
            }
        }
    }
    
    static var previews: some View {
        PreviewView()
    }
}

