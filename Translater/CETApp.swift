//
//  CETApp.swift
//  CodeEditorTranslater
//
//  Created by qiancheng on 2023/3/30.
//

import SwiftUI

@main
struct CETApp: App {
    var body: some Scene {
        WindowGroup {
            CETAppView()
                .frame(idealWidth: 600)
                .fixedSize(horizontal: true, vertical: false)
        }
    }
}
