//
//  AddView.swift
//  MapAndContacts
//
//  Created by AnonymFromInternet on 20.09.21.
//

import SwiftUI

import MapKit

struct AddView: View {
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode
    
    @FetchRequest(entity: User1.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \User1.name, ascending: true)]) var users: FetchedResults<User1>
    
    
    @State private var inputImage: UIImage?
    @State private var image: Image?
    @State private var isImagePicker = false
    @State private var selectedPlace: CodableMKPointAnnotation?
    @State private var name = ""
    @State private var textEditorDescription = ""
    @State private var isALertShowing = false
    @State private var isviewForMapShowing = false
    @State var user: User1?
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                ZStack {
                    if image != nil {
                        image?
                            .resizable()
                            .scaledToFit()
                    } else {
                        Image("add contact")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(9)
                            .opacity(0.4)
                            .padding()
                        Button(action: {
                            self.isImagePicker = true
                            
                        }, label: {
                            Text("Tap here and choose a Photo from Your Library")
                                .foregroundColor(.black)
                                
                                .font(.headline)
                                .padding()
                                .multilineTextAlignment(.center)
                        })
                    }
                }
                .sheet(isPresented: $isImagePicker,onDismiss: imageConversion, content: {
                    ImagePicker(image: $inputImage)
                })
                
                VStack {
                    Form {
                        
                        TextField("Enter a Name", text: $name)
                        Section(header: Text("Decription")) {
                            TextEditor(text: $textEditorDescription)
                        }
                        ZStack {
                            Color(#colorLiteral(red: 1, green: 0.5882352941, blue: 0.6784313725, alpha: 1))
                                .frame(height: 65)
                                .cornerRadius(9)
                            Button(action: {
                                self.isviewForMapShowing = true
                                
                            }, label: {
                                Text("Tap to choose your current location")
                                    .foregroundColor(Color(#colorLiteral(red: 0.9626982025, green: 1, blue: 0.07946851188, alpha: 1)))
                            })
                        }
                    }
                }
            }
            .alert(isPresented: $isALertShowing, content: {
                Alert(title: Text("Please choose a Photo"), dismissButton: .default(Text("Ok")))
                
            })
            .sheet(isPresented: $isviewForMapShowing, content: {
                ViewForMap(isThisViewShowing: true, user: $user).environment(\.managedObjectContext, self.context)
            })
            .navigationBarTitle(Text("Add new Contact"))
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Back to the contacts")
            }), trailing: Button(action: {
                
                if image == Image("add contact") || image == nil {
                    self.isALertShowing = true
                    return
                }
                
                let newUser = User1(context: self.context)
                newUser.name = name
                newUser.aboutUser = textEditorDescription
                
                if let jpedData = inputImage?.jpegData(compressionQuality: 1) {
                    newUser.image = jpedData
                    try? self.context.save()
                }
                
                if user?.location != nil {
                    
                    newUser.location = user?.location
                    try? self.context.save()
                }
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Save new Contact")
                    .foregroundColor(Color(#colorLiteral(red: 1, green: 0.5882352941, blue: 0.6784313725, alpha: 1)))
            }))
        }
        
    }
    
    func imageConversion() {
        
        guard inputImage != nil else { return }
        
        let convertedImage = Image(uiImage: inputImage!)
        image = convertedImage
        
    }
    
    
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(user: User1())
    }
}
