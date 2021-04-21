# InformationViewManager
A class that displays a message that disappears similar to a toast but with the touch of iOS 

### What is this?
A helper class that displays a small view that shows a message to a user and disappears. Sounds Famailiar to a toast right? But guess what it has UIKitDynamics involved.It supports the following:

1) toast can be moved around via pan
2) swipe the info view down and it is pushed out of the screen 
3) slowly try to move the info view to the bottom and it is automatically moved out of the screen
4) dynamically resizes based on content
5) its can be customized, to be specific everthing i.e image , title color,font and bgcolor

### Usage:

```
    private lazy var infoViewManager:InformationViewManager = {
        return InformationViewManager(parentView: self.view)
    }()
```
where parentView is UIViewController.view or the container view in which the toast has to be displayed

and finally

```
        let dataModel = InformationViewDataModel(image: UIImage(named: "checkmark"), description: "This is a sample test This is a sample test", backgroundColor: UIColor.black, titleColor: UIColor.white, font: UIFont.systemFont(ofSize: 12))
        self.infoViewManager.showUsing(dataModel: dataModel)
```

thats it! 

### Video:


https://user-images.githubusercontent.com/34152717/115580730-fe711880-a2e4-11eb-9e05-b291378fbdf0.mov



