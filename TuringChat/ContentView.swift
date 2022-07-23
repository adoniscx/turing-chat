//
//  ContentView.swift
//  TuringChat
//
//  Created by xu cao on 2022/7/22.
//

import SwiftUI

struct ContentView: View {

    @State var message = ""
    @StateObject var messages = Messages()

    var body: some View {
        VStack{
            ScrollView(.vertical, showsIndicators: false){
                ScrollViewReader { proxy in
                    VStack{
                        ForEach(messages.messages) {msg in
                            ChatBubble(message: msg)
                        }
                    }
                }
            }
            HStack(){
                TextField("your turn", text: $message)
                Button("Send") {
                    messages.writeMessage(msg: message)
                }
            }
            .background(Color.black.opacity(0.06))
        }
    }
}

struct Message : Identifiable {
    var id : Date
    var message : String
}git add README.md

struct ChatBubble : View {
    var message : Message
    var body: some View {
        Text(message.message)
    }
}
class Messages : ObservableObject {
    @Published var messages : [Message] = []

    func writeMessage(msg: String) {
        messages.append(Message(id: Date(), message: msg))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
