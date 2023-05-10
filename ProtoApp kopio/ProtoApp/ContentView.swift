//
//  ContentView.swift
//  ProtoApp
//
//  Created by Valtteri Havula on 8.5.2023.
//

import SwiftUI
import Alamofire



struct HttpResults: Codable {
    let users: [User]
}

struct User: Codable {
    let id: Int
    let firstName: String
    let lastName: String
}

struct ContentView: View {
    @State var people: Array<User>? = nil
    
    func fetchUsers() {
        AF.request("https://dummyjson.com/users")
            .responseDecodable(of: HttpResults.self) { response in
            if let result = response.value {
                self.people = result.users
                debugPrint(result)
            } else {return}
        }
    }
    
    var body: some View {
        VStack {
            if let users = people {
                List(users, id: \.id) {
                    Text("\($0.firstName) \($0.lastName)")
                }
            } else {
                ProgressView()
            }
            Button("Fetch users", action: { fetchUsers() })
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
