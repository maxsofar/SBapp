//
//  ToolbarButtons.swift
//  SBapp
//
//  Created by Max on 26/07/2023.
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
                            ToolbarButtons(course: testCourses[0], selectedTag: $selectedTag, showFilterButton: $showFilterButton)
                        }
                    }
            }
        }
    }
    
    static var previews: some View {
        PreviewView()
    }
}

