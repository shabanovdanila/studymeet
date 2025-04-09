
import SwiftUI

struct TopBarView: View {
    @Binding var isLogin: Bool
    
    //TODO
    //check is correct realiz
    @Binding var isInUserPageView: Bool
    
    
    var body: some View {
        HStack {
            (Text("Study")
                .foregroundColor(Color(red: 30 / 255, green: 58 / 255, blue: 138 / 255))
                .font(.custom("MontserratAlternates-Bold", size: 20))
             + Text("Meet")
                .foregroundColor(Color(red: 59 / 255, green: 130 / 255, blue: 246 / 255))
                .font(.custom("MontserratAlternates-Bold", size: 20)))
            .padding([.bottom, .top], 10)
            .padding(.leading, 15)
            Spacer()
            
            if !isLogin {
                Text("Войти")
                    .foregroundColor(Color(red: 30 / 255, green: 58 / 255, blue: 138 / 255))
                    .font(.custom("Montserrat-Medium", size: 16))
                    .padding([.bottom, .top], 13)
                    .padding(.horizontal, 15)
            } else {
                HStack {
                    Group {
                        Image(systemName: "plus")
                            .resizable()
                            .foregroundColor(Color(red: 30 / 255, green: 58 / 255, blue: 138 / 255))
                            .frame(width: 25, height: 25)
                        Image(systemName: "bell")
                            .resizable()
                            .foregroundColor(Color(red: 30 / 255, green: 58 / 255, blue: 138 / 255))
                            .frame(width: 25, height: 25)
                        
                        if isInUserPageView {
                            Button {
                                print(111111)
                                isInUserPageView = true
                            } label : {
                                Image(systemName: "cat.fill")
                                    .resizable()
                                    .padding(3)
                                    .frame(width: 25, height: 25)
                                    .background(Color.yellow)
                                    .clipShape(Circle())
                            }
                        }
                        else {
                            NavigationLink(destination: UserPageView().navigationBarBackButtonHidden(true)) {
                                Image(systemName: "cat.fill")
                                    .resizable()
                                    .padding(3)
                                    .frame(width: 25, height: 25)
                                    .background(Color.yellow)
                                    .clipShape(Circle())
                            }
                        }                    }
                    .padding(.trailing, 15)
                }
                .padding([.bottom, .top], 10)
            }
        }
        .frame(width: 393, height: 50)
    }
}
