# TopMoviesNow

## Description
  
  This movie based application shows a list of popular and currently playing films based on the TheMovieDB.org API. 
  
  ## Workflow
  
  Main screen has a custom cell containing a CollectionView with a FlowLayout to display the film poster currently in theatre in a horizontal scrollable fashion. The next section is a list of custom cells to show popular movies and what they are currently rated.
  
  Upon selecting either a currently playing movie cell or popular movie cell, it will navigate you to a detail screen showing more information on the film being displayed in a overCurrentContext Modal fashion.
  
  ## Architecture
  
  The architecture of choice is MVVM giving a view model for the the current playing films and one for popular films. 
  
  ## Passing Information
  
  A delegate chain is utilized to pass our viewmodel over to the detail screen utilizing a ViewModelType protocol for dependency inversion, making it more generic.
  
  ## Loading Images
  
  Images are lazily loaded as well as the detail API pulls as the movie length could only be fetched in the detail pull. Images are cached with a singlton NSCache instance that is checked against in the imageFetach calls in the viewmodels. The prefetching data source for the tableview is used to handle the pagination requests whenever the user get close to the current bottom of the movie list.
  
  ## Custom Rating View
  
  The Rating view was created with UIBezierPaths in the CALayer of the view. There is a centered UILabel for the percent using a NSAttributed string for the formatting and the rating circle is drawn behind it in the CALayer. The grey circle is drawn first and the the colored layer is drawn on top of it to the point of percentage for the rating. This is updated with the use of property observers.
  
+ Everything is done programmatically giving a cleaner code base and no 3rd party frameworks were used.
  
  ### Things to have been improved upon: 
