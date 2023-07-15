//
//  Courses.swift
//  SBapp
//
//  Created by Max on 21/06/2023.
//

import Foundation
import SwiftCSV


// URL of the CSV file on GitHub
let csvURL = URL(string: "https://raw.githubusercontent.com/Cyanivde/StudyBuddy/main/courses.csv")!



class Course : ObservableObject, Identifiable, Equatable {
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
    
    @Published var isComplete: [Bool] {
        didSet {
            // Save the state of isComplete to UserDefaults when it changes
            let key = "isComplete_\(id)"
            UserDefaults.standard.set(isComplete, forKey: key)
        }
    }
    
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
        let favoriteKey = "isFavorite_\(id)"
        self.isFavorite = UserDefaults.standard.bool(forKey: favoriteKey)
        
        // Load the state of isComplete from UserDefaults when the course is initialized
        let completeKey = "isComplete_\(id)"
        self.isComplete = UserDefaults.standard.array(forKey: completeKey) as? [Bool] ?? Array(repeating: false, count: 13)
    }
}

extension Course {
    static func == (lhs: Course, rhs: Course) -> Bool {
            return lhs.id == rhs.id && lhs.name == rhs.name && lhs.isFavorite == rhs.isFavorite
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
    
    func getIsComplete(for week: Int) -> Bool {
        guard week > 0 && week <= isComplete.count else {
            return false
        }
        return isComplete[week - 1]
    }
        
    func setIsComplete(_ value: Bool, for week: Int) {
        guard week > 0 && week <= isComplete.count else {
            return
        }
        isComplete[week - 1] = value
    }
}

class Courses: ObservableObject {
    @Published var courses: [Course] = []

    func loadCourses(from url: URL, completion: @escaping ([Course]) -> Void) {
        // Create a URLSession data task to load the data from the URL
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Check for errors
            guard let data = data, error == nil else {
                print("Error loading data: \(error!)")
                return
            }

            // Convert the data to a String
            let csvString = String(data: data, encoding: .utf8)!

            // Create a NamedCSV object from the String
            let csv = try! NamedCSV(string: csvString)

            // Access the data by column
            let courseInstituteIDs = csv.columns!["course_institute_id"]!
            let courseNames = csv.columns!["course_name"]!

            // Create an array of Course objects from the CSV data
            var courses = [Course]()
            for i in 0..<courseInstituteIDs.count {
                let id = Int(courseInstituteIDs[i])!
                let name = courseNames[i]
                let course = Course(id: id, name: name)
                courses.append(course)
            }
            
            // Call the completion handler with the loaded courses
            completion(courses)
        }

        // Start the data task
        task.resume()
    }
    
    func loadCourses(from url: URL) {
        // Load the courses asynchronously using the loadCourses function
        loadCourses(from: url) { courses in
            // Update the courses property with the loaded courses on the main thread
            DispatchQueue.main.async {
                self.courses = courses.map { courseData in
                    // Create a Course object for each courseData
                    let id = courseData.id
                    let name = courseData.name
                    let key = "isFavorite_\(id)"
                    let isFavorite = UserDefaults.standard.bool(forKey: key)
                    return Course(id: id, name: name, isFavorite: isFavorite)
                }
            }
        }
    }
}



//var coursesList = [
//    Course(id: 11, name: "Matam", lectureTags: ["Atoms", "Leibniz", "Gamma", "Dopler"], tutorialTags: ["Pascal", "Einstein", "Mu", "Foo"]),
//    Course(id: 12, name: "Infi1"),
//    Course(id: 13, name: "Physics1m")
//]
