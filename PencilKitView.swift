import SwiftUI
import PencilKit
import Firebase
import FirebaseStorage

struct PencilKitView: UIViewControllerRepresentable {
    @Binding var canvasView: PKCanvasView
    var onSave: (UIImage) -> Void

    class Coordinator: NSObject, PKToolPickerObserver {
        var parent: PencilKitView
        var toolPicker: PKToolPicker?

        init(parent: PencilKitView) {
            self.parent = parent
        }

        @objc func doneButtonTapped() {
            let image = parent.canvasView.drawing.image(from: parent.canvasView.bounds, scale: 1.0)
            parent.onSave(image)
        }

        @objc func saveButtonTapped() {
            let renderer = UIGraphicsImageRenderer(bounds: parent.canvasView.bounds)
            let image = renderer.image { context in
                parent.canvasView.drawHierarchy(in: parent.canvasView.bounds, afterScreenUpdates: true)
            }
            parent.onSave(image)
            saveImageToFirestore(image)
        }

        @objc func clearButtonTapped() {
            parent.canvasView.drawing = PKDrawing()
        }

        @objc func eraseButtonTapped() {
            parent.canvasView.tool = PKEraserTool(.vector)
        }

        @objc func penButtonTapped() {
            parent.canvasView.tool = PKInkingTool(.pen, color: .black, width: 10)
        }

        @objc func pencilButtonTapped() {
            parent.canvasView.tool = PKInkingTool(.pencil, color: .black, width: 10)
        }

        @objc func markerButtonTapped() {
            parent.canvasView.tool = PKInkingTool(.marker, color: .black, width: 10)
        }
        
        func saveImageToFirestore(_ image: UIImage) {
            guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
            let storageRef = Storage.storage().reference().child("prescriptions/\(UUID().uuidString).jpg")
            
            let _ = storageRef.putData(imageData, metadata: nil) { metadata, error in
                guard metadata != nil else {
                    print("Failed to upload image: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                storageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        print("Failed to retrieve download URL: \(error?.localizedDescription ?? "Unknown error")")
                        return
                    }
                    self.saveImageURLToFirestore(downloadURL.absoluteString)
                }
            }
        }
        
        func saveImageURLToFirestore(_ url: String) {
            let db = Firestore.firestore()
            db.collection("prescriptions").addDocument(data: ["imageURL": url]) { error in
                if let error = error {
                    print("Failed to save image URL to Firestore: \(error.localizedDescription)")
                } else {
                    print("Image URL saved successfully.")
                }
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        canvasView.backgroundColor = .white
        viewController.view.addSubview(canvasView)
        canvasView.frame = viewController.view.bounds
        canvasView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        let toolPicker = PKToolPicker()
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        context.coordinator.toolPicker = toolPicker
        canvasView.becomeFirstResponder()

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false

        let doneButton = createToolButton(context: context, title: "Done", action: #selector(context.coordinator.doneButtonTapped))
        let saveButton = createToolButton(context: context, title: "Save", action: #selector(context.coordinator.saveButtonTapped))
        let clearButton = createToolButton(context: context, title: "Clear", action: #selector(context.coordinator.clearButtonTapped))
        let eraseButton = createToolButton(context: context, title: "Erase", action: #selector(context.coordinator.eraseButtonTapped))
        let penButton = createToolButton(context: context, title: "Pen", action: #selector(context.coordinator.penButtonTapped))
        let pencilButton = createToolButton(context: context, title: "Pencil", action: #selector(context.coordinator.pencilButtonTapped))
        let markerButton = createToolButton(context: context, title: "Marker", action: #selector(context.coordinator.markerButtonTapped))

        stackView.addArrangedSubview(pencilButton)
        stackView.addArrangedSubview(penButton)
        stackView.addArrangedSubview(markerButton)
        stackView.addArrangedSubview(eraseButton)
        stackView.addArrangedSubview(clearButton)
        stackView.addArrangedSubview(saveButton)
        stackView.addArrangedSubview(doneButton)

        viewController.view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            stackView.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
        ])

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update UI
    }

    private func createToolButton(context: Context, title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.addTarget(context.coordinator, action: action, for: .touchUpInside)
        button.setTitleColor(.blue, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blue.cgColor
        return button
    }
}



