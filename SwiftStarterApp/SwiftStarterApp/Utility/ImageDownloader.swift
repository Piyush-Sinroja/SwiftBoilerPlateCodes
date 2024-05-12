//
//  ImageDownloader.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 29/11/23.
//

import Foundation
import Kingfisher

class ImageDownloader {

    static var shared = ImageDownloader()
    var fadeValue = 0.25
    let cache = KingfisherManager.shared.cache

    private init() { }

    /// set Image
    /// - Parameters:
    ///   - imgPath: image path
    ///   - imgView: A view that displays a single image or a sequence of animated images in your interface.
    ///   - placeHolderImage: place holder image
    func setImage(imgPath: String, imgView: UIImageView?, placeHolderImage: UIImage?) {
        guard let url = URL(string: imgPath) else {
            DispatchQueue.main.async {
                imgView?.image = placeHolderImage
            }
            return
        }
        imgView?.kf.setImage(with: url)
    }

    /// Set image with Kingfisher
    /// - Parameters:
    ///   - imgPath: image path
    ///   - imgView: A view that displays a single image or a sequence of animated images in your interface.
    ///   - placeHolderImage: place holder image
    func setImageWithKingfisher(imgPath: String, imgView: UIImageView?, placeHolderImage: UIImage?) {
        DispatchQueue.main.async {
            if let url = URL(string: imgPath), let imgView = imgView {
                let processor = DownsamplingImageProcessor(size: imgView.bounds.size)
                //|> RoundCornerImageProcessor(cornerRadius: 20)
                imgView.kf.indicatorType = .activity
                imgView.kf.setImage(
                    with: url,
                    placeholder: placeHolderImage,
                    options: [
                        .forceRefresh,
                        .processor(processor),
                        .scaleFactor(UIScreen.main.scale),
                        .fromMemoryCacheOrRefresh,
                        .transition(.fade(self.fadeValue))], completionHandler: { result in
                            switch result {
                                case .success(let value):
                                    DispatchQueue.main.async {
                                        imgView.image = value.image
                                    }
                                    Logger.log("Kingfisher image done for: \(value.source.url?.absoluteString ?? "")")
                                case .failure(let error):
                                    DispatchQueue.main.async {
                                        imgView.image = placeHolderImage
                                    }
                                    Logger.log("Kingfisher image failed: \(error.localizedDescription)")
                            }
                        })
            } else {
                imgView?.image = placeHolderImage
            }
        }
    }

    /// retrive image and set
    /// - Parameters:
    ///   - imgPath: image path
    ///   - imgView: A view that displays a single image or a sequence of animated images in your interface.
    ///   - placeHolderImage: place holder image
    func retrieveImageAndSet(imgPath: String, imgView: UIImageView?, placeHolderImage: UIImage?) {
        if let url = URL(string: imgPath), let imgView = imgView {
            KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil) { result in
                switch result {
                    case .success(let value):
                        print()
                        imgView.image = value.image
                        Logger.log("Image: \(value.image). Got from: \(value.cacheType)")
                    case .failure(let error):
                        print()
                        imgView.image = nil
                        Logger.log("Error: \(error)")
                }
            }
        } else {
            DispatchQueue.main.async {
                imgView?.image = placeHolderImage
            }
        }
    }

    /// clear all cache
    func clearAllCache() {
        cache.clearCache()
    }

    /// clear only disk cache
    func clearOnlyDiskCache() {
        cache.clearDiskCache()
    }

    // clear only memory cache
    func clearOnlyMemoryCache() {
        cache.clearMemoryCache()
    }

    // calculate disk storage size
    func calculateDiskStorageSize() {
        cache.calculateDiskStorageSize { result in
            switch result {
                case .success(let size):
                    print()
                    Logger.log("Disk cache size: \(size)")
                case .failure(let error):
                    print()
                    Logger.log("Error: \(error)")
            }
        }
    }

    /// configuration memory storage (RAM)
    func configMemoryStorage() {
        let yourValueInMB = 10 // 10 mb in ram
        cache.memoryStorage.config.totalCostLimit = 1024 * 1024 * yourValueInMB
        cache.memoryStorage.config.expiration = .seconds(300) // cache clear after 5min. default value is also 5min means 300 seconds
        cache.memoryStorage.config.countLimit = .max // The item count limit of the memory storage. default value is max
    }

    /// configuration disk storage
    func configDiskStorage() {
        let yourValueInMB: UInt = 100 // 100 mb in disk
        cache.diskStorage.config.expiration = .days(7) // cache clear after 7 days. default value is also 7
        cache.diskStorage.config.sizeLimit = 1024 * 1024 * yourValueInMB
        cache.diskStorage.config.sizeLimit = 0 // 0 means no limit
    }
}
