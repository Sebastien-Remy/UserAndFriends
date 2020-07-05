//
//  ContentView.swift
//  UserAndFriends
//
//  Created by Sebastien REMY on 05/07/2020.
//  Copyright © 2020 MonkeyDev. All rights reserved.
//

import SwiftUI

struct User: Codable {
    var id: String
    var name: String
    var age: Int
    var company: String
    var friends: [Friend]
}

struct Friend: Codable {
    var id: String
    var name: String
}


struct ContentView: View {
    
    @State private var users = [User]()

    
    var body: some View {
        NavigationView {
            List(users, id: \.id) { user in
                NavigationLink(destination: UserDetail(user: user)) {
                    VStack(alignment: .leading) {
                        Text(user.name)
                            .font(.headline)
                        Text(user.company)
                    }
                }
            }
            .navigationBarTitle("User and Friends")
        }
        .onAppear(perform: loadData)
    }
    
    func loadData() {
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
           if let data = data {
            if let decodedResponse = try? JSONDecoder().decode([User].self, from: data) {
                    // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        // update our UI
                        self.users = decodedResponse
                    }

                    // everything is good, so we can exit
                    return
                } else {
                    print ("Decode response failed")
            }
            }

            // if we're still here it means there was a problem
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
}

struct UserDetail : View {
    var user: User

    var body: some View {
        VStack {
            HStack {
                Text("Company: \(user.company)")
                Spacer()
            }
            HStack {
                Text("Age : \(user.age)")
                Spacer()
            }
            Text("Friends")
            List(user.friends, id: \.id) { friend in
                Text(friend.name)
            }
            Spacer()
        }
        .padding()
        .navigationBarTitle(user.name)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
