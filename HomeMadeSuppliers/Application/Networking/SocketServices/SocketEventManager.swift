//
//  SocketEventManager.swift
//  TailerOnline
//
//  Created by apple on 4/18/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit
import ObjectMapper


class SocketEventManager {
    
    static let shared = SocketEventManager()
    
    
    func uploadImage(image: UIImage,
                     resizeHeight: CGFloat = 800,
                     completion:@escaping (UploadResponse<Double,String>) -> Void) {
        
        let socket = SocketIOManager.sharedInstance.getSocket()
        
        let selectedImageResized = image.resizeImage(newHeight: resizeHeight )
        
        
        
        let imagedata : NSData = NSData(data: selectedImageResized.jpegData(compressionQuality: 1.0)!)
        
        let imageSize : Int  = imagedata.length
        print(Double(imageSize))
        print( imagedata as Data)
        
        
        let ImageDataToServer: [String:Any] = ["name": "test.jpg",
                                               "size": Double(imageSize)]
        print(ImageDataToServer)
        
        socket.emit("startFileUpload", with: [ImageDataToServer])
        
        socket.once("startUpload"){(data, ack)in
            let changeData = (data[0] as AnyObject)
            let ImagDictinary = changeData as! [String:AnyObject]
            print(ImagDictinary)
        }
        
        
        let imgData = imagedata as Data
        let uploadChunksize = 102400
        let totalsize = imgData.count
        var offset = 0
        
        socket.on("moreData"){(data, ack)in
            
            let modified = (data[0] as AnyObject)
            let OtherImageDictinary = modified as! [String: AnyObject]
            let moredata = MoreData(dictionary: OtherImageDictinary as NSDictionary)
            print(OtherImageDictinary)
            
            completion(.progress(moredata?.data?.percent ?? 0))
            
            
            let imageData = imagedata as Data
            imageData.withUnsafeBytes{(u8Ptr:UnsafePointer<UInt8>)in
                let mutRawPointer = UnsafeMutableRawPointer(mutating: u8Ptr)
                print(totalsize)
                
                let chunkSize = offset + uploadChunksize > totalsize ? totalsize - offset : uploadChunksize
                let chunk = Data(bytesNoCopy: mutRawPointer+offset, count: chunkSize, deallocator: Data.Deallocator.none)
                offset += chunkSize
                
                let chunkSize2 = chunk.count
                
                let imageDataupload:[String : Any]  = [
                    "fileName":   "test.png",
                    "data" : chunk as NSData ,
                    "pointer" : moredata!.data!.pointer! ,
                    "chunkSize" : chunkSize2
                ]
                
                
                print(imageDataupload)
                
                socket.emit("uploadChunk", with: [imageDataupload])
                
            }
        }
        
        socket.on("uploadCompleted") { (data, ack) in
            
            
            socket.off("startUpload")
            socket.off("moreData")
            socket.off("uploadCompleted")
            
            let modified =  (data[0] as AnyObject)
            
            //Map your response Object
            if let rootModel = Mapper<RootUploadCompleteModel>().map(JSONObject: modified) {
                let path = (rootModel.data?.fileName!)!
                completion(.path(path))
            }
            else {
                nvMessage.showStatusError(body: "Response Changed")
            }
            
            
            
            
        }
    }
    
    
    func uploadAudioFile(url: URL,completion:@escaping (UploadResponse<Double,String>) -> Void) {
        
        let socket = SocketIOManager.sharedInstance.getSocket()
        
         var imagedata = Data()
        
        
        do {
            imagedata = try Data(contentsOf: url)
        } catch {
            print ("loading image file error")
        }
     
        
        let imageSize : Int  = imagedata.count
        print(Double(imageSize))
        print( imagedata as Data)
        
        
        let ImageDataToServer: [String:Any] = ["name": "recording.m4a",
                                               "size": Double(imageSize)]
        print(ImageDataToServer)
        
        socket.emit("startFileUpload", with: [ImageDataToServer])
        
        socket.on("startUpload"){(data, ack)in
            let changeData = (data[0] as AnyObject)
            let ImagDictinary = changeData as! [String:AnyObject]
            print(ImagDictinary)
        }
        
        
        let imgData = imagedata as Data
        let uploadChunksize = 102400
        let totalsize = imgData.count
        var offset = 0
        
        socket.on("moreData"){(data, ack)in
            
            let modified = (data[0] as AnyObject)
            let OtherImageDictinary = modified as! [String: AnyObject]
            let moredata = MoreData(dictionary: OtherImageDictinary as NSDictionary)
            print(OtherImageDictinary)
            
            completion(.progress(moredata?.data?.percent ?? 0))
            
            
            let imageData = imagedata as Data
            imageData.withUnsafeBytes{(u8Ptr:UnsafePointer<UInt8>)in
                let mutRawPointer = UnsafeMutableRawPointer(mutating: u8Ptr)
                print(totalsize)
                
                let chunkSize = offset + uploadChunksize > totalsize ? totalsize - offset : uploadChunksize
                let chunk = Data(bytesNoCopy: mutRawPointer+offset, count: chunkSize, deallocator: Data.Deallocator.none)
                offset += chunkSize
                
                let chunkSize2 = chunk.count
                
                let imageDataupload:[String : Any]  = [
                    "fileName":   "recording.m4a",
                    "data" : chunk as NSData ,
                    "pointer" : moredata!.data!.pointer! ,
                    "chunkSize" : chunkSize2
                ]
                
                
                print(imageDataupload)
                
                socket.emit("uploadChunk", with: [imageDataupload])
                
            }
        }
        
        socket.on("uploadCompleted") { (data, ack) in
            
            
            socket.off("startUpload")
            socket.off("moreData")
            socket.off("uploadCompleted")
            
            let modified =  (data[0] as AnyObject)
            
            //Map your response Object
            if let rootModel = Mapper<RootUploadCompleteModel>().map(JSONObject: modified) {
                let path = (rootModel.data?.fileName!)!
                completion(.path(path))
            }
            else {
                nvMessage.showStatusError(body: "Response Changed")
            }
            
            
            
            
        }
    }
}
