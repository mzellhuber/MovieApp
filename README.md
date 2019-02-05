
# MovieApp

MovieApp es una aplicación que te permite explorar películas y visualizar sus detalles. Utiliza el API de TheMovieDB para 

## Capas de la aplicación 
- Business
	- Cache
	- Reachability
- Red
	- Networking
- Vistas
	- MovieTableViewCell
	- VideoCollectionViewCell
	- Storyboard

## Responsabilidad de cada clase

La arquitectura de la aplicación es MVVM. Esto se decidió por que en este modelo es más fácil distribuir las responsabilidades y darle a cada una de las clases un rol específico. MVVM también facilita el mantenimiento de la aplicación, no tienendo tanto código acumulado en pocas clases.

### Controller
- MovieListViewController
En esta clase se hace el setup de los componentes que forman parte de la vista como el SegmentedController, SearchController y la TableView. También se verifica que haya conectividad a internet y utilizando la clase Networking se piden los datos de las películas del webservice. Una vez que se han recibido los datos del API, se le asignan al MovieViewModel para el correcto funcionamiento de la aplicación. Si con alguna búsqueda llegara a no haber resultados se despliega una notificación al usuario informando que no hay resultados. 

- MovieDetailViewController
Esta clase recibe la información de la película correspondiente de MovieListViewController. Hace el setup de los componentes que forman parte de la vista como la CollectionView.  Si se cuenta con una conexión a internet, se hacen la llamada de red correspondiente para desplegar la lista de videos y se habilita un botón para compartir el contenido. La respuesta de la llamada de red se almacena en el VideoViewModel. Para el fondo de la vista, se utiliza la misma imágen que se utilizó previamente en la lista de películas y se difumina para que todo el contenido sea visible. Se utiliza la imágen del póster de la película para la imágen principal de la vista. 


### Model
Models contiene los modelos necesarios para la aplicación. Cada uno de los modelos usa el protocolo Codable que permite decodificar la respuesta en forma JSON que recibe del API y la convierte los objetos necesarios.

### View
#### Cells
- MovieTableViewCell 
Esta clase recibe los datos del MovieViewModel y decide en que parte de cada celda va la información.

- VideoCollectionViewCell
Esta clase recibe los datos del VideoViewModel y decide en que parte de cada celda va la información.

#### xib
Esta carpeta contiene los prototipos de las celdas en la aplicación. MovieTableViewCell es para la lista de películas y VideoCollectionViewCell para la colección de videos en el detalle de cada película. Cada prototipo tiene una clase correspondiente.

Toast
Toast es una clase que muestra una notificación con un mensaje personalizado. En este caso se utiliza para informar al usuario que no hay conexión al internet.

### ViewModel
- MovieViewModel
En esta clase se hacen las transformaciones necesarias para que los datos del modelo sean representados correctamente en la vista. Para transformar los ids de los géneros a su nombre correspondiente se utiliza un diccionario que está en la clase Constants.swift.

- VideoViewModel
En esta clase se hacen las transformaciones necesarias para que los datos del modelo sean representados correctamente en la vista. Se verifica que los videos correspondientes sean de YouTube para poderlos desplegar correctamente en la colección de videos en el detalle de cada película.

### Utils
#### Cache
Implementa las funciones necesarias para utlizar la librería del mismo nombre. En cache se guardan los resultados de las llamadas a las listas de películas. En esta clase también está implementada la funcionalidad para traer los datos del caché. Esto se hace a partir de entradas en un diccionario en el cual las llaves son las categorias de cada lista.

#### Constants
Constantes globales utilizadas en la applicación. Estas incluyen la API Key, URL paths y el diccionario de géneros de películas.

#### Extensions
Contiene extensiones para la clase String y TableView. Aquí hay funciones que se implementaron como ayudantes que agregan funcionalidades a las clases. La extensión de String formatDate convierte la fecha que provee TMDB a un formato más amigable. En caso de las extensiones de TableView, reloadData es una nueva implementación de la funcionalidad base que cuando es llamada agrega animaciones con ayuda de ViewAnimator. La funcion scroll mueve el marco de la tabla al primer indice. Es útil cuando se hace el cambio a una nueva categoría (Popular, Top Rated, Upcoming) para que se puedan ver las primeras películas en la lista.

#### Networking
En este archivo se han implementado todas las funcionalidades necesarias para hacer las llamadas al web service de TMDB. Contiene las funciones getMovies y getMovieVideoPath. La primer función se encarga de recuperar la lista de películas de acuerdo a lo que el usuario haya seleccionado, cuando se hace una llamada exitosa se guardan los resultados en el cache, asegurando la funcionalidad offline. La segunda función regresa la lista de videos que se puede visualizar en el detalle de cada película. 

#### Reachability
En este archivo se ha implementado la funcionalidad necesaria para corroborar que haya conexión a internet, ya sea WiFi o Cellular. 

## Dependencias
Las dependencias estan manejadas por medio de CocoaPods


### TwicketSegmentedControl
Segmented Control con funcionalidades agregadas. Tiene un estilo moderno con el que la seleccion se puede hacer en forma de jalar o seleccionar. 

### SDWebImage
Librería para descargar imágenes de manera asíncrona. Además cuenta con un cache implementado para evitar multiples llamadas a la red recuperando imágenes que ya han sido descargadas previamente.

### Cache
Utilizada para garantizar la persistencia de la aplicación. Almacena los datos en memoria y en disco. Permite que la aplicación funcione y presente las películas que ya han sido descargadas previamente. 

### MBProgressHUD
Un loader lightweight para actualizar al usuario del estado de la aplicación. Es llamado cuando se están haciendo las llamadas de red para recuperar los detos de las películas.

### ViewAnimator
Crea animaciones para las vistas de manera sencilla. Es utilizado en la TableView para generar una animación cuando se cargan las celdas con la información de las películas.

### TBEmptyDataSet
Librería que es llamada cuando no hay resultados que mostrar en la TableView. Proporciona una manera de informar al usuario que no se han encontrado resultados en lugar de presentar una tabla vacía.

## Preguntas

1. ¿En qué consiste el principio de responsabilidad única? ¿Cuál es su propósito?
Principio de responsabilidad única (Single responsibility) es el primer principio de SOLID.  Se refiere a que cada clase y funcione de la aplicación debe ser responsable sobre una sola parte de la aplicación. MVVM permite hacer esto de manera sencilla ya que separa la funcionalidad que en MVC se hace únicamente en el ViewController y la distribuye en el ViewModel y en el ViewController. El propósito de hacer esto es crear una aplicación o software que sea fácil de mantener y escalar. 

Los otros principios de SOLID son: Open/closed, Liskov substitution, Interface segregation, Dependency inversion.

3. ¿Qué características tiene, según su opinión un "buen" código o código limpio?
Considero que un buen código debe ser fácil de seguir. Debe de tener comentarios cuando la funcionalidad no es tan simple. Otra característica importante es que debe ser fácil de modificar, si hay mucho código en una sola clase se vuelve complicado encontrar bloque que necesita modificaciones. Una buena técnica para asegurar que el código sea legible es hacer code reviews con otros programadores. Esta técnica también ayuda a encontrar bugs en el código por que otras personas pueden detectar errores en la programación del otro. El código se debe mantener ordenado y bien estructurado (espacios, indentaciones, llaves {})


## Requerimientos

- iOS 12.0+ 
- Xcode 10.0+
- Swift 4.2

## Autor

* ✨✨mzellhuber✨✨ [https://github.com/mzellhuber](https://github.com/mzellhuber)