import UIKit

class ViewController: UIViewController {
    
    /// Creating UIDocumentInteractionController instance.
    let documentInteractionController = UIDocumentInteractionController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Setting UIDocumentInteractionController delegate.
        documentInteractionController.delegate = self
    }
    
    @IBAction func showOptionsTapped(_ sender: UIButton) {
        createDirectory()
    }
}

//MARK: - Create Directory
//Create File or Folder
func createDirectory(){
    
    let documentsPath1 = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
    //let logsPath = documentsPath1.appendingPathComponent("data")
    do {
        try FileManager.default.createDirectory(atPath: documentsPath1.path!, withIntermediateDirectories: true, attributes: nil)
        
        storeAndShare(withURLString: "https://www.tutorialspoint.com/swift/swift_tutorial.pdf", pathUrl: documentsPath1 as URL)
    } catch let error as NSError {
        NSLog("Unable to create directory \(error.debugDescription)")
    }
}

/// This function will store your document to some temporary URL and then provide sharing, copying, printing, saving options to the user

func storeAndShare(withURLString: String, pathUrl: URL) {
    
    guard let url = URL(string: withURLString) else { return }
    
    URLSession.shared.dataTask(with: url) {
        data, response, error in
        guard let data = data, error == nil else { return }
        let writeFile = pathUrl.appendingPathComponent(response?.suggestedFilename ?? "GG")
        
        do {
            try data.write(to: writeFile)
        }
        catch {
            print(error)
        }
        }.resume()
}

extension URL {
    var typeIdentifier: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }
    var localizedName: String? {
        return (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName
    }
}


// ########## Below functions are not using this project #########

extension ViewController {
    /// This function will set all the required properties, and then provide a preview for the document
    func share(url: URL) {
        documentInteractionController.url = url
        documentInteractionController.uti = url.typeIdentifier ?? "public.data, public.content"
        documentInteractionController.name = url.localizedName ?? url.lastPathComponent
        documentInteractionController.presentPreview(animated: true)
    }
    
    //    /// This function will store your document to some temporary URL and then provide sharing, copying, printing, saving options to the user
    //    func storeAndShare(withURLString: String) {
    //
    //        guard let url = URL(string: withURLString) else { return }
    //
    //        /// START YOUR ACTIVITY INDICATOR HERE
    //        URLSession.shared.dataTask(with: url) {
    //            data, response, error in
    //            guard let data = data, error == nil else { return }
    //            let tmpURL = FileManager.default.temporaryDirectory
    //                .appendingPathComponent(response?.suggestedFilename ?? "GG")
    //            do {
    //                try data.write(to: tmpURL)
    //            } catch {
    //                print(error)
    //            }
    //
    //            DispatchQueue.main.async {
    //                /// STOP YOUR ACTIVITY INDICATOR HERE
    //                self.share(url: tmpURL)
    //            }
    //        }.resume()
    //    }
}

//Testing To watch Preview
extension ViewController: UIDocumentInteractionControllerDelegate {
    /// If presenting atop a navigation stack, provide the navigation controller in order to animate in a manner consistent with the rest of the platform
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        guard let navVC = self.navigationController else {
            return self
        }
        return navVC
    }
}

