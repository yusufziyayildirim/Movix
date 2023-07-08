//
//  ImageCacheManager.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 8.07.2023.
//

import UIKit

final class ImageCacheManager {
    static let shared = ImageCacheManager()
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {
        // Önbellek ayarlarını yapılandırma
        cache.totalCostLimit = 250 * 1024 * 1024 // Toplam maliyet limiti: 100 MB
        cache.countLimit = 200 // Maksimum öğe sayısı: 100
    }
    
    func loadImage(withURL url: URL, completion: @escaping (UIImage?) -> Void) {
        let cacheKey = url.absoluteString as NSString
        
        // Önbellekte resmi kontrol et
        if let cachedImage = cache.object(forKey: cacheKey) {
            completion(cachedImage)
            return
        }
        
        // Önbellekte resim yok, asenkron olarak indir ve önbelleğe al
        DispatchQueue.global().async {
            if let imageData = try? Data(contentsOf: url),
               let image = UIImage(data: imageData) {
                self.cache.setObject(image, forKey: cacheKey, cost: imageData.count)
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }
}
