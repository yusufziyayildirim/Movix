//
//  DiscoverView.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 10.07.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct DiscoverView: View {
    @StateObject var viewModel = DiscoverViewModel(service: MovieService())
    
    var body: some View {
        VStack{
            ZStack{
                //Movies section
                if viewModel.fetchedMovies.isEmpty{
                    Text("There is no movie")
                        .font(.caption)
                        .foregroundColor(.gray)
                } else{
                    //Displaying cards
                    ForEach(viewModel.fetchedMovies.reversed()) { movie in
                        StackCardView(movie: movie)
                            .environmentObject(viewModel)
                    }
                }
            }.padding(.top, 30)
                .padding()
                .padding(.vertical)
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
                }
                
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
                        Image(systemName: "star.fill")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                            .padding(13)
                            .background(.yellow)
                            .clipShape(Circle())
                    }
                    
                    Button{
                        
                    } label: {
                        Image(systemName: "suit.heart.fill")
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
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .onAppear {
                viewModel.getDiscoverMovies()
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
            ZStack{
                let url = URL(string: ApiRoutes.imageURL(posterPath: movie.posterPath ?? ""))
                WebImage(url: url)
                    .resizable()
                    .shadow(radius: 50)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width - CGFloat(topOffset), height: size.height)
                    .cornerRadius(15)
                    .offset(y: -CGFloat(topOffset))
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            
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
    
}
