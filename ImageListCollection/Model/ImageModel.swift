//
//  ImageModel.swift
//  ImageListCollection
//
//  Created by Khoa Nguyen on 13/6/24.
//

import Foundation
import UIKit

struct ImageModel {
    var id : Int
    var link : String?
}

class ImageViewModel: NSObject {
    var arrImagePerPage = [[ImageModel]]()
    var arrImageDefault = [ImageModel]()
    
    var pageNumber = 0
    
    func mockDataDefault(){
        //create mock data
        for i in 0 ..< .COUNT_ITEM_DEFAULT {
            arrImageDefault.append(ImageModel(id: i))
        }
    }

    func clearMockData() {
        arrImageDefault.removeAll()
        arrImagePerPage.removeAll()
        imageCache.removeAllObjects()
        self.pageNumber = 0
    }
    
    func addNewData() {
        arrImageDefault.append(ImageModel(id: arrImageDefault.count + 1))
        self.parseImageDatePerPage()
    }
    
    func parseImageDatePerPage() {
        //get data per page
        let arr = self.arrImageDefault
        var arrParse: [[ImageModel]] = []
        let maxCount : Int = .PAGE_MAX_COUNT
        var i = 0
        while i < arr.count {
            let arrSub = (arr.count - i < maxCount ) ? Array(arr[i..<arr.count]) : Array(arr[i..<i+maxCount])
            arrParse.append(arrSub)
            i += maxCount
        }
        
        //get page number
        self.pageNumber = arrParse.count
        self.arrImagePerPage = arrParse
    }
}
