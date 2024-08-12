//
//  ReflectImageView.swift
//  Accelerate-iOS
//
//  Created by Sushant Ubale on 8/11/24.
//

import SwiftUI

struct ReflectImageView: View {
    var processedImage: UIImage?

    var body: some View {
        VStack {
            if let processedImage = processedImage {
                var imageWrapper = ImageWrapper(uiImage: processedImage)
                Image(uiImage: imageWrapper.reflectImage()!)
                    .resizable()
                    .scaledToFit()
            }
        }
    }
}

#Preview {
    ReflectImageView()
}
