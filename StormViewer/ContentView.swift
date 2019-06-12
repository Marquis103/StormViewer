//
//  ContentView.swift
//  StormViewer
//
//  Created by Marquis Dennis on 6/12/19.
//  Copyright © 2019 Marquis Dennis. All rights reserved.
//

import SwiftUI
import Combine

class ImageDataSource: BindableObject {
    let didChange = PassthroughSubject<Void, Never>()
    fileprivate var images = [String]()
    
    init() {
        let fm = FileManager.default
        
        if let path = Bundle.main.resourcePath, let imageItems = try? fm.contentsOfDirectory(atPath: path) {
            for image in imageItems where image.hasPrefix("nssl") {
                images.append(image)
            }
        }
        
        didChange.send(())
    }
}

struct ImageDetailView: View {
    @State private var hidesNavigationBar = false
    var image: String
    
    var body: some View {
        let img = UIImage(named: image)!
        return Image(uiImage: img)
            .resizable()
            .aspectRatio(1024/768, contentMode: .fit)
            .navigationBarTitle(Text(image), displayMode: .inline)
            .navigationBarHidden(hidesNavigationBar)
            .tapAction {
                self.hidesNavigationBar.toggle()
                
        }
    }
}

struct ContentView : View {
    @ObjectBinding var imageDataSource = ImageDataSource()
    
    var body: some View {
        NavigationView {
            List(imageDataSource.images.identified(by: \.self)) { image in
                NavigationButton(destination: ImageDetailView(image: image), isDetail: true) {
                    HStack {
                        Image(uiImage: UIImage(named: image)!)
                            .resizable()
                            .frame(width: 100, height: 100, alignment: .leading)
                            .cornerRadius(50)
                        Text(image)
                    }
                    
                }
                }
                .navigationBarTitle(Text("Storm Viewer"))
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
