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
                TextField("", text: $message)
                Button("发送") {
                    messages.writeMessage(msg: message)
                    getResponse(msg: message) { receivedMsg in
                        messages.writeMessage(msg: receivedMsg, isMy: false)
                    }

                }
            }
            .background(Color.black.opacity(0.06))
        }.background()
    }
}

func getResponse(msg: String, receivedHandler: @escaping (String) -> Void) {

    let root = "http://api.qingyunke.com"
    let path = "/api.php"
    var urlcomps = URLComponents(string: root)!
    urlcomps.path = path
    urlcomps.queryItems = [URLQueryItem(name: "key", value: "free"), URLQueryItem(name: "appid", value: String(0)), URLQueryItem(name: "msg", value: msg)]
    let url = urlcomps.url!

    URLSession.shared.dataTask(with: url) {(data, response, error) in
        guard let data = data, error == nil else { return }
        guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
            return
        }
        do {
            let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

            let result = jsonResponse?["content"] as? String ?? "好像出了一些问题"
            receivedHandler(result)
        } catch {
            print(error)
        }
    }.resume()
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
        let sampleMessages : [String] = []
        for (index, sample) in sampleMessages.enumerated() {
            messages.append(Message(id: Date(), message: sample, isMy: index % 2 == 0))
        }
    }


    func writeMessage(msg: String, isMy: Bool = true) {
        messages.append(Message(id: Date(), message: msg, isMy: isMy))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
