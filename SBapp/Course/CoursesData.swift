//
//  Courses.swift
//  SBapp
//
//  Created by Max on 21/06/2023.
//

import Foundation

class Course : ObservableObject, Identifiable {
    let id: Int
    let name: String
    @Published var isFavorite: Bool {
        didSet {
            // Save the state of isFavorite to UserDefaults when it changes
            let key = "isFavorite_\(id)"
            UserDefaults.standard.set(isFavorite, forKey: key)
        }
    }
    let lectureTags: [String]
    let tutorialTags: [String]
    
    init(
        id: Int,
        name: String,
        isFavorite: Bool = false,
        lectureTags: [String] = [],
        tutorialTags: [String] = []
    ) {
        
        self.id = id
        self.name = name
        self.lectureTags = lectureTags
        self.tutorialTags = tutorialTags
        
        // Load the state of isFavorite from UserDefaults when the course is initialized
        let key = "isFavorite_\(id)"
        self.isFavorite = UserDefaults.standard.bool(forKey: key)
    }
    
    func makeFavorite() {
        isFavorite.toggle()
    }
    
    func isCourseFavorite() -> Bool {
        isFavorite
    }
    
    func getName() -> String {
        name
    }
    
    func getTags(week: Int) -> (lecture: String?, tutorial: String?) {
        var lectureTag: String? = nil
        var tutorialTag: String? = nil
        if week <= lectureTags.count {
            lectureTag = lectureTags[week - 1]
        }
        if week <= tutorialTags.count {
            tutorialTag = tutorialTags[week - 1]
        }
        
        return (lectureTag, tutorialTag)
    }
}


class Courses : ObservableObject {
    @Published var courses = [
        Course(id: 11, name: "Matam", lectureTags: ["Atoms", "Leibniz", "Gamma", "Dopler"], tutorialTags: ["Pascal", "Einstein", "Mu", "Foo"]),
        Course(id: 12, name: "Infi1"),
        Course(id: 13, name: "Physics1m")
    ]
}

