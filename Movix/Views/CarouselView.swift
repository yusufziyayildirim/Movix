//
//  CarouselView.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 9.07.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct CarouselView: View {
    let movies: [Movie]
    let onTap: (Int) -> Void
    
    init(movies: [Movie], onTap: @escaping (Int) -> Void) {
        self.movies = movies
        self.onTap = onTap
    }
    
    @State private var activeIndex = 0
    @State private var dragOffset: CGFloat = 0
    @State private var isAnimatedOffset = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Spacer()
                
                VStack(spacing: 0) {
                    ZStack {
                        ForEach(Array(movies.enumerated()), id: \.element.id) { index, movie in
                            let url = URL(string: ApiRoutes.imageURL(posterPath: movie.posterPath ?? ""))
                            WebImage(url: url)
                                .resizable()
                                .clipShape(RoundedRectangle(cornerRadius: 30))
                                .offset(x: getOffset(index: index, geometry: geometry))
                                .scaleEffect(getScale(index: index))
                                .opacity(getOpacity(index: index))
                                .shadow(color: Color(.black).opacity(0.8), radius: 5, x: 0, y: 0)
                                .onTapGesture {
                                    onTap(movie.id ?? 0)
                                }
                        }
                    }
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                withAnimation {
                                    isAnimatedOffset = true
                                    dragOffset = value.translation.width
                                }
                            }
                            .onEnded { value in
                                withAnimation {
                                    isAnimatedOffset = true
                                    let dragThreshold: CGFloat = geometry.size.width / 5
                                    if value.translation.width > dragThreshold {
                                        activeIndex = max(activeIndex - 1, 0)
                                    } else if value.translation.width < -dragThreshold {
                                        activeIndex = min(activeIndex + 1, movies.count - 1)
                                    }
                                    dragOffset = 0
                                }
                            }
                    )
                    
                    HStack(spacing: 7) {
                        ForEach(0..<movies.count, id: \.self) { index in
                            Circle()
                                .fill(activeIndex == index ? Color.primary : Color.gray)
                                .frame(width: 7, height: 7)
                        }
                    }
                    .padding(.top, 32)
                }
                .frame(width: geometry.size.width)
            }
        }
        .padding(.horizontal, 20)
    }
    
    private func getOffset(index: Int, geometry: GeometryProxy) -> CGFloat {
        let itemWidth = geometry.size.width
        let offset = CGFloat(index - activeIndex) * itemWidth + dragOffset
        return offset
    }
    
    private func getScale(index: Int) -> CGFloat {
        let scale: CGFloat = activeIndex == index ? 1 : 0.86
        return scale
    }
    
    private func getOpacity(index: Int) -> Double {
        let opacity: Double = activeIndex == index ? 1 : 0
        return opacity
    }
}
