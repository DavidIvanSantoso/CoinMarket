//
//  ViewController.swift
//  UAS_IOS_C14190040
//
//  Created by Athalia Gracia Santoso on 09/06/22.
//

import UIKit



class ViewController: UIViewController {

    @IBOutlet weak var tbCoin: UITableView!
    
    var jumlahjson=0
    
    struct coinStruct{
        var namaCoin : String
        var simbolCoin : String
        var gambarCoin : String
        var usdCoin : Double
    };
    
    struct ExchangeRates : Decodable{
        let new_amount: Double
        let new_currency: String
        let old_currency: String
        let old_amount: Double
    }
    
    var arrCoin = [coinStruct]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       let dispatch=DispatchGroup()
        dispatch.enter()
        
        let headers = [
            "X-RapidAPI-Host": "coingecko.p.rapidapi.com",
            "X-RapidAPI-Key": "98828c185amsh21cc5b1b3c3f3e9p195744jsnebb77019dbef"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://coingecko.p.rapidapi.com/coins/markets?vs_currency=usd&page=1&per_page=100&order=market_cap_desc")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error ?? "")
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse ?? "")
            }
            if let json = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [Any] {
                //print(json)

                for item in json {
                    if let object = item as? [String: Any] {
                        let name = object["name"] as? String ?? ""
                        let symbol = object["symbol"] as? String ?? ""
                        let current_price = object["current_price"] as? Double ?? 0.0
                        let image = object ["image"] as? String ?? ""
                        self.arrCoin.append(coinStruct(namaCoin: name, simbolCoin: symbol, gambarCoin: image, usdCoin: current_price))
                    }
                }
            }
        })
        
        dataTask.resume()
        dispatch.leave()
        sleep(2)
        dispatch.enter()
        
        //convIDR()
        let headersa = [
            "X-RapidAPI-Key": "9556ee3598msh40b5beea9b92e0cp131cfajsn36de6d91a60f",
            "X-RapidAPI-Host": "currency-converter-by-api-ninjas.p.rapidapi.com"
        ]

        let requesta = NSMutableURLRequest(url: NSURL(string: "https://currency-converter-by-api-ninjas.p.rapidapi.com/v1/convertcurrency?have=USD&want=IDR&amount=1")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        requesta.httpMethod = "GET"
        requesta.allHTTPHeaderFields = headersa

        let sessiona = URLSession.shared
        let dataTaska = sessiona.dataTask(with: requesta as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error ?? "")
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse ?? "")
            }
            let decoder = JSONDecoder()
            let decode = try! decoder.decode(ExchangeRates.self, from: data!)
            self.convertidr=decode.new_amount
        })

        dataTaska.resume()
        
        dispatch.leave()
        dispatch.notify(queue: .main){
            self.tbCoin.delegate = self
            self.tbCoin.dataSource = self
            sleep(2)
            self.register()
        }
    }
   
    var convertidr = 0.0
    
    func register(){
        tbCoin.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "tabelviewcell")
        DispatchQueue.main.async {
            self.tbCoin.reloadData()
        }
    }
    
}

extension ViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped")
    }
}
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(arrCoinName.count)
        return arrCoin.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tabelviewcell" , for: indexPath) as! TableViewCell
        
        cell.labelnama.text=arrCoin[indexPath.row].namaCoin
        cell.labelsimbol.text=arrCoin[indexPath.row].simbolCoin
        cell.labelusd.text="USD: "+String(arrCoin[indexPath.row].usdCoin)
        cell.labelgambar.loadFrom(URLAddress: arrCoin[indexPath.row].gambarCoin)
        let total=arrCoin[indexPath.row].usdCoin*convertidr
        let formatter = NumberFormatter()
        formatter.locale=Locale(identifier: "id_ID")
        formatter.groupingSeparator="."
        formatter.numberStyle = .decimal
        let formatted = formatter.string(from: total as NSNumber)
        cell.labelidr.text="IDR: " + formatted!
        print(convertidr)
        return cell
    }
}
extension UIImageView {
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                        self?.image = loadedImage
                }
            }
        }
    }
}

