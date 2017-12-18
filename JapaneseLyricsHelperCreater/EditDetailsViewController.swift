//
//  editDetailsViewController.swift
//  JapaneseLyricsHelperCreater
//
//  Created by  on Dec/17/2017.
//

import Cocoa

class EditDetailsViewController: NSViewController {

    let delegate = NSApplication.shared.delegate as! AppDelegate
    var filePath = ""
    var plistContent = [String:AnyObject]()
    var lyricRows = [[String:AnyObject]]()
    var rowNum:Int!
//    var words = [String]()
//    var wordIndexes = [Int]()
    var lyrics = [Lyrics]()
    var selectedIndexes = [Int]()
    
    @IBOutlet weak var lrcLabel: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    @IBAction func cancelButton(_ sender: NSButton) {
        self.view.window?.close()
    }
    
    @IBAction func saveButton(_ sender: NSButton) {
    }
    
    
    func displayingItems() {
        let lyricStr = lyricRows[rowNum]["jp"] as! String
        lrcLabel.stringValue = lyricStr
        for tmpi in 0..<(lyricStr as NSString).length {
            let eachWord = String(lyricStr[lyricStr.index(lyricStr.startIndex, offsetBy: tmpi)])
//            words.append(eachWord)
            if !(eachWord >= "ぁ" && eachWord <= "ゖ" || eachWord == "　" || eachWord >= "゠" && eachWord <= "ヾ") {
                //                var dataenc = eachWord.data(using: String.Encoding.nonLossyASCII)
                //                var encodevalue = String(data: dataenc!, encoding: String.Encoding.utf8)
                //                print(encodevalue)
                print(eachWord)
//                wordIndexes.append(tmpi)
                guard let tmpLyric = Lyrics(index: tmpi, jp: eachWord) else {
                    fatalError("Unable to instantiate a song")
                }
                lyrics.append(tmpLyric)
            }
        }
        guard let tmpKanaArray = lyricRows[rowNum]["word"] else {
            tableView.reloadData()
            return
        }
        let tmpKana = tmpKanaArray as! [String:[String]]
        for (kanaIndex, word) in (tmpKana) {
            var foundInAutoGenerateFile = false
            for tmpj in 0..<lyrics.count {
                if lyrics[tmpj].index == Int(kanaIndex) {
                    lyrics[tmpj].jp = word[0]
                    lyrics[tmpj].kana = word[1]
                    foundInAutoGenerateFile = true
                    break
                }
            }
            if !foundInAutoGenerateFile {
                guard let tmpLyricFromExistFile = Lyrics(index: Int(kanaIndex)!, jp: word[0], kana: word[1]) else {
                    fatalError("Unable to instantiate a song")
                }
                lyrics.append(tmpLyricFromExistFile)
            }
        }
        tableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do view setup here.
        NotificationCenter.default.addObserver(self, selector: #selector(self.plistFile(notification:)), name: NSNotification.Name(rawValue: "plistName"), object: nil)
    }
    
    @objc func plistFile(notification: NSNotification) {
        filePath = delegate.filePath
        plistContent = NSDictionary(contentsOfFile: filePath) as! [String : AnyObject]
        lyricRows = plistContent["lyrics"] as! [[String:AnyObject]]
        rowNum = delegate.rowNum
        displayingItems()
    }
    
    func updateStatus() {
        // 1
        let itemsSelected = tableView.selectedRowIndexes.count
        let itemSelected = tableView.selectedRowIndexes.map { Int($0) }
        
        // 2
        if (lyrics.count == 0) {
            selectedIndexes.removeAll()
        }
        else if(itemsSelected == 0) {
            selectedIndexes.removeAll()
        }
        else {
            
        }
        // 3
        print(itemSelected)
    }
    
}


extension EditDetailsViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return lyrics.count
    }
    
}

extension EditDetailsViewController: NSTableViewDelegate {
    
    fileprivate enum CellIdentifiers {
        static let indexCell = "indexCell"
        static let jpCell = "jpCell"
        static let kanaCell = "kanaCell"
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var text: String = ""
        var cellIdentifier: String = ""
        
        // 1
        guard let item = lyrics[row] as Optional else {
            return nil
        }
        
        // 2
        if tableColumn == tableView.tableColumns[0] {
            text = String(item.index)
            cellIdentifier = CellIdentifiers.indexCell
        } else if tableColumn == tableView.tableColumns[1] {
            text = item.jp
            cellIdentifier = CellIdentifiers.jpCell
        } else if tableColumn == tableView.tableColumns[2] {
            text = item.kana
            cellIdentifier = CellIdentifiers.kanaCell
        }
        
        // 3
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: self) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        
        return nil
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        updateStatus()
    }
    
}
