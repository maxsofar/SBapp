//
//  test.swift
//  SBapp
//
//  Created by Max on 20/07/2023.
//

import SwiftUI


struct DemoOverlayView: View {
    @State private var bottomPosition: CGFloat = 0
    
    var body: some View {
        GroupBox {
            Text("Content")
        }
        .frame(minHeight: 600)
        .border(.red)

    }
}


//struct test2: View {
//    @State private var scrollPosition: CGPoint = .zero
//
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                VStack {
//                    ForEach((1...30), id: \.self) { row in
//                        Text("Row \(row)")
//                            .frame(height: 30)
//                            .id(row)
//                    }
//                }
//                .background(GeometryReader { geometry in
//                    Color.clear
//                        .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).origin)
//                })
//                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
//                    self.scrollPosition = value
//                }
//            }
//            .overlay(
//                Image(systemName: "smiley")
//                    .resizable()
//                    .frame(width: 50, height: 50)
//                    .opacity(scrollPosition.y < -334 ? 1 : 0)
////                    .animation(.easeInOut, value: showImage)
//                    .offset(y: UIScreen.main.bounds.height + scrollPosition.y - 155)
//            )
//            .coordinateSpace(name: "scroll")
//            .navigationTitle("Scroll offset: \(scrollPosition.y)")
//            .navigationBarTitleDisplayMode(.inline)
//        }
//    }
//}
    


struct test2_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            DemoOverlayView()
        }
    }
}
