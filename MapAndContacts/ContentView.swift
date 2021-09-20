//
//  ContentView.swift
//  MapAndContacts
//
//  Created by AnonymFromInternet on 20.09.21.
//

import SwiftUI


import LocalAuthentication

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(entity: User1.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \User1.name, ascending: true)]) var users: FetchedResults<User1>
    
    
    
    //MARK:- Property for .sheet
    @State private var isSheetActive = false
    //MARK:-
    
    @State private var isAuthentificate = false
    
    
    
    var body: some View {
        
        if !isAuthentificate {
            AuthentificationView()
                .onTapGesture {
                    self.authentificate()
                }
            
        } else {
            NavigationView {
                
                List {
                    ForEach(users, id: \.name) { user in
                        NavigationLink(
                            destination: DetailView(user: user),
                            label: {
                                ContactsPreview(data: user.image!)
                                Text(user.name ?? "Unknown name")
                                    .font(.headline)
                            })
                        
                    }
                    .onDelete(perform: deleteContact )
                }
                
                .navigationBarTitle(Text("Your Contacts"))
                .navigationBarItems(trailing: Button(action: {
                    self.isSheetActive = true
                }, label: {
                    Text("Add New Contact")
                        .foregroundColor(Color(#colorLiteral(red: 1, green: 0.5882352941, blue: 0.6784313725, alpha: 1)))
                }))
                
            }
            .sheet(isPresented: $isSheetActive, content: {
                AddView().environment(\.managedObjectContext, self.context)
            })
        }
    }
    
    func deleteContact(at offsets: IndexSet) {
        for offset in offsets {
            let user = users[offset]
            context.delete(user)
        }
        try? self.context.save()
    }
    
    func authentificate() {
        let context = LAContext()
        var error: NSError?
        
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authentificate yourself"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {authentification, error in
                DispatchQueue.main.async {
                    if authentification {
                        self.isAuthentificate = true
                    } else {
                        //error
                        
                        print(error?.localizedDescription ?? "Unknown error")
                    }
                }
                
            }
        } else {
            // no biometrics
            print(error?.localizedDescription ?? "Unknown error")
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
