//
//  AuthentificationView.swift
//  MapAndContacts
//
//  Created by AnonymFromInternet on 20.09.21.
//

import SwiftUI

struct AuthentificationView: View {
    var body: some View {
        ZStack {
            HStack {
                Text("Please tap for Authentification")
                    .font(.headline)
                    .foregroundColor(Color(#colorLiteral(red: 0.9626982025, green: 1, blue: 0.07946851188, alpha: 1)))
                
            }
            .frame(height: 140)
            .frame(maxWidth: .infinity)
            .background(Color(#colorLiteral(red: 1, green: 0.5882352941, blue: 0.6784313725, alpha: 1)))
            .cornerRadius(9)
            .padding(.horizontal)
            .shadow(radius: 36)
        }
    }
}

struct AuthentificationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthentificationView()
    }
}
