

import SwiftUI

struct UserDescriptionView: View {
    
    let user: User
    
    var body: some View {
        
        ZStack(alignment: .topLeading) {
            ZStack(alignment: .center) {
                Circle()
                    .foregroundStyle(Color.white)
                    .frame(width: 100, height: 100)
                
        
                Image(systemName: "cat.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(10)
                    .frame(width: 95, height: 95)
                    .background(Color.yellow)
                    .clipShape(Circle())
            }
            .padding(.horizontal, 15)
            .padding(.top, 105)
            .zIndex(1)
            VStack {
                ZStack(alignment: .topLeading) {
                    Image("avatar")
                        .resizable()
                        .frame(width: 363, height: 150)
                        .background(Color.yellow)
                        .clipShape(.rect(
                            topLeadingRadius: 20,
                            bottomLeadingRadius: 0,
                            bottomTrailingRadius: 0,
                            topTrailingRadius: 20
                        ))
                    Image(systemName: "chevron.backward.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding([.leading, .top], 10)
                }
                
                //Avatar
            
                VStack(alignment: .leading) {
                    
                    HStack(spacing: 0) {
                        Text("Emilia Lin")
                            .lineLimit(1)
                            .foregroundColor(.black)
                            .font(.custom("Montserrat-SemiBold", size: 20))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(width: 194)
                            
                        Image(systemName: "pencil")
                            .resizable()
                            .frame(width: 20, height:   20)
                            .padding(.trailing, 15)
                    }
                    
                    Text("@emilialian")
                        .lineLimit(1)
                        .foregroundColor(Color(red: 132 / 255, green: 132 / 255, blue: 132 / 255))
                        .font(.custom("Montserrat-Regular", size: 12))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(width: 180)
                        .padding(.leading, 3)
                }
                .padding(.top, 15)
                .padding(.leading, 130)
                
                RoundedRectangle(cornerRadius: 10)
                        .fill(Color(red: 235 / 255, green: 235 / 255, blue: 235 / 255))
                        .frame(width: 333, height: 1, alignment: .center)
                        .padding(.top, 16)
                
                
                
                VStack {
                    HStack(spacing: 3) {
                        Image(systemName: "location")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color(red: 132 / 255, green: 132 / 255, blue: 132 / 255))
                        
                        Text("Moscow")
                            .lineLimit(1)
                            .foregroundColor(Color(red: 132 / 255, green: 132 / 255, blue: 132 / 255))
                            .font(.custom("Montserrat-Regular", size: 14))
                            .frame(width: 90, alignment: .leading)
                        
                        
                        Image(systemName: "birthday.cake")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color(red: 132 / 255, green: 132 / 255, blue: 132 / 255))
                        Text("21.01.2004")
                            .lineLimit(1)
                            .foregroundColor(Color(red: 132 / 255, green: 132 / 255, blue: 132 / 255))
                            .font(.custom("Montserrat-Regular", size: 14))
                            .frame(width: 70)

                    }
                    .frame(width: 200, height: 20)
                    .padding(.leading, 15)
                    .padding(.trailing, 151)
                    HStack(spacing: 3) {
                        Image(systemName: "figure.dress.line.vertical.figure")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color(red: 132 / 255, green: 132 / 255, blue: 132 / 255))
                        
                        Text("Женский")
                            .lineLimit(1)
                            .foregroundColor(Color(red: 132 / 255, green: 132 / 255, blue: 132 / 255))
                            .font(.custom("Montserrat-Regular", size: 14))
                            .frame(width: 90, alignment: .leading)
                        
                        
                        Image(systemName: "calendar")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color(red: 132 / 255, green: 132 / 255, blue: 132 / 255))
                        Text("21.01.2025")
                            .lineLimit(1)
                            .foregroundColor(Color(red: 132 / 255, green: 132 / 255, blue: 132 / 255))
                            .font(.custom("Montserrat-Regular", size: 14))
                            .frame(width: 70)
                        

                    }
                    .frame(width: 200, height: 20)
                    .padding(.leading, 15)
                    .padding(.trailing, 151)
                }
                .frame(width: 200, height: 20)
                .padding(.top, 15)
                .padding(.leading, 15)
                RoundedRectangle(cornerRadius: 10)
                        .fill(Color(red: 235 / 255, green: 235 / 255, blue: 235 / 255))
                        .frame(width: 333, height: 1, alignment: .center)
                        .padding(.top, 16)
                VStack(alignment: .leading, spacing: 0) {
                    Text("О себе")
                        .foregroundColor(Color(red: 132 / 255, green: 132 / 255, blue: 132 / 255))
                        .font(.custom("Montserrat-SemiBold", size: 20))
                    Text("Привет! Я Анна, и я увлечена изучением новых технологий и программирования. В данный момент я занимаюсь разработкой проектов в области искусственного интеллекта и ищу напарника для совместного изучения и обмена знаниями. Мне нравится работать в команде, обсуждать идеи и находить креативные решения.")
                        .foregroundColor(Color(red: 132 / 255, green: 132 / 255, blue: 132 / 255))
                        .font(.custom("Montserrat-Regular", size: 14))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(width: 333, height: 181)
                
                RoundedRectangle(cornerRadius: 10)
                        .fill(Color(red: 235 / 255, green: 235 / 255, blue: 235 / 255))
                        .frame(width: 333, height: 1, alignment: .center)
                        .padding(.top, 16)
                
                HStack {
                    Image(systemName: "paperplane.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(Color(red: 132 / 255, green: 132 / 255, blue: 132 / 255))
                        .padding(.trailing, 10)
                    Image(systemName: "book")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(Color(red: 132 / 255, green: 132 / 255, blue: 132 / 255))
                        .padding(.trailing, 10)
                    Image(systemName: "phone.circle")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(Color(red: 132 / 255, green: 132 / 255, blue: 132 / 255))
                        .padding(.trailing, 10)
                    Image(systemName: "envelope")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(Color(red: 132 / 255, green: 132 / 255, blue: 132 / 255))
                }
                .offset(x: -85)
                .padding(.bottom, 15)
                
            }
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .frame(width: 363, height: 571)
    }
}


