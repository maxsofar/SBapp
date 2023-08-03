//
//  CustomTabBar.swift
//  SBapp
//
//  Created by Max on 26/07/2023.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selection: Int
    
    var body: some View {
        ZStack() {
            HStack {
                Button {
                    withAnimation(.easeInOut(duration: 0.35)){
                        selection = 0
                    }
                } label: {
                    Label("Lessons", systemImage: "list.bullet")
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(selection == 0 ? .accentColor : .primary)
                
                Button{
                    withAnimation(.easeInOut(duration: 0.35)){
                        selection = 1
                    }
                } label: {
                    Label("Exams", systemImage: "doc.text")
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(selection == 1 ? .accentColor : .primary)
                
            }
            .frame(height: 45)
            
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 100, height: 3)
                .foregroundColor(.accentColor)
                .position(x: selection == 0 ? UIScreen.main.bounds.width / 4.05 : UIScreen.main.bounds.width / 4 * 3.05)
                .animation(.spring(response: 0.5, dampingFraction: 0.55, blendDuration: 0), value: selection)
        }
        .background(.bar)
        .frame(height: 45)
    }
}


struct CustomTabBar_Previews: PreviewProvider {
    struct PreviewView: View {
        @State var selection: Int = 0
        
        var body: some View {
            CustomTabBar(selection: $selection)
                .previewLayout(.fixed(width: UIScreen.main.bounds.width, height: 60))
        }
    }
    
    static var previews: some View {
        PreviewView()
    }
}
