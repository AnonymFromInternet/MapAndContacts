//
//  ContactsPreview.swift
//  MapAndContacts
//
//  Created by AnonymFromInternet on 20.09.21.
//

import SwiftUI

struct ContactsPreview: View {
    
    var data: Data
    
    var image: Image {
        let uiImage = UIImage(data: data)
        let convertedImage = Image(uiImage: uiImage!)
        return convertedImage
    }
    
    var body: some View {
       image
        .resizable()
        .frame(width: 65, height: 65)
        .cornerRadius(9)
        .overlay(
            RoundedRectangle(cornerRadius: 9).stroke(Color.red, lineWidth: 1))
    }
}

struct ContactsPreview_Previews: PreviewProvider {
    static var previews: some View {
        ContactsPreview(data: Data())
    }
}
