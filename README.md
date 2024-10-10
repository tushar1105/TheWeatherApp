# READ-ME: The Weather App iOS App - Tushar Sharma

## Application Overview

    - The application aims to provide the user with current weather information using the current location.
    
    - I added a feature to allow for city name input to display the weather information for the respective city.
    
    - A reset button is added to allow the user to put the application back to its original state.
    
    - The application provides descriptive alert messages to the user informing about the system responses based on his actions.

    - For greater code readability, the code files are organised into logical folders namely - Model, View, Controller and Utilities and class files contain descriptive comments for the functionality of modules and references if any.

## Application Structure
    
### Model
    - APICall: Structure containing the required components of the API call as properties with the initial values, the request string is sent over as and when required during object creation.
    - WeatherAPI: Structure to represent the API response received from the openweather API.
### View
    - LaunchScreen: The first screen displayed when the application is launched.
    - Main: A main view, along with various action buttons and outlets.

### Controller
    - ViewController: The main controller for the view and the related actions.
        - implements the CLLocationManagerDelegate and displays the current weather conditions using the openweather API.
    
        
        
