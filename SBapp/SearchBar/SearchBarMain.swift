//
//  SearchBarMain.swift
//  SBapp
//
//  Created by Max on 11/07/2023.
//

import SwiftUI

struct SearchBarMain: View {
    @ObservedObject var courses: Courses
    @Binding var isEditing: Bool
    @Namespace var searchTransition
    var vGeometry: GeometryProxy
//    @ObservedObject var viewModel: CourseViewModel
    let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        
        ZStack (){
            GeometryReader { zGeometry in
                if !isEditing {
                    Image("Leg")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                SearchBar(
                    courses: courses,
                    isEditing: $isEditing,
                    geoHeight:  vGeometry.size.height * 0.08
                )
                .offset(y: isEditing ? 0 : zGeometry.size.width * 0.65)
                .matchedGeometryEffect(id: "SearchBar", in: searchTransition)
                
                if !isEditing {
                    Image("Foregrnd")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .allowsHitTesting(false)
                }
            }
        }
    }
}

struct SearchBarMain_Previews: PreviewProvider {
    static var previews: some View {
        ContainerView()
    }
    
    struct ContainerView: View {
        @State private var isEditing = false
        var courses = Courses()
        var body: some View {
            GeometryReader{ geometry in
                SearchBarMain(courses: courses, isEditing: $isEditing, vGeometry: geometry)
            }
        }
    }
}