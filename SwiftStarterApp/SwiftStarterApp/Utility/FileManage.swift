//
//  FileManage.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 01/11/23.
//

import Foundation
import UIKit

/// filemange class is used to manage file opearation related stuff
class FileManage: NSObject {

    // MARK: - Documents Directory
    /// Document Directory
    class func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    // MARK: - Check File Exist In Document Directory

    /// check if file exist in subfolder of document dir
    /// - Parameters:
    ///   - fileName: file name
    ///   - directoryName: subfolder name inside document dir
    /// - Returns: return touple values of bool  and filepath if exist.
    class func isFileExistDocumentDir(fileName: String?, directoryName: String?) -> (Bool, URL?) {
        guard let fileNewName = fileName, let dirName = directoryName else {
            return (false, nil)
        }
        let documentsPath = FileManage.documentsDirectory().appendingPathComponent(dirName)
        let file = documentsPath.appendingPathComponent(fileNewName)
        let fileExists = FileManager.default.fileExists(atPath: file.path)
        return (fileExists, file)
    }

    /// check if file exist in document dir
    /// - Parameter fileName: file name
    /// - Returns: return touple values of bool  and filepath if exist.
    class func isFileExistDocumentDir(fileName: String?) -> (Bool, URL?) {
        guard let fileNewName = fileName else {
            return (false, nil)
        }
        let documentsPath = FileManage.documentsDirectory().appendingPathComponent(fileNewName)
        let fileExists = FileManager.default.fileExists(atPath: documentsPath.path)
        return (fileExists, documentsPath)
    }

    // MARK: - Remove From Document Directory

    /// remove all files from document directory
    /// - Parameter subFolder: array of subfolders name
    class func removeAllFilesFromDocumentDirectory(subFolder: [String]) {
        var documentDirectory = FileManage.documentsDirectory()
        if !subFolder.isEmpty {
            for folderName in subFolder {
                documentDirectory = documentDirectory.appendingPathComponent(folderName)
                removeFromDocumentDirectory(documentDirectory: documentDirectory)
            }
        } else {
            removeFromDocumentDirectory(documentDirectory: documentDirectory)
        }
    }

    /// remove single file from document dir
    /// - Parameter fileName: filename which you want to remove
    class func removeSingleFileFromDocumentDir(fileName: String) -> Bool {
        let documentDirectory = FileManage.documentsDirectory()
        return removeFileFromDocumentDirectory(documentDirectory: documentDirectory, path: fileName)
    }

    /// remove file from document dir
    /// - Parameters:
    ///   - documentDirectory: document dir path
    ///   - path: path in string
    fileprivate class func removeFileFromDocumentDirectory(documentDirectory: URL, path: String) -> Bool {
        let fileManager = FileManager.default
        var isDeleted = false
        let deletePath = documentDirectory.appendingPathComponent(path)
        do {
            try fileManager.removeItem(at: deletePath)
            isDeleted = true
        } catch {
            isDeleted = false
            // Non-fatal: file probably doesn't exist
        }
        return isDeleted
    }

    /// remove file from document dir
    /// - Parameters:
    ///   - documentDirectory: document dir path
    ///   - path: path in string
    class func removeFileFromDocumentDirectory(fileUrl: URL) -> Bool {
        let fileManager = FileManager.default
        var isDeleted = false
        let deletePath = fileUrl
        do {
            try fileManager.removeItem(at: deletePath)
            isDeleted = true
        } catch {
            isDeleted = false
            // Non-fatal: file probably doesn't exist
        }
        return isDeleted
    }

    /// remove all file from document dir
    /// - Parameter documentDirectory: document dir url
    fileprivate class func removeFromDocumentDirectory(documentDirectory: URL) {
        let fileManager = FileManager.default
        do {
            let fileUrls = try fileManager.contentsOfDirectory(atPath: documentDirectory.path)
            for path in fileUrls {
                _ = removeFileFromDocumentDirectory(documentDirectory: documentDirectory, path: path)
            }
        } catch {
            print("Error while enumerating files \(documentDirectory.path): \(error.localizedDescription)")
        }
    }

    // MARK: - Save Image To Document Directory

    /// save image to document dir
    /// - Parameters:
    ///   - imgName: imgName string
    ///   - img: An object that manages image data in your app.
    ///   - compressionQuality: image compressionQuality value
    /// - Returns: image path
    class func saveImgToDocumentDir(imgName: String, img: UIImage, compressionQuality: CGFloat) -> String? {
        let documentsPath = FileManage.documentsDirectory()
        var filepath: String? = nil
        let fileURL = documentsPath.appendingPathComponent(imgName)
        if let data = img.jpegData(compressionQuality: compressionQuality) {
            if !FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    try data.write(to: fileURL)
                    print("img saved")
                    filepath = fileURL.path
                } catch {
                    print("error saving image:", error)
                }
            } else {
                filepath = fileURL.path
            }
        }
        return filepath
    }

    // MARK: - Create Folder To Document Directory

    /// create folder in document dir
    /// - Parameter folderName: foldername
    /// - Returns: filepath url
    class func createFolderInDocumentDir(folderName: String) -> URL? {
        let fileManager = FileManager.default
        let documentDirectory = FileManage.documentsDirectory()
        let filePath = documentDirectory.appendingPathComponent(folderName)
        if !fileManager.fileExists(atPath: filePath.path) {
            do {
                try fileManager.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
        return filePath
    }

    // MARK: - All File List From Document Directory

    /// all file list from document dir
    /// - Parameter whichExtension: extension name of file
    /// - Returns: array of filepath url
    class func allFileListFromDocumentDir(whichExtension: String) -> [URL]? {
        let fileManager = FileManager.default
        let documentDirectory = FileManage.documentsDirectory()
        do {
            let fileUrls = try fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil, options: [])
            let result = fileUrls.filter { $0.pathExtension == whichExtension }
            return result
        } catch {
            print("Error while enumerating files \(documentDirectory.path): \(error.localizedDescription)")
            return nil
        }
    }

    // MARK: - Create File To Document Directory

    /// create textfile to document dir
    /// - Parameters:
    ///   - text: text string
    ///   - fileNameWithExtension: filename with extension
    /// - Returns: return true if file created successfully
    class func createTextFileToDocumentDirectory(text: String, fileNameWithExtension: String) -> Bool {
        let documentsDirectory = FileManage.documentsDirectory()
        let fileURL = documentsDirectory.appendingPathComponent(fileNameWithExtension)
        do {
            try text.write(to: fileURL, atomically: false, encoding: .utf8)
            return true
        } catch { return false }
    }

    // MARK: - Save File To Document Directory

    /// save data file to document dir
    /// - Parameters:
    ///   - data: data
    ///   - fileNameWithExtension: filename with extension
    /// - Returns: touple of filepath url or error
    class func saveDataFileToDocumentDirectory(data: Data, fileNameWithExtension: String) -> (fileUrl: URL?, error: Error?) {
        let documentsDirectory = FileManage.documentsDirectory()
        let fileURL = documentsDirectory.appendingPathComponent(fileNameWithExtension)
        do {
            try data.write(to: fileURL)
            return (fileURL, nil)
        } catch {
            return (nil, error)
        }
    }

    // MARK: - Read File From Document Directory

    /// read textfile from document dir
    /// - Parameter fileNameWithExtension: filename with extension
    /// - Returns: string of file
    class func readTextFileFromDocumentDirectory(fileNameWithExtension: String) -> String? {
        var urlPath: URL?
        var isExist: Bool = false
        var strText: String?
        (isExist, urlPath) = FileManage.isFileExistDocumentDir(fileName: fileNameWithExtension)
        if isExist,
           let urlPath {
            do {
                strText = try String(contentsOf: urlPath, encoding: .utf8)
            } catch {/* error handling here */}
        }
        return strText
    }

    // MARK: - Copy File From Bundle To Document Directory

    /// copy file from bundle to document dir
    /// - Parameters:
    ///   - sourceName: source name
    ///   - sourceExtension: source file extension
    /// - Returns: return true if file copied successfully
    class func copyFileFromBundleToDocumentDir(sourceName: String, sourceExtension: String) -> Bool {
        let fileManager = FileManager.default
        guard let bundleFileUrl = Bundle.main.url(forResource: sourceName, withExtension: sourceExtension) else { return false}
        let documentsDirectory = FileManage.documentsDirectory()
        let documentDirectoryFileUrl = documentsDirectory.appendingPathComponent(sourceName+"."+sourceExtension)
        if !fileManager.fileExists(atPath: documentDirectoryFileUrl.path) {
            do {
                try fileManager.copyItem(at: bundleFileUrl, to: documentDirectoryFileUrl)
                return true
            } catch {
                print("Could not copy file: \(error)")
                return false
            }
        } else {
            return false
        }
    }

    // MARK: - Copy File From Temp To Document Directory

    /// copy file from temp dir to document dir
    /// - Parameters:
    ///   - fileUrlFromTempDir: filepath url from temp dir
    ///   - isfullUrl: pass true if full url
    ///   - shouldDeleteFromTemp: pass true if need to delete file from temp dir
    /// - Returns: fillepath string
    class func copyFileFromTempToDocumentDir(fileUrlFromTempDir: URL, isfullUrl: Bool, shouldDeleteFromTemp: Bool) -> String? {
        let documentsPath = FileManage.documentsDirectory()
        var lastPathComponent = fileUrlFromTempDir.lastPathComponent
        if isfullUrl {
            lastPathComponent = fileUrlFromTempDir.path
            lastPathComponent = lastPathComponent.replacingOccurrences(of: ":", with: "")
            lastPathComponent = lastPathComponent.replacingOccurrences(of: "//", with: "-")
            lastPathComponent = lastPathComponent.replacingOccurrences(of: "/", with: "-")
        }
        let fullPath = documentsPath.appendingPathComponent(lastPathComponent)
        let destinationURL = URL(fileURLWithPath: fullPath.path)
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(at: destinationURL)
        } catch {
            // Non-fatal: file probably doesn't exist
        }
        do {
            try fileManager.copyItem(at: fileUrlFromTempDir, to: destinationURL)
            if shouldDeleteFromTemp {
                try fileManager.removeItem(at: fileUrlFromTempDir)
            }
            return destinationURL.path
        } catch let error as NSError {
            print("Could not copy file to disk: \(error.localizedDescription)")
            return nil
        }
    }

    // MARK: - Move File From Temp To Document Directory

    /// move file from temp dir to document dir
    /// - Parameters:
    ///   - fileUrlFromTempDir: filepath url from temp dir
    ///   - isfullUrl: pass true if full url
    /// - Returns: fillepath string
    class func moveFileFromTempToDocumentDir(fileUrlFromTempDir: URL, isfullUrl: Bool) -> String? {
        let documentsPath = FileManage.documentsDirectory()
        var lastPathComponent = fileUrlFromTempDir.lastPathComponent
        if isfullUrl {
            lastPathComponent = fileUrlFromTempDir.path
            lastPathComponent = lastPathComponent.replacingOccurrences(of: ":", with: "")
            lastPathComponent = lastPathComponent.replacingOccurrences(of: "//", with: "-")
            lastPathComponent = lastPathComponent.replacingOccurrences(of: "/", with: "-")
        }
        let fullPath = documentsPath.appendingPathComponent(lastPathComponent)
        let destinationURL = URL(fileURLWithPath: fullPath.path)
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(at: destinationURL)
        } catch {
            // Non-fatal: file probably doesn't exist
        }
        do {
            try fileManager.moveItem(at: fileUrlFromTempDir, to: destinationURL)
            return destinationURL.path
        } catch let error as NSError {
            print("Could not copy file to disk: \(error.localizedDescription)")
            return nil
        }
    }

    // MARK: - Temp Directory

    /// Temp Directory
    class func tempDirectory() -> URL {
        let tempDirectoryURL = NSURL.fileURL(withPath: NSTemporaryDirectory(), isDirectory: true)
        return tempDirectoryURL
    }

    // MARK: - Check File Exist In Temp Directory

    /// check is file exist in temp dir
    /// - Parameter fileName: filename
    /// - Returns: return true if file exist in temp dir path
    class func isFileExistTempDir(fileName: String?) -> Bool {
        guard let fileNewName = fileName else {
            return false
        }
        let tempDirPath = FileManage.tempDirectory().appendingPathComponent(fileNewName)
        let fileExists = FileManager.default.fileExists(atPath: tempDirPath.path)
        return fileExists
    }
}
