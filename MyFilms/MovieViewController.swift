//
//  ViewController.swift
//  MyFilms
//
//  Created by Sophie Traynor on 02/11/2017.
//  Copyright © 2017 Sophie Traynor. All rights reserved.
//

import UIKit
import os.log

class MovieViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate {
    
    //MARK: Properties
    
    @IBOutlet weak var avoidingView: UIView!
    @IBOutlet weak var movieNameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var genreTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var ageSegmentedControl: UISegmentedControl!
    @IBOutlet weak var reviewTextView: UITextView!
    
    var movie: Movie?
    
    var pickGenre = ["Action", "Adventure", "Comedy", "Crime", "Drama", "Historical", "Horror","Kids", "Musical", "Sci-Fi", "War", "Western", "Not Listed"]
    
    var maxLength = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up views if editing an existing movie
        if let movie = movie {
            navigationItem.title = movie.name
            movieNameTextField.text = movie.name
            photoImageView.image = movie.photo
            ratingControl.rating = movie.rating
            yearTextField.text = movie.year
            genreTextField.text = movie.genre
            ageSegmentedControl.selectedSegmentIndex = movie.age
            reviewTextView.text = movie.review
        }
        
        //Set up genre picker view
        let genrePickerView = UIPickerView()
        genrePickerView.delegate = self
        genreTextField.inputView = genrePickerView
        
        
        yearTextField.keyboardType = UIKeyboardType.numberPad
        movieNameTextField.returnKeyType = .done
        reviewTextView.layer.borderWidth = 1
        
        //Move view up when fields in view are clicked
        KeyboardAvoiding.avoidingView = self.avoidingView
     
        //Handle the text fields user input through delegate callbacks
        movieNameTextField.delegate = self
        yearTextField.delegate = self
        
        setUpToolbar()
        updateSaveButtonState()
    }
    
    //MARK: Done Button
    
    func setUpToolbar()
    {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem
            .done, target: self, action: #selector(self.doneClicked))
        
        toolbar.setItems([doneButton], animated: false)
        yearTextField.inputAccessoryView = toolbar
        genreTextField.inputAccessoryView = toolbar
        reviewTextView.inputAccessoryView = toolbar
    }
    
    @objc func doneClicked()
    {
        view.endEditing(true)
        updateSaveButtonState()
    }

    
    //MARK: PickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return pickGenre.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickGenre[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        genreTextField.text = pickGenre[row]
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        movieNameTextField.resignFirstResponder()
        yearTextField.resignFirstResponder()
        updateSaveButtonState()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        if textField == movieNameTextField {
            navigationItem.title = textField.text
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    //Allow numbers only to be entered into Year text field else allow any
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == yearTextField {
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        else{
            return true
        }
    }
    
    // These delegate methods can be used so that test fields that are
    // hidden by the keyboard are shown when they are focused
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.reviewTextView {
            KeyboardAvoiding.padding = 20
            KeyboardAvoiding.avoidingView = self.avoidingView
            KeyboardAvoiding.padding = 0
        }
        return true
    }
    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //Dismiss the picker if the user cancelled
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //The info dictionary may contain multiple representations of the image
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        //Set photoImageView to display the selected image
        photoImageView.image = selectedImage
        
        //Dismiss the picker
        dismiss(animated:true, completion: nil)
    }

    //MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        //Depending on style of presentation (modal or push presentation), this vie controller needs to be dismissed in two different ways
        let isPresentingInAddMovieMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMovieMode {
            
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MovieViewController is not inside a navigation controller")
        }
    }
    
    //This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = movieNameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
        let year = yearTextField.text ?? ""
        let genre = genreTextField.text ?? ""
        let age = ageSegmentedControl.selectedSegmentIndex
        let review = reviewTextView.text
   
        // Set the movie to be passed to MovieTableViewController after the unwind segue.
        movie = Movie(name: name, photo: photo, rating: rating, year: year, genre: genre, age: age, review: review)
    }
    
    //MARK: Actions
    
    @IBAction func limitWhileEditing(_ sender: Any) {
        if yearTextField.text!.count > maxLength {
            yearTextField.text?.removeLast()
        }
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        //UIImagePickerController is a view controller that lets a user pick media from their photo library
        let imagePickerController = UIImagePickerController()
        
        //Only allow photos to be picked, not taken
        imagePickerController.sourceType = .photoLibrary
        
        //Make sure ViewController is notified when the user picks an image
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    //MARK: Private Methods
    
    private func updateSaveButtonState() {
        //Disable the Save button if the text field is empty.
        let nameText = movieNameTextField.text ?? ""
        let yearText = yearTextField.text ?? ""
        let genreText = genreTextField.text ?? ""
        
        saveButton.isEnabled = !nameText.isEmpty && !yearText.isEmpty && !genreText.isEmpty
    }
}

