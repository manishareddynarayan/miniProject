//
//  LocationViewController.swift
//  miniProject
//
//  Created by Manisha Reddy Narayan on 07/03/18.
//  Copyright © 2018 Manisha Reddy Narayan. All rights reserved.
//

import UIKit
import GooglePlaces
import Parse
protocol ChooseLocationViewControllerDelegate {
    func finishPassingLocation(controller: ChooseLocationViewController)
}
class ChooseLocationViewController: UIViewController {
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var delegate: ChooseLocationViewControllerDelegate?
    @IBOutlet weak var doneButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.buttonShape()
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        let subView = UIView(frame: CGRect(x: 0, y: 60, width: 50.0, height: 45.0))
        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)
        searchController?.searchBar.backgroundImage = UIImage(named: "searchbarBackground")
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.searchBar.placeholder = "Location"
        definesPresentationContext = true
    }
    func displayAlert(title:String,message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            print("location selcted")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func selectLocationOnClick(_ sender: Any) {
        delegate?.finishPassingLocation(controller: self)
        
    }
}

extension ChooseLocationViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = true
        searchController?.searchBar.text = place.name
        let viewControllers = self.navigationController!.viewControllers as [UIViewController];
        for aViewController:UIViewController in viewControllers {
            if aViewController.isKind(of: CreateMemoryViewController.self) {
                (aViewController as? CreateMemoryViewController)?.userLocation = searchController?.searchBar.text
                searchController?.searchResultsController?.dismiss(animated: true, completion: nil)
                displayAlert(title: "successful", message: "Click Done to save the location")
                self.doneButton.isHidden = false
            }
        }
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
    }
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        print("Error: ", error.localizedDescription)
    }
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
    }
}

