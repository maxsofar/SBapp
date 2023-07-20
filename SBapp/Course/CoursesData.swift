//
//  Courses.swift
//  SBapp
//
//  Created by Max on 21/06/2023.
//

import Foundation
import SwiftCSV
import SwiftSoup


// URL of the CSV file on GitHub
let csvURL = URL(string: "https://raw.githubusercontent.com/Cyanivde/StudyBuddy/main/courses.csv")!

struct Exam: Hashable {
    let year: String
    let semester: String
    let links: [String]
}

class Course : ObservableObject, Identifiable, Equatable {
    let id: String
    let name: String
    let lectureTags: [String]
    let tutorialTags: [String]
    var lectureLinks: [String]
    var lectureRecordingLinks: [String]
    var tutorialLinks: [String]
    var tutorialRecordingLinks: [String]
    let exams: [Exam]
    
    @Published var isFavorite: Bool {
        didSet {
            // Save the state of isFavorite to UserDefaults when it changes
            let key = "isFavorite_\(id)"
            UserDefaults.standard.set(isFavorite, forKey: key)
        }
    }
    @Published var isComplete: [Bool] {
        didSet {
            // Save the state of isComplete to UserDefaults when it changes
            let key = "isComplete_\(id)"
            UserDefaults.standard.set(isComplete, forKey: key)
        }
    }
    
    
    init(
        id: String,
        name: String,
        isFavorite: Bool = false,
        lectureTags: [String] = [],
        tutorialTags: [String] = [],
        lectureLinks: [String] = [],
        lectureRecordingLinks: [String] = [],
        tutorialLinks: [String] = [],
        tutorialRecordingLinks: [String] = [],
        exams: [Exam] = []
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
        
        // Initialize the lecture and tutorial links
        self.lectureLinks = lectureLinks
        self.lectureRecordingLinks = lectureRecordingLinks
        self.tutorialLinks = tutorialLinks
        self.tutorialRecordingLinks = tutorialRecordingLinks
        
        // Initialize exams
        self.exams = exams
    }
}

extension Course {
    static func == (lhs: Course, rhs: Course) -> Bool {
       return lhs.id == rhs.id
   }
    
    func makeFavorite() {
        isFavorite.toggle()
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
    
//    func scrape(progressHandler: @escaping (Float) -> Void) {
    func scrape(completion: @escaping () -> Void) {
        if !lectureLinks.isEmpty || !tutorialLinks.isEmpty  {
                defer { completion() }
                    // The links have already been fetched, so return early
                    return
                }
        
        var request = URLRequest(url: URL(string: "https://studybuddy.co.il/technion/\(id)/lessons")!)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            defer { completion() }
            guard let data = data, error == nil else {
                print("Error downloading HTML: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let html = String(data: data, encoding: .utf8) {
                do {
                    let document = try SwiftSoup.parse(html)
                    // Use SwiftSoup to extract the lecture links from the HTML
                    let lectureLinks = try document.select("a:contains(הרצאה)").array().map { try $0.attr("href") }
                    // Update the lectureLinks property with the scraped lecture links
                    self.lectureLinks = lectureLinks
                    
                    let tutorialLinks = try document.select("a:contains(תרגול)").array().map { try $0.attr("href") }
                    self.tutorialLinks = tutorialLinks
                } catch {
                    print("Error parsing HTML: \(error.localizedDescription)")
                }
            } else {
                print("Error converting data to string")
            }
        }
        task.resume()
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
                let id = courseInstituteIDs[i]
                let name = courseNames[i]
//                let course = Course(id: id, name: name)
                let courseData = testCourses[i % testCourses.count]
                let course = Course(
                    id: id,
                    name: name,
                    lectureTags: courseData.lectureTags,
                    tutorialTags: courseData.tutorialTags,
//                    lectureLinks: courseData.lectureLinks,
                    lectureRecordingLinks: courseData.lectureRecordingLinks,
//                    tutorialLinks: courseData.tutorialLinks,
                    tutorialRecordingLinks: courseData.tutorialRecordingLinks,
                    exams: testExams
                )
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
                    return Course(
                       id: id,
                       name: name,
                       isFavorite: isFavorite,
                       lectureTags: courseData.lectureTags,
                       tutorialTags: courseData.tutorialTags,
//                       lectureLinks: courseData.lectureLinks,
                       lectureRecordingLinks: courseData.lectureRecordingLinks,
//                       tutorialLinks: courseData.tutorialLinks,
                       tutorialRecordingLinks: courseData.tutorialRecordingLinks,
                       exams: courseData.exams
                   )
                }
            }
        }
    }
}

// Dummy data for exams
let testExams = [
    Exam(year: "2022", semester: "Fall", links: ["https://example.com/exam1", "https://example.com/exam2"]),
    Exam(year: "2022", semester: "Spring", links: ["https://example.com/exam3", "https://example.com/exam4"]),
    Exam(year: "2021", semester: "Fall", links: ["https://example.com/exam5", "https://example.com/exam6"]),
    Exam(year: "2021", semester: "Spring", links: ["https://example.com/exam7", "https://example.com/exam8"])
]

let testCourses = [
    Course(id: "1",
           name: "מתמטיקה",
           lectureTags: ["אלגברה", "חשבון", "גיאומטריה", "טריגונומטריה", "סטטיסטיקה"],
           tutorialTags: ["בעיות אלגברה", "בעיות חשבון", "בעיות גיאומטריה", "בעיות טריגונומטריה", "בעיות סטטיסטיקה"],
           lectureLinks: ["https://mathlecturelink1.com", "https://mathlecturelink2.com"],
           lectureRecordingLinks: ["https://mathlecturerecordinglink1.com", "https://mathlecturerecordinglink2.com"],
           tutorialLinks: ["https://mathtutoriallink1.com", "https://mathtutoriallink2.com"],
           tutorialRecordingLinks: ["https://mathtutorialrecordinglink1.com", "https://mathtutorialrecordinglink2.com"]),
    Course(id: "2",
           name: "פיזיקה",
           lectureTags: ["מכניקה", "תרמודינמיקה", "אלקטרומגנטיות", "אופטיקה", "מכניקה קוונטית"],
           tutorialTags: ["בעיות מכניקה", "בעיות תרמודינמיקה", "בעיות אלקטרומגנטיות", "בעיות אופטיקה", "בעיות מכניקה קוונטית"],
           lectureLinks: ["https://physicslecturelink1.com", "https://physicslecturelink2.com"],
           lectureRecordingLinks: ["https://physicslecturerecordinglink1.com", "https://physicslecturerecordinglink2.com"],
           tutorialLinks: ["https://physicstutoriallink1.com", "https://physicstutoriallink2.com"],
           tutorialRecordingLinks: ["https://physicstutorialrecordinglink1.com", "https://physicstutorialrecordinglink2.com"]),
    Course(id: "3",
           name: "כימיה",
           lectureTags: ["כימיה אורגנית", "כימיה לא אורגנית", "כימיה פיזיקלית", "ביו-כימיה", "אנליזה כימי"],
           tutorialTags: ["בעיות כימיה אורגני", "בעיות כимия לא אורגני", "בעיות כמי פיזאלי"," בעיות ביו-חמי"," בעיות אנלאל חמי"],
           lectureLinks: ["https://chemistrylecturelink1.com", "https://chemistrylecturelink2.com"],
           lectureRecordingLinks: ["https://chemistrylecturerecordinglink1.com", "https://chemistrylecturerecordinglink2.com"],
           tutorialLinks: ["https://chemistrytutoriallink1.com", "https://chemistrytutoriallink2.com"],
           tutorialRecordingLinks: ["https://chemistrytutorialrecordinglink1.com", "https://chemistrytutorialrecordinglink2.com"])
]


//let testCourses = [
//    Course(id: "1",
//           name: "Mathematics",
//           lectureTags: ["Algebra", "Calculus", "Geometry", "Trigonometry", "Statistics"],
//           tutorialTags: ["Algebra Problems", "Calculus Problems", "Geometry Problems", "Trigonometry Problems", "Statistics Problems"],
//           lectureLinks: ["https://mathlecturelink1.com", "https://mathlecturelink2.com"],
//           lectureRecordingLinks: ["https://mathlecturerecordinglink1.com", "https://mathlecturerecordinglink2.com"],
//           tutorialLinks: ["https://mathtutoriallink1.com", "https://mathtutoriallink2.com"],
//           tutorialRecordingLinks: ["https://mathtutorialrecordinglink1.com", "https://mathtutorialrecordinglink2.com"]),
//    Course(id: "2",
//           name: "Physics",
//           lectureTags: ["Mechanics", "Thermodynamics", "Electromagnetism", "Optics", "Quantum Mechanics"],
//           tutorialTags: ["Mechanics Problems", "Thermodynamics Problems", "Electromagnetism Problems", "Optics Problems", "Quantum Mechanics Problems"],
//           lectureLinks: ["https://physicslecturelink1.com", "https://physicslecturelink2.com"],
//           lectureRecordingLinks: ["https://physicslecturerecordinglink1.com", "https://physicslecturerecordinglink2.com"],
//           tutorialLinks: ["https://physicstutoriallink1.com", "https://physicstutoriallink2.com"],
//           tutorialRecordingLinks: ["https://physicstutorialrecordinglink1.com", "https://physicstutorialrecordinglink2.com"]),
//    Course(id: "3",
//           name: "Chemistry",
//           lectureTags: ["Organic Chemistry", "Inorganic Chemistry", "Physical Chemistry", "Biochemistry", "Analytical Chemistry"],
//           tutorialTags: ["Organic Chemistry Problems", "Inorganic Chemistry Problems", "Physical Chemistry Problems", "Biochemistry Problems", "Analytical Chemistry Problems"],
//           lectureLinks: ["https://chemistrylecturelink1.com", "https://chemistrylecturelink2.com"],
//           lectureRecordingLinks: ["https://chemistrylecturerecordinglink1.com", "https://chemistrylecturerecordinglink2.com"],
//           tutorialLinks: ["https://chemistrytutoriallink1.com", "https://chemistrytutoriallink2.com"],
//           tutorialRecordingLinks: ["https://chemistrytutorialrecordinglink1.com", "https://chemistrytutorialrecordinglink2.com"])
//]


