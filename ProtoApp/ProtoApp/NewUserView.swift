

import SwiftUI
import Alamofire

/**
 
 - Author:
 Valtteri Havula
 
 - Version:
 1.0
 */

/// View to add new users
struct NewUserView: View {
    /// User inputted name that will be sent in the addUser() function's POST request.
    @State var firstName: String = ""
    /// User inputted name that will be sent in the addUser() function's POST request.
    @State var lastName: String = ""
    /// Changed to true if the addUser() func was successful.
    @State var isSuccess: Bool = false
    /// Changed to true if user inputs invalid names and tries to use the addUser() function.
    @State var showAlert: Bool = false
    /// Information of the new user returned by the POST request is stored in this variable.
    @State var addedUser: NewUser? = nil
    
    /// Attempt an Alamofire POST request with the user inputted names as the parameters.
    func addUser() {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        let parameters: [String: Any] = ["firstName": firstName, "lastName": lastName]
        //Check that at least one name isn't an empty String
        if (firstName.isEmpty && lastName.isEmpty) {
            showAlert = true
            return
        }
        // Start the request
        AF.request("https://dummyjson.com/users/add",
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default, headers: headers)
        .responseDecodable(of: NewUser.self) { response in
            switch response.result {
            case .success(let user):
                addedUser = NewUser(firstName: user.firstName, lastName: user.lastName)
                isSuccess = true
                print("Added user: \(user)")
            case let .failure(error):
                isSuccess = false
                print("Failed to add user: \(error)")
            }
        }
        
    }
    
    var body: some View {
        Text("New Contact").font(.largeTitle).bold()
        Spacer()
        VStack {
            TextField("First Name", text: $firstName)
            TextField("Last Name", text: $lastName)
            Button(action: addUser) {
                Label("Save", systemImage: "plus")
            }
            .alert(isPresented: $showAlert ) {
                Alert(title: Text("Error"),
                      message: Text("Please enter a first and last name"),
                      dismissButton: .default(Text("OK")))
            }
            if isSuccess {
                Text("User \(addedUser!.firstName) \(addedUser!.lastName) added succesfully!")
            }
        }
        .textFieldStyle(.roundedBorder)
        Spacer()
        Spacer()
    }
}
