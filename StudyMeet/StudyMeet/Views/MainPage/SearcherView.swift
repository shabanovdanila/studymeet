import SwiftUI

struct SearcherView: View {
    
    @Binding var searchText: String
    
    var body: some View {
        HStack(spacing: 0) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color.white)
                    .frame(width: 18, height: 18)
                    .padding(9)
                    .background(Color(red: 59 / 255, green: 130 / 255, blue: 246 / 255))
                    .clipShape(Circle())
                    .padding(2)
                
                TextField("Поиск...", text: $searchText)
                    .foregroundColor(Color(red: 122 / 255, green: 122 / 255, blue: 122 / 255))
                    .font(.custom("Montserrat-Regular", size: 16))
                    .disableAutocorrection(true)
                    .overlay(
                        Image(systemName: "xmark.circle.fill")
                            .padding()
                            .offset(x: 10)
                            .foregroundColor(Color(red: 59 / 255, green: 130 / 255, blue: 246 / 255))
                            .opacity(searchText.isEmpty ? 0.0 : 1.0)
                            .onTapGesture {
                                UIApplication.shared.endEditing()
                                searchText = ""
                            }
                        ,alignment: .trailing)
            }
            .background(Color.white)
            .frame(width: 308, height: 40)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(Color(red: 235 / 255, green: 235 / 255, blue: 235 / 255), lineWidth: 1)
            }
         
            Image(systemName: "paintbrush")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color.white)
                .frame(width: 23, height: 23)
                .padding(7)
                .background(Color(red: 59 / 255, green: 130 / 255, blue: 246 / 255))
                .clipShape(Circle())
                .padding(.leading, 15)
            
        }
    }
}
