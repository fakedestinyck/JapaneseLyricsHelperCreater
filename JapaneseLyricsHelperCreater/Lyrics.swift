//
//  Lyrics.swift
//  JapaneseLyricsHelperCreater
//
//  Created by  on Dec/17/2017.
//

import Foundation

class Lyrics {
    
    //MARK: Properties
    
    var index: Int
    var jp: String
    var kana: String
    
    //MARK: Initialization
    
    init?(index: Int = -1, jp: String, kana: String = "") {
        self.index = index
        self.jp = jp
        self.kana = kana
        
        if index == -1 || jp.isEmpty {
            return nil
        }
    }
    
}
