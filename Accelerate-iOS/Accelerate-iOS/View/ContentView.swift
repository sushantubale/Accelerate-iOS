//
//  ContentView.swift
//  Accelerate-iOS
//
//  Created by Sushant Ubale on 8/11/24.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    var imageWrapper = ImageWrapper(uiImage: UIImage.init(systemName: "plus")!)
    @State private var sheetShown = false
    @State private var selectedItem: PhotosPickerItem?
    @State var image: UIImage?

    var body: some View {
        NavigationView {
            VStack {
                PhotosPicker("Select an image", selection: $selectedItem, matching: .images)
                    .onChange(of: selectedItem) {
                        Task {
                            if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                                image = UIImage(data: data)
                            }
                            print("Failed to load the image")
                        }
                    }
                
                if let image {
                    VStack(alignment: .leading, spacing: 12) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                        
                        NavigationLink(destination: EqualizeHistogramView(processedImage: image)) {
                            Text("Equalize Histogram")
                        }
                        
                        NavigationLink(destination: ReflectImageView(processedImage: image)) {
                            Text("Reflect Image")
                        }
                    }
                }
                Spacer()

            }
            .padding()
            .sheet(isPresented: $sheetShown) {
                
            }
        }
    }
}

#Preview {
    ContentView()
}
