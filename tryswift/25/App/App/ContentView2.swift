import SwiftUI

struct ContentView2: View {
    var body: some View {
        VStack {
            TextField("", text: .constant("---"))
            Spacer()
            HStack {
                HStack {
                    Text("You make my everyday so special.")
                        .font(.body)
                    Image(._032)
                        .resizable()
                        .frame(width: 24, height: 24)
                    RoundedRectangle(cornerRadius: 4)
                        .frame(width: 3, height: 24)
                        .foregroundStyle(.blue)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .overlay {
                    Capsule()
                        .strokeBorder(style: .init(lineWidth: 1))
                        .foregroundStyle(.separator)
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "arrow.up")
                        .foregroundStyle(.white)
                        .bold()
                        .padding(10)
                        .background(Color.blue)
                        .mask(Circle())
                }
            }.padding(.bottom, 8)
        }
    }
}

#Preview {
    ContentView()
}
