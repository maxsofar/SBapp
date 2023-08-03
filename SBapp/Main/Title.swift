//
//  Title.swift
//  SBapp
//
//  Created by Max on 30/06/2023.
//

import SwiftUI

struct Title: View {
    let text = "Study"
    let text2 = "Buddy"
    @State private var revealed: [Bool]
    @Binding var hasAnimated: Bool
    
    init(hasAnimated: Binding<Bool>) {
            self._hasAnimated = hasAnimated
            self._revealed = State(initialValue: hasAnimated.wrappedValue ? Array(repeating: true, count: 5) : Array(repeating: false, count: 5))
    }
    
    var body: some View {
        HStack(spacing: 1) {
                ForEach(Array(text.enumerated()), id: \.offset) { (index, char) in
                    Text(String(char))
                        .font(Font.custom("Mali-Regular", size: 60))
                        .opacity(index == 0 || revealed[index] ? 1 : 0)
                        .offset(x: index == 0 ? (revealed[index] ? 0 : 135) : 0)
                        .animation(.easeInOut(duration: 1).delay(index == 0 ? 0 : Double(text.count - index - 1) * 0.1), value: revealed[index])
                }
                ForEach(Array(text2.enumerated()), id: \.offset) { (index, char) in
                    Text(String(char))
                        .font(Font.custom("Mali-Regular", size: 60))
                        .opacity(index == 0 || revealed[index] ? 1 : 0)
                        .animation(.easeInOut(duration: 1).delay(Double(index - 3) * 0.1), value: revealed[index])
            }
            
        }
        .padding(.leading, 11)
        .onAppear {
            if !hasAnimated {
                for index in revealed.indices {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1 + Double(index) * 0.1) {
                        revealed[index] = true
                    }
                }
                hasAnimated = true
            }
        }
        .environment(\.layoutDirection, .leftToRight)
    }
}

struct Title_Previews: PreviewProvider {
    static var previews: some View {
        Title(hasAnimated: .constant(false))
    
    }
}
