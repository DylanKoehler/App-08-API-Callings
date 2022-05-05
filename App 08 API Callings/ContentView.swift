//
//  ContentView.swift
//  App 08 API Callings
//
//  Created by Dylan Koehler on 2/3/22.
//

import SwiftUI

struct ContentView: View {
    @State private var cornDogs = [CornDog]()
    @State private var showingAlert = false
    var body: some View {
        NavigationView {
            List(cornDogs){ cornDog in
                Link(destination: URL(string: cornDog.link)!, label: {
                    Text(cornDog.title)
                })
            }
            .navigationTitle("Corn Dogs")
        }
        .onAppear(perform: {
            quearyAPI()
        })
        .alert(isPresented: $showingAlert, content: {
            Alert(title: Text("Loading Error"),
                  message: Text("There was a problem loading the data"),
                  dismissButton: .default(Text("OK")))
        })
    }
    func quearyAPI() {
        let apiKey = "?rapidapi-key=d87dc96880msh138dad116ed364ep17b762jsnfa65120c7d18"
        let query = "https://google-search3.p.rapidapi.com/api/v1/search/q=corn+dog&num=100\(apiKey)"
        if let url = URL(string: query) {
            if let data = try? Data(contentsOf: url) {
                let json = try! JSON(data: data)
                    let contents = json["results"].arrayValue
                    for item in contents {
                        let title = item["title"].stringValue
                        let link = item["link"].stringValue
                        let cornDog = CornDog(link: link, title: title)
                        cornDogs.append(cornDog)
                    }
                    return
            }
        }
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CornDog: Identifiable {
    let id = UUID()
    var link: String
    var title: String
}
