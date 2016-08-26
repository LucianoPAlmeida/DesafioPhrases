//
//  InterfaceController.swift
//  Desafio Phrases WatchKit Extension
//
//  Created by Luciano Almeida on 2/13/16.
//  Copyright © 2016 Luciano Almeida. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate{

    @IBOutlet var phraseLabel: WKInterfaceLabel!
    
    @IBOutlet var passButton: WKInterfaceButton!
    
    @IBOutlet var saveButton: WKInterfaceButton!
    
    @IBOutlet var messageLabel: WKInterfaceLabel!
    
    @IBOutlet var table: WKInterfaceTable!
    
    @IBOutlet var showPhrasesButton: WKInterfaceButton!
    
    var isShowingPhrases: Bool = false
    
    var currentPhrase: String! {
        didSet{
            self.phraseLabel.setText(self.currentPhrase)
        }
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        self.currentPhrase = Catchphrases.nextRandomPhrase()
        if WCSession.isSupported() {
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    //MARK: Actions
    @IBAction func passAction() {
        self.currentPhrase = Catchphrases.nextRandomPhrase()
    }
    
    @IBAction func saveAction() {
        if WCSession.isSupported() {
            let session = WCSession.defaultSession()
            session.sendMessage(["type" : "save_phrase","phrase" : self.currentPhrase], replyHandler: { (response) -> Void in
                self.messageLabel.setText("Salvo")
                }, errorHandler: { (error) -> Void in
                    print("\(error)")
                    self.messageLabel.setText("Erro")
            })
        }
    }
    
    @IBAction func showSavedPhrases(){
        if self.isShowingPhrases {
            self.isShowingPhrases = false
            self.table.setHidden(true)
            self.showPhrasesButton.setTitle("Mostrar Bordões")
        }else{
            if WCSession.isSupported() {
                let session = WCSession.defaultSession()
                session.sendMessage(["type" : "request_phrases"], replyHandler: { (response) -> Void in
                    let allPhrases = response["phrases"] as! [String]
                    self.populateTableWithPhrases(allPhrases)
                    self.isShowingPhrases = true
                    self.table.scrollToRowAtIndex(0)
                    self.table.setHidden(false)
                    self.showPhrasesButton.setTitle("Esconder Bordões")
                    }, errorHandler: { (error) -> Void in
                        self.messageLabel.setText("Erro")
                })
                
            }
        }
    }
    
    func populateTableWithPhrases(phrases: [String]) {
        
        self.table.setNumberOfRows(phrases.count, withRowType: "PhraseRow")
        for var i = 0 ; i < phrases.count; i++ {
            let row = self.table.rowControllerAtIndex(i) as! PhraseRow
            row.rowDescription.setText(phrases[i])
        }
    }

   
}
