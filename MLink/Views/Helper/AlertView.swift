//
//  AlertView.swift
//  MLink
//
//  Created by Barreloofy on 10/2/24 at 6:37 PM.
//

import SwiftUI

struct AlertView: View {
    @Binding var isPresented: Bool
    var title: String = "Error"
    var message: String = "An error occurred"
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
            VStack {
                Text(title)
                    .font(.headline)
                Text(message)
                    .fontWeight(.medium)
                Divider()
                Button {
                    isPresented.toggle()
                } label: {
                    Text("Okay")
                        .fontWeight(.heavy)
                }
                .buttonStyle(SimpleButtonStyle())
            }
            .padding()
            .frame(width: 300)
            .background(.ultraThickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 5, x: 10, y: 10)
        }
    }
}

#Preview {
    AlertView(isPresented: .constant(true))
}
