//
//  model.swift
//  Doctor-HMS
//
//  Created by Rishita kumari on 15/07/24.
//

import Foundation
import UniformTypeIdentifiers
import Foundation
import SwiftUI

struct labTest: Identifiable {
    var id = UUID()
    var name: String
}

struct MedicalRecord: Identifiable {
    var id = UUID()
    var date: String
    var symptoms: String
    var specialist: String
    var fileURL: URL
}

struct Prescription: Identifiable {
    var id = UUID()
    var name: String
}

struct DocumentPicker: UIViewControllerRepresentable {
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker

        init(parent: DocumentPicker) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.onDocumentsPicked(urls)
        }
    }

    var onDocumentsPicked: ([URL]) -> Void

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.item])
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
}
