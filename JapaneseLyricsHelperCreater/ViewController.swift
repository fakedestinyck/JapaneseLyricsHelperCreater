//
//  ViewController.swift
//  JapaneseLyricsHelperCreater
//
//  Created by  on Dec/17/2017.
//

import Cocoa

class ViewController: NSViewController {
    
    let delegate = NSApplication.shared.delegate as! AppDelegate
    var filePath = ""
    var plistContent = [String:AnyObject]()
    var lyricRows = [[String:AnyObject]]()

    @IBOutlet weak var addNewLineButton: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    
    @IBAction func addNewLineButton(_ sender: NSButton) {
    }
    
    @IBAction func editButton(_ sender: NSButton) {
        print(tableView.row(for: sender))
//        var windowController = NSWindowController(windowNibName: NSNib.Name(rawValue: "EditDetailsWindowController"))
//        windowController.showWindow(self)
        delegate.rowNum = tableView.row(for: sender)
        let myWindowController = self.storyboard!.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "editDetailsWindow")) as! NSWindowController
        myWindowController.showWindow(self)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "plistName"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNewLineButton.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.plistFile(notification:)), name: NSNotification.Name(rawValue: "plistName"), object: nil)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @objc func plistFile(notification: NSNotification) {
        filePath = delegate.filePath
        let tmpContent = NSDictionary(contentsOfFile: filePath)
        if tmpContent is [String:AnyObject] {
            plistContent = tmpContent as! [String : AnyObject]
        } else {
            let alert = NSAlert()
            alert.messageText = "无法打开歌词文件"
            alert.informativeText = "请检查文件格式是否合法"
            alert.addButton(withTitle: "关闭")
            alert.runModal()
            return
        }
        lyricRows = plistContent["lyrics"] as! [[String:AnyObject]]
        tableView.reloadData()
        addNewLineButton.isHidden = false
    }

}

extension ViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return lyricRows.count
    }
    
}

extension ViewController: NSTableViewDelegate {
    
    fileprivate enum CellIdentifiers {
        static let lryicCell = "lrcCell"
        static let editButtonCell = "editButtonCell"
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var text: String = ""
        var cellIdentifier: String = ""
        
        // 1
        guard let item = lyricRows[row]["jp"] else {
            return nil
        }
        
        // 2
        if tableColumn == tableView.tableColumns[0] {
            text = item as! String
            cellIdentifier = CellIdentifiers.lryicCell
        } else if tableColumn == tableView.tableColumns[1] {
            cellIdentifier = CellIdentifiers.editButtonCell
        }
        
        // 3
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: self) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        
        return nil
    }
    
}

