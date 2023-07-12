//
//  MainViewToolbar.swift
//  SBapp
//
//  Created by Max on 11/07/2023.
//

import SwiftUI

struct MainViewToolbar: View {
    @ObservedObject var courses: Courses
    var viewModel: CourseViewModel
    
    var body: some View {
        HStack {
            NavigationLink {
                FavoritesView(courses: courses, viewModel: viewModel)
            } label: {
                Image(systemName: "star.circle")
                    .scaleEffect(1.8)
                    .foregroundColor(Color.secondary)

            }
            Spacer()
            NavigationLink {
                LoginView()
            } label: {
                Image(systemName: "person.crop.circle")
                    .scaleEffect(1.8)
                    .foregroundColor(Color.secondary)
            }
        }
        .padding([.horizontal], 30)
        .padding([.vertical], 15)
    }
}

struct MainViewToolbar_Previews: PreviewProvider {
    static var previews: some View {
        ContainerView()
            .previewLayout(.fixed(width: UIScreen.main.bounds.width, height: 60))
    }
    struct ContainerView: View {
        @StateObject var courses = Courses()
        let viewModel = CourseViewModel(numberOfWeeks: 13)
        var body: some View {
            MainViewToolbar(courses: courses, viewModel: viewModel)
        }
    }
}
