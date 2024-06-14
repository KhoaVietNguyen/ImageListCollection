//
//  ContentView.swift
//  ImageListCollection
//
//  Created by Khoa Nguyen on 13/6/24.
//

import SwiftUI

@available(iOS 14.0.0, *)
struct ContentView: View {
    var body: some View {
        ImageView()
    }
}

#Preview {
    ContentView()
}

@available(iOS 13.0.0, *)
struct ImageView: UIViewControllerRepresentable {
    typealias UIViewControllerType = ImageViewController
    
    func makeUIViewController(context: Context) -> ImageViewController {
        let vc = ImageViewController()
        return vc
    }
    
    func updateUIViewController(_ uiViewController: ImageViewController, context: Context) {
    }
}


