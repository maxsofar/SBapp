//
//  SwiftUIView.swift
//  SBapp
//
//  Created by Max on 12/07/2023.
//

import SwiftUI

struct DraggableCircle: View {
    @State private var currentPosition: CGSize = .zero
    @State private var newPosition: CGSize = .zero

    var body: some View {
        Circle()
            .frame(width: 100, height: 100)
            .foregroundColor(.red)
            .offset(x: self.currentPosition.width, y: self.currentPosition.height)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        self.currentPosition = CGSize(width: value.translation.width + self.newPosition.width, height: value.translation.height + self.newPosition.height)
                    }
                    .onEnded { value in
                        self.currentPosition = CGSize(width: value.translation.width + self.newPosition.width, height: value.translation.height + self.newPosition.height)
                        self.newPosition = self.currentPosition
                    }
            )
    }
}


//struct SwiftUIView: View {
//    var xpos: CGFloat = 0
//    @State var ypos: CGFloat = 0
//    var body: some View {
//        Rectangle()
//            .fill(.red)
//            .frame(width: 160, height: 160)
//            .offset(x: xpos, y: ypos)
////            .onTapGesture {
////                withAnimation(.spring(response: 1, dampingFraction: 1, blendDuration: 1))
////                {
////                    ypos = ypos < 0 ? 0 : -200
////                }
////            }
//            .onDrag(<#T##data: () -> NSItemProvider##() -> NSItemProvider#>) {
//                
//            }
//    }
//}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        DraggableCircle()
    }
}
