//
//  Settings.swift
//  Form Identifier
//
//  Configure app settings such as the current selected motion classification model.
//

import SwiftUI

struct Settings: View {
    
    @EnvironmentObject var modelManager: ModelManager
    @EnvironmentObject var data: SharedData
    
    @State private var settingsData: ModelManager.Template = ModelManager.Template()

    var body: some View {
        NavigationView {
            Form {

                // Picker to select the current classification model.
                Picker("Selected Model:", selection: $settingsData.selectedModel) {
                    ForEach(Model.allCases, id: \.self) { value in
                        Text(value.rawValue)
                            .tag(value)
                    }
                }
                
                // Update the globally selected model when the setting is changed.
                .onChange(of: settingsData.selectedModel) { _ in
                    modelManager.update(from: settingsData)
                    data.changeModel(newValue: settingsData.selectedModel.rawValue)
                }
            }
            .navigationTitle("Settings")
        }
    }
}
