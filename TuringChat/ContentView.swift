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
                            ChatBubble(message: msg).background()
                                .frame(maxWidth: .infinity, alignment: msg.isMy ? .trailing :.leading )
                        }
                    }
                }
            }
            .background()
            .frame(maxWidth: .infinity, alignment:  .topLeading)
            HStack(){
                TextField("your turn", text: $message)
                Button("Send") {
                    messages.writeMessage(msg: message)
                }
            }
            .background(Color.black.opacity(0.06))
        }.background()
    }
}

struct Message : Identifiable {
    var id : Date
    var message : String
    var isMy : Bool
}

struct ChatBubble : View {
    var message : Message
    var body: some View {
        Text(message.message)
    }
}
class Messages : ObservableObject {
    @Published var messages : [Message] = []

    init() {
        let sampleMessages : [String] = ["Hi", "Hello"]
        for (index, sample) in sampleMessages.enumerated() {
            messages.append(Message(id: Date(), message: sample, isMy: index % 2 == 0))
        }
    }


    func writeMessage(msg: String) {
        messages.append(Message(id: Date(), message: msg, isMy: true))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
