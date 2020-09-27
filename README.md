# Objective-C MovieDB

```Project for the study of Objective-C language and consumption of class written in Objective-C in a Swift code created using MVC architecture.```



#### Requirements and how it was implemented in the project:

* Restful API consumption -> Creating **service class and parse class**

* Image download and management -> Creating **CustomImageView class** that inherits from ImageView where only the URL is passed to the class. Inside of the class, a **cache** class verifies if that image has already been downloaded.

* Movies that appear in the popular list cannot appear in the now playing list -> Use the **dispatch group** to synchronize requests and remove repeated films from the now playing list.

* Search for a movie by name -> Creating ViewController responsible for the **search delegates**.

* Consume Objective-C classes in Swift code -> Creating another **target** containing the Swift project and creating **Bridging-Header file** importing the necessary classes. 



   Application running:


![ezgif com-resize-2](https://user-images.githubusercontent.com/33487118/94377680-032c7000-00fa-11eb-94ca-941a134f0d55.gif)
![ezgif com-resize-3](https://user-images.githubusercontent.com/33487118/94377856-f9efd300-00fa-11eb-8957-f0b6f1da4f5c.gif)
