//
//  SearchBarMain.swift
//  SBapp
//
//  Created by Max on 11/07/2023.
//

import SwiftUI

struct SearchBarArea: View {
    @ObservedObject var courses: Courses
    @Binding var isEditing: Bool
    @Namespace var searchTransition
    var vGeometry: GeometryProxy
    @Environment(\.colorScheme) var colorScheme
    
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
                    searchBarHeight: vGeometry.size.height * 0.08
                )
                .offset(y: isEditing ? 0 : zGeometry.size.width * 0.65)
                .matchedGeometryEffect(id: "SearchBar", in: searchTransition)
                
                if !isEditing {
                    Image(colorScheme == .light ? "Foregrnd" : "ForegrndDark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .shadow(color: colorScheme == .light ?
                                Color(red: 0.15, green: 0.2, blue: 0.4, opacity: 0.7) : Color(.sRGBLinear, white: 0, opacity: 0.53),
                                radius: 2, x: 3, y: 0)
                        .allowsHitTesting(false)
                }
            }
        }
    }
}

//struct SearchBarMain_Previews: PreviewProvider {
//    static var previews: some View {
//        ContainerView()
//    }
//
//    struct ContainerView: View {
//        @State private var isEditing = false
//        var body: some View {
//            GeometryReader{ geometry in
//                SearchBarMain(courses: Courses(testCourses: testCourses), isEditing: $isEditing, vGeometry: geometry)
//            }
//        }
//    }
//}
