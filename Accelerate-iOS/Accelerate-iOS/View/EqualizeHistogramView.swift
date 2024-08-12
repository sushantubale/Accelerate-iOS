//
//  ProcessedImageView.swift
//  Accelerate-iOS
//
//  Created by Sushant Ubale on 8/11/24.
//

import SwiftUI

struct EqualizeHistogramView: View {
    var processedImage: UIImage?
    var histogram: HistogramLevels?
    @State private var showHistogram = false

    var body: some View {
        VStack {
            if let processedImage = processedImage {
                var imageWrapper = ImageWrapper(uiImage: processedImage)
                let result = imageWrapper.processedImage
                
                Image(uiImage: result)
                    .resizable()
                    .scaledToFit()
                
                Image(uiImage: result)
                    .resizable()
                    .frame(width: 355, height: 250)
                    .scaledToFit()
                    .border(Color.black)
                    .onTapGesture {
                        showHistogram.toggle()
                    }
                if let histogram = histogram {
                    if showHistogram {
                        HistogramView(histogram: histogram)
                            .background(Color.white)
                            .frame(width: 150, height: 113)
                            .padding(5)
                    }
                }
            }
            


        }
    }
}

#Preview {
    EqualizeHistogramView()
}

struct HistogramView: View {
    var histogram: HistogramLevels

    var binCount: Int {
        histogram.red.count
    }

    var body: some View {
        GeometryReader { proxy in
            HistogramLine(
                channel: histogram.red,
                color: Color.red,
                proxy: proxy,
                maxValue: histogram.red.max() ?? 1
            )
            HistogramLine(
                channel: histogram.green,
                color: Color.green,
                proxy: proxy,
                maxValue: histogram.green.max() ?? 1
            )
            HistogramLine(
                channel: histogram.blue,
                color: Color.blue,
                proxy: proxy,
                maxValue: histogram.blue.max() ?? 1
            )
        }
    }
}

struct HistogramLine: View {
    var channel: [UInt]
    var color: Color
    var proxy: GeometryProxy
    var maxValue: UInt

    func xForBin(_ bin: Int, proxy: GeometryProxy) -> CGFloat {
        let widthOfBin = proxy.size.width / CGFloat(channel.count)
        return CGFloat(bin) * widthOfBin
    }

    func yForCount(_ count: UInt, proxy: GeometryProxy) -> CGFloat {
        let heightOfLevel = proxy.size.height / CGFloat(maxValue)
        return proxy.size.height - CGFloat(count) * heightOfLevel
    }

    var body: some View {
        Path { path in
            for bin in 0..<channel.count {
                let newPoint = CGPoint(
                    x: xForBin(bin, proxy: proxy),
                    y: yForCount(channel[bin], proxy: proxy)
                )
                if bin == 0 {
                    path.move(to: newPoint)
                } else {
                    path.addLine(to: newPoint)
                }
            }
        }.stroke(color)
    }
}
