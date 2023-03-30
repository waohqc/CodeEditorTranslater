//
//  CETAppView.swift
//  CodeEditorTranslater
//
//  Created by qiancheng on 2023/3/27.
//

import SwiftUI

enum SideBarOption: String {
    case config = "配置"
    case instruct = "说明"
    case about = "关于"
}

struct SideBarItem: Hashable {
    var image: String?
    var option: SideBarOption
}

struct CETAppView: View {
    @State private var selectedItem: SideBarItem = items[0]
    static let items = [
        SideBarItem(image: nil, option: .instruct),
        SideBarItem(image: nil, option: .about)
    ]
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedItem) {
                ForEach(CETAppView.items, id: \.self) { item in
                    HStack {
                        Text(item.option.rawValue)
                    }
                }
            }
        } detail: {
            switch selectedItem.option {
            case .instruct:
                CETInstructView()
            case .about,.config:
                CETAboutView()
            }
        }
    }
}

struct CETInstructView: View {
    var body: some View {
        GeometryReader {
            geo in
            ScrollView {
                VStack(alignment: .leading) {
                    Group {
                        Text("**1.配置CodeEditorTranslater**")
                        Text("- 系统设置中搜索 **扩展**")
                            .instructStyle()
                        Text("- 选择 *Xcode Source Editor*")
                            .instructStyle()
                        Text("- 选择 *CodeEditorTranslater*")
                            .instructStyle()
                        Image("setting_extension")
                            .instructStyle(width: 400, height: 350)
                        Image("setting_extension_more")
                            .instructStyle(width: 400, height: 350)
                    }
                    Spacer(minLength: 20)
                    Group {
                        Text("**2.翻译**")
                        Text("- 代码编辑区选中英文**句子**、**单词**")
                            .instructStyle()
                        Text("- 工具栏选择 *Editor -> CodeEditorTranslater -> EngToCN*")
                            .instructStyle()
                        Image("setting_extension_editor")
                            .instructStyle(width: 400, height: 350)
                    }
                    Spacer(minLength: 20)
                    Group {
                        Text("**3.查看翻译**")
                        Text("- 翻译将会在选中的句子/单词上方以注释形式添加")
                            .instructStyle()
                        Image("setting_extension_trans")
                            .instructStyle(width: 300, height: 90)
                        Image("setting_extension_trans_word")
                            .instructStyle(width: 300, height: 90)
                    }
                    Spacer(minLength: 20)
                    Group {
                        Text("**4.为CodeEditorTranslater配置快捷键**")
                        Text("- 选择 *Xcode -> Settings*")
                            .instructStyle()
                        Text("- 选择 *Key Bindings*")
                            .instructStyle()
                        Text("- 搜索 *EngToCN*，双击后输入新的快捷键")
                            .instructStyle()
                        Text("注意输入法需要切换到**ABC**，否则会无法输入")
                            .font(.footnote)
                            .foregroundColor(Color.gray)
                            .instructStyle()
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                        Image("setting_extension_shortcut")
                            .instructStyle(width: 400, height: 280)
                    }
                }
            }
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 0))
            .frame(width: geo.size.width, height: geo.size.height, alignment: .topLeading)
        }
    }
}

struct CETAboutView: View {
    var body: some View {
        VStack{
            Text("Xcode代码、注释，一键翻译")
                .font(.title3)
            VStack(alignment:.leading) {
                Text("1.翻译源使用有道开放API，无需鉴权、token")
                Text("2.无服务端，纯本地请求，不保留任何用户数据")
                Text("*e-mail:practiceqian@foxmail.com*")
                Text("*github:https://github.com/waohqc/CodeEditorTranslater*")
            }
        }
    }
}

extension Image {
    func instructStyle(width: CGFloat = 200, height: CGFloat = 200) -> some View {
        return self.resizable(resizingMode: .stretch)
            .frame(width: width, height: height, alignment: .center)
            .shadow(radius: 10.0)
            .cornerRadius(10.0)
    }
}

extension Text {
    func instructStyle(top:CGFloat = 0, leading:CGFloat = 10, bottom:CGFloat = 0, trailing:CGFloat = 0) -> some View {
        return self.padding(EdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing))
    }
}

struct CETAppView_Previews: PreviewProvider {
    static var previews: some View {
        CETAppView()
    }
}
