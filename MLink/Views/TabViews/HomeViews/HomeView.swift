//
//  HomeView.swift
//  MLink
//
//  Created by Barreloofy on 10/4/24 at 2:40 PM.
//

import SwiftUI

struct HomeView: View {
    @State private var showSheet = false
    
    var body: some View {
        HStack {
            Spacer()
            Button {
                showSheet.toggle()
            } label: {
                Text("Create Post")
                    .fontWeight(.heavy)
            }
            .buttonStyle(SimpleButtonStyle())
            .sheet(isPresented: $showSheet) {
                PostForm()
            }
        }
        .padding()
        Spacer()
        List {}
    }
}

#Preview {
    HomeView()
}
