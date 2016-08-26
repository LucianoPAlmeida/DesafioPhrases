//
//  ViewController.swift
//  Desafio Phrases
//
//  Created by Luciano Almeida on 2/13/16.
//  Copyright © 2016 Luciano Almeida. All rights reserved.
//

import UIKit
public let DidReceivePhrase : String = "did_receive_phrase"
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var phrasesPersistence : PhrasesPersistence!
    var allPhrases: [String]!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        self.registerObservers()
        self.phrasesPersistence = PhrasesPersistence()
        self.allPhrases = self.phrasesPersistence.allPhrases
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerObservers(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceivePhrase:", name: DidReceivePhrase, object: nil)
    }

    func configureTableView(){
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    //MARK: Table View DataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Frases"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allPhrases.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.numberOfLines = 3
        cell.textLabel?.text = self.allPhrases[indexPath.row]
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func didReceivePhrase(notification: NSNotification){
        self.allPhrases = self.phrasesPersistence.allPhrases
        self.tableView.reloadData()
    }
    
    
    //MARK: - Dealloc
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
}

