
//  MainView.swift
//  ProtoApp
//
//  Created by Valtteri Havula on 8.5.2023.
//


import SwiftUI
import Alamofire


/// This struct represents the main view of this application. It fetches users to display in a List of NavigationLinks.
struct MainView: View {
    /// Array of Users displayed in the UI as a List.
    @State var people: Array<User>? = nil
    /// User inputted searchWord that is used to fetch specific users by name from the backend.
    @State private var searchWord: String = ""
    
    
    /// Attempts to fetch users from the dummyjson API.
    /// - Parameter searchWord: Optional search keyword to fetch users by name.
    func fetchUsers(searchWord: String?) {
        var url = "https://dummyjson.com/users"
        if let keyWord = searchWord {
            url = "https://dummyjson.com/users/search?q=\(keyWord)"
        }
        AF.request(url)
            .responseDecodable(of: HttpResults.self) { response in
                if let result = response.value {
                    self.people = result.users
                } else {return}
            }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Contacts").bold().font(.largeTitle)
                TextField("Search", text: $searchWord)
                    .padding()
                    .onChange(of: searchWord) { newValue in
                        fetchUsers(searchWord: searchWord)
                    }
                if let users = people {
                    NavigationStack {
                        List(users, id: \.id) { user in
                            NavigationLink(destination: UserView(user: user)) {
                                Text("\(user.firstName) \(user.lastName)")
                            }
                        }
                    }
                } else {
                    ProgressView()
                }
            }
            .textFieldStyle(.roundedBorder)
            .onAppear { fetchUsers(searchWord: nil) }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: NewUserView()) {
                        Label("New Contact",systemImage: "plus")
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
