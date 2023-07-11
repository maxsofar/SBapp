//
//  MainSearchBarView.swift
//  SBapp
//
//  Created by Max on 11/07/2023.
//

import SwiftUI

struct MainSearchBarView: View {
    @StateObject var courses = Courses()
    @Binding var isEditing: Bool
    @State var offset: CGFloat = 0
    @Namespace private var searchTransition
    @State private var selectedTag: String?
    let viewModel = CourseViewModel(numberOfWeeks: 13)
    let screenHeight = UIScreen.main.bounds.height
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                //            if !isEditing {
                //                Image("Leg")
                //                    .resizable()
                //                    .aspectRatio(contentMode: .fit)
                //                    .frame(width: screenWidth * 0.11)
                //                    .offset(x: -93, y: 105)
                //            }
                SearchBar(isEditing: $isEditing, courses: courses, geoHeight: geometry.size.height, viewModel: viewModel )
//                    .frame(height: geometry.size.width * 0.15)
                    .offset(y: isEditing ? 0 : geometry.size.width * 0.645)
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

struct MainSearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        ContainerView()
    }
    struct ContainerView: View {
        @State private var isEditing = false
        var body: some View {
            MainSearchBarView(isEditing: $isEditing)
            
        }
    }
}
