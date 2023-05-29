

import SwiftUI
import Alamofire

/**
 
 - Author:
 Valtteri Havula
 
 - Version:
 1.0
 */

/// This view displays user specific information and gives the option to delete the user.
struct UserView: View {
    /// The user whose information is displayed.
    let user: User
    /// Boolean to check wether or not the user currently displayed is deleted.
    @State var isDeleted = false
    /// Dismiss out of the stack. Used in case user is deleted.
    @Environment(\.dismiss) private var dismiss
    
    /// Sends a DELETE request to the dummyjson backend for a user specified by id.
    /// - Parameter id: id of the targeted user.
    func deleteUser(id: Int) {
        let url = "https://dummyjson.com/users/\(id)"
        AF.request(url, method: .delete)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    isDeleted = true
                    print("Success: \(value)")
                case .failure(let error):
                    print("Fail: \(error)")
                }
            }
        
    }
    
    var body: some View {
        VStack {
            Text("\(user.firstName) \(user.lastName)").font(.largeTitle)
            Text("\(user.phone)")
            Spacer()
            Button(action: {deleteUser(id: user.id)}) {
                Label("Delete", systemImage: "trash")
            }
            Spacer()
        }
        .alert(isPresented: $isDeleted ) {
            Alert(title: Text("Contact succesfully deleted!"),
                  dismissButton: .default(Text("OK")) {dismiss()})
        }
        
    }
}
