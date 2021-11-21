//
//  ViewController.swift
//  DotaHeros
//
//  Created by Berke T. on 20.11.2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var hero : HeroStats?
    var heroes = [HeroStats]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadJSON {
            self.tableView.reloadData()

        }
        tableView.delegate = self
        tableView.dataSource = self
    }

    func downloadJSON(completed: @escaping () -> ()){
        guard let url = URL(string: "https://api.opendota.com/api/heroStats") else {return}
    
        URLSession.shared.dataTask(with: url) { data, response, error in
        
            if error == nil{
                let decoder = JSONDecoder()
                do{
                    self.heroes = try decoder.decode([HeroStats].self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                }catch{
                print("Json Error")
                }
            }
        }.resume()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dotaCell", for: indexPath) as! dotaCell
        cell.nameLabel.text = heroes[indexPath.row].localized_name.capitalized
        cell.attackLabel.text = heroes[indexPath.row].attack_type.capitalized
        cell.attributeLabel.text = heroes[indexPath.row].primary_attr.capitalized
        cell.legsLabel.text = heroes[indexPath.row].legs.formatted()
        let urlString = "https://api.opendota.com"+(heroes[indexPath.row].img)
        let url = URL(string: urlString)
        cell.imagaCell.downloaded(from: url!)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? HeroViewController{
            destination.hero = heroes[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
  


}
