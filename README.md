# Movies

### MovieManager:
This class is responsible to manage all the action items received from UI, informing MovieAPIManager to get data, creation of view model which conists the business logic and send back to controller.

### MovieAPIManager:
This class is responsible to make an API calls

### TMDBMovieEndPoint:
It forms the api request with all the endpoing of TMDB

## Open Issue:

Search is working as expected, but the highlight of text is not correct which I need to fix using the regular expression to match the pattern


## Pending Items:
MovieManager class has function ready to make API call for Synopsis, Reviews, Credits, Similar Movies, the only pending part to create response model and view model to display data to UI
