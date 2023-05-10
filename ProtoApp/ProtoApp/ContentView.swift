//
//  ContentView.swift
//  ProtoApp
//
//  Created by Valtteri Havula on 8.5.2023.
//

//TODO:
// Error handling in case fetch fails
// Move structs to own files
// Delete user feature or search feature

import SwiftUI
import Alamofire

struct HttpResults: Codable {
    let users: [User]
}

struct User: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let age: Int
    let gender: String
    let image: String
    let phone: String
}

struct UserView: View {
    let user: User
    var body: some View {
        VStack {
            Text("\(user.firstName) \(user.lastName)").font(.largeTitle)
            Text("\(user.phone)")
            Spacer()
            Text("\(user.age) years old")
            Spacer()
        }
        
    }
}

struct NewUser: Codable {
    let firstName: String
    let lastName: String
}

//View to add new users
struct NewUserView: View {
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var showResult: Bool = false
    @State var showAlert: Bool = false
    @State var addedUser: NewUser? = nil
    
    //Attempt POST request
    func addUser() {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        let parameters: [String: Any] = ["firstName": firstName, "lastName": lastName]
        if (firstName.isEmpty || lastName.isEmpty) {
            showAlert = true
            return
        }
        AF.request("https://dummyjson.com/users/add",
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default, headers: headers)
        .responseDecodable(of: NewUser.self) { response in
            switch response.result {
            case .success(let user):
                print("Added user: \(user)")
                addedUser = NewUser(firstName: user.firstName, lastName: user.lastName)
                showResult = true
            case let .failure(error):
                print("Failed to add user: \(error)")
            }
        }
        
    }
    
    var body: some View {
        Text("Add new users").font(.largeTitle).bold()
        Spacer()
        VStack {
            TextField("First Name", text: $firstName)
            TextField("Last Name", text: $lastName)
            Button(action: addUser) {
                Label("Add User", systemImage: "plus")
            }
            .alert(isPresented: $showAlert ) {
                Alert(title: Text("Error"),
                      message: Text("Please enter a first and last name"),
                      dismissButton: .default(Text("OK")))
            }
            if showResult {
                Text("User \(addedUser!.firstName) added succesfully!")
            }
        }
        .textFieldStyle(.roundedBorder)
        Spacer()
    }
}

struct ContentView: View {
    @State var people: Array<User>? = nil
    
    //Attempt to fetch all users from API
    func fetchUsers() {
        AF.request("https://dummyjson.com/users")
            .responseDecodable(of: HttpResults.self) { response in
                if let result = response.value {
                    self.people = result.users
                } else {return}
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Users").bold().font(.largeTitle)
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
            .onAppear { fetchUsers() }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Search")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: NewUserView()) {
                        Text("Add new user")
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
