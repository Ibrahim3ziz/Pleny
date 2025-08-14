//
//  HomeView.swift
//  Pleny
//
//  Created by Ibrahim Abdul Aziz on 28/06/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var selectedImage: String? = nil
    @State private var isImageViewerPresented = false
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    var body: some View {
        ZStack {
            VStack {
                CustomNavBar(searchText: $viewModel.searchText) {
                    viewModel.isSearching = true // start searching
                } cancelAction: {
                    viewModel.isSearching = false // close the textfield, stop searching
                }
                
                if viewModel.isLoading {
                    
                    Spacer()
                    
                } else if let error = viewModel.error {
                    Text(error.localizedDescription)
                        .padding()
                    Spacer()
                } else {
                    List(viewModel.posts, id: \.id) { post in
                        PostView(username: "Neama Ahmed", date: "2 days ago", profileImage: "static-profile-image", post: post.title, postImages: ["static-post-image", "static-post-image", "static-post-image", "static-post-image", "static-post-image"]) {
                            selectedImage = "static-profile-image"
                            isImageViewerPresented = true
                        } postImageAction: {
                            selectedImage = "static-post-image"
                            isImageViewerPresented = true
                        }
                    }
                    .listStyle(.plain)
                    .background(.white)
                }
            }
            
            // Centered loading overlay
            if viewModel.isLoading {
                Color.black.opacity(0.1).ignoresSafeArea()
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 4)
            }
            
            if let imageName = selectedImage, isImageViewerPresented {
                ImagePreview(imageName: imageName, isPresented: $isImageViewerPresented)
            }
        }
        .onAppear {
            viewModel.getPosts()
        }
        .onChange(of: networkMonitor.status) { newStatus in
            switch newStatus {
            case .connected:
                print("Switched to online mode")
                viewModel.getPosts()
            case .disconnected:
                print("Switched to offline mode")
                viewModel.fetchCachedPosts()
            }
        }
        .background(Color.white)
    }
}

#Preview {
    HomeView()
}
