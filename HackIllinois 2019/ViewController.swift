//
//  ViewController.swift
//  HackIllinois 2019
//
//  Created by Pamela Sanan on 2/24/19.
//  Copyright © 2019 Pamela Sanan. All rights reserved.
//
import UIKit

class ViewController: UIViewController, StreamDelegate {
    
    //Button
    var buttonConnect : UIButton!
    
    //Label
    var label : UILabel!
    var label2 : UILabel!
    var labelConnection : UILabel!
    
    //Socket server
    let addr = "172.16.194.126"
    let port = 9876
    
    //Network variables
    var inStream : InputStream?
    var outStream: OutputStream?
    
    var bufferStr : NSString?
    
    //Data received
    var buffer = [UInt8](repeating: 0, count: 200)
    
    var flag = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        LabelSetup()
        //        continuous()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        LabelSetup()
        continuous()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func continuous(){
        //let data : Data = "This is iPhone".data(using: String.Encoding.utf8)! as Data
        NetworkEnable()
        let data = "This is iPhone".data(using: .utf8)!
        _ = data.withUnsafeBytes {bytes in
            outStream?.write(bytes, maxLength: data.count)
        }
        //outStream?.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
    }
    
    
    //Network functions
    func NetworkEnable() {
        
        print("NetworkEnable")
        Stream.getStreamsToHost(withName: addr, port: port, inputStream: &inStream, outputStream: &outStream)
        
        inStream?.delegate = self
        outStream?.delegate = self
        
        inStream?.schedule(in: RunLoop.current, forMode: RunLoop.Mode.default)
        outStream?.schedule(in: RunLoop.current, forMode: RunLoop.Mode.default)
        
        inStream?.open()
        outStream?.open()
        
        buffer = [UInt8](repeating: 0, count: 200)
        //stream(aStream: inStream!)
        
        if (flag == 1){
            inStream?.read(&buffer, maxLength: buffer.count)
            bufferStr = NSString(bytes: &buffer, length: buffer.count, encoding: String.Encoding.utf8.rawValue)
            flag = 0
        }
        
        print(bufferStr!)
        var temp = bufferStr! as String
        temp.remove(at: temp.startIndex)
        temp.remove(at: temp.startIndex)
        temp.remove(at: temp.startIndex)
        let delimiter = ","
        var token = temp.components(separatedBy: delimiter)
        label.text = "Devices: " + token[0]
        label2.text = "Air Quality: " + token[1]
    }
    
    func LabelSetup() {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 300, height: 150))
        label = UILabel(frame: rect)
        
        label.center = CGPoint(x: view.center.x,y :view.center.y)
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0 //Multi-lines
        label.font = UIFont(name: "Helvetica-Bold", size: 20)
        view.addSubview(label)
        
        label2 = UILabel(frame: rect)
        label2.center = CGPoint(x: view.center.x,y :view.center.y-100)
        label2.textAlignment = NSTextAlignment.center
        label2.numberOfLines = 0 //Multi-lines
        label2.font = UIFont(name: "Helvetica-Bold", size: 20)
        view.addSubview(label2)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

