//
//  DiscoverView.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 10.07.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct DiscoverView: View {
    @EnvironmentObject var viewModel: DiscoverViewModel
    @State private var showingProgressView = true
    
    var body: some View {
        VStack{
            if showingProgressView {
                Spacer()
                ProgressView()
                Spacer()
            } else {
                ZStack{
                    if viewModel.fetchedMovies.isEmpty{
                        Text("There is no movie")
                            .font(.caption)
                            .foregroundColor(.gray)
                    } else{
                        ForEach(viewModel.fetchedMovies.reversed()) { movie in
                            StackCardView(movie: movie)
                                .environmentObject(viewModel)
                        }
                    }
                }.padding(.top, 30)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                //Action Buttons
                HStack(spacing: 15){
                    
                    Button{
                        getPrevious()
                    } label: {
                        Image(systemName: "arrow.uturn.backward")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                            .padding(13)
                            .background(.gray)
                            .clipShape(Circle())
                    }.disabled(viewModel.removedMovies.isEmpty)
                        .opacity((viewModel.removedMovies.isEmpty) ? 0.6 : 1)
                    
                    HStack{
                        Button{
                            
                        } label: {
                            Image(systemName: "bookmark")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                                .shadow(radius: 5)
                                .padding(13)
                                .background(.green)
                                .clipShape(Circle())
                        }
                        
                        Button{
                            
                        } label: {
                            Image(systemName: "star")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                                .shadow(radius: 5)
                                .padding(13)
                                .background(.yellow)
                                .clipShape(Circle())
                        }
                        
                        Button{
                            
                        } label: {
                            Image(systemName: "checkmark.seal")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                                .shadow(radius: 5)
                                .padding(13)
                                .background(.red)
                                .clipShape(Circle())
                        }
                    }
                    .disabled(viewModel.fetchedMovies.isEmpty)
                    .opacity((viewModel.fetchedMovies.isEmpty) ? 0.6 : 1)
                    
                }.padding(.bottom)
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    showingProgressView = false
                }
            }
    }
    
    func getPrevious() {
        guard !viewModel.removedMovies.isEmpty else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            withAnimation {
                viewModel.fetchedMovies.insert(viewModel.removedMovies[viewModel.removedMovies.count - 1], at: 0)
            }
            viewModel.removedMovies.removeLast()
        }
        
        
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}


struct StackCardView: View {
    @EnvironmentObject var viewModel: DiscoverViewModel
    var movie: Movie
    
    @State var offset = CGFloat(0)
    @GestureState var isDragging = false
    @State var endSwipe = false
    
    var body: some View {
        
        GeometryReader{ proxy in
            let size = proxy.size
            let index = viewModel.getIndex(movie: movie)
            let topOffset = (index <= 3 ? index : 2) * 15
            
            ZStack {
                let url = URL(string: ApiRoutes.imageURL(posterPath: movie.posterPath ?? ""))
                
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: size.width - CGFloat(topOffset), height: size.height + 15)
                    .foregroundColor(Color(
                        red: Double((0x303030 & 0xFF0000) >> 16) / 255.0,
                        green: Double((0x303030 & 0x00FF00) >> 8) / 255.0,
                        blue: Double(0x303030 & 0x0000FF) / 255.0
                    ))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.white, lineWidth: 2)
                    )
                
                VStack {
                    WebImage(url: url)
                        .resizable()
                        .shadow(radius: 50)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width - CGFloat(topOffset) - 20, height: size.height - 60)
                        .cornerRadius(10)
                        .padding(.top)
                        .onTapGesture {
                            navigateToDetailScreen()
                        }
                    Spacer()
                }
                
                
                VStack(alignment: .leading) {
                    Spacer()
                    
                    Text(movie.title ?? "")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .lineLimit(1)
                    
                    HStack {
                        HStack{
                            ForEach(0..<5) { index in
                                Image(systemName: "star.fill")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(index <= Int((movie.voteAverage ?? 0) / 2) ? .yellow : .gray)
                                    .shadow(radius: 5)
                            }
                            
                            Text(String(movie.voteAverage ?? 0))
                                .font(.system(size: 13))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        HStack{
                            Image(systemName: "calendar.badge.clock")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.gray)
                                .shadow(radius: 5)
                            
                            Text(movie.releaseDate ?? "N/A")
                                .font(.system(size: 14))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }.padding(.horizontal)
                        .padding(.bottom, 2)
                    
                }
                .frame(maxWidth: .infinity, alignment: .bottom)
                .padding(.bottom, 5)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .offset(y: -CGFloat(topOffset))
            
            
        }.contentShape(Rectangle().trim(from: 0, to: endSwipe ? 0 : 1))
            .offset(x: offset)
            .rotationEffect(.init(degrees: getRotation(angle: 8)))
            .gesture(
                DragGesture()
                    .updating($isDragging, body: { value, out, _ in
                        out = true
                    }).onChanged({ value in
                        let translation = value.translation.width
                        offset = (isDragging ? translation : .zero)
                    }).onEnded({ value in
                        let width = UIScreen.main.bounds.width - 50
                        let translation = value.translation.width
                        
                        let checkingStatus = (translation > 0 ? translation : -translation)
                        
                        withAnimation {
                            if checkingStatus > (width / 2){
                                offset = (translation > 0 ? width : -width) * 2
                                endSwipeActions()
                            } else{
                                offset = .zero
                            }
                        }
                    })
            )
        
    }
    
    func getRotation(angle: Double) -> Double{
        return (offset / (UIScreen.main.bounds.width - 50)) * angle
    }
    
    func endSwipeActions() {
        withAnimation(.none) {
            endSwipe = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            if let removedMovie = viewModel.fetchedMovies.first{
                let _ = withAnimation {
                    viewModel.fetchedMovies.removeFirst()
                    viewModel.removedMovies.append(removedMovie)
                }
            }
        }
        
        if viewModel.fetchedMovies.count <= 5 && viewModel.shouldDownloadMore {
            viewModel.getDiscoverMovies()
        }
    }
    
    func navigateToDetailScreen() {
        if let movieId = movie.id {
            viewModel.navigateToDetailScreen(with: movieId)
        }
    }
    
}
