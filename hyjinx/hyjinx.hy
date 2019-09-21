(defmacro insert-ax [body] 
   `((getattr g!ax (str '~(first body))) ~@(rest body)))

(defmacro insert-fig [body] 
   `((getattr g!fig (str '~(first body))) ~@(rest body)))

(defmacro/g! plt [main &optional title [fig-kwargs {}]]
  "Simple plot making workflow.

	Usage example:
	>>> (plt (scatter x y) \"X versus Y\")

	This creates a fig/ax pair with matplotlib,
	runs ax.scatter(x,y) and saves the figure with the
	indicated title. If no title is indicated a timestamp
	is used."
 `(do
   (import [matplotlib.pyplot :as plt] [time [ctime]])
   (setv [g!fig g!ax] (plt.subplots #**~fig-kwargs))
   (insert-ax ~main)
   (when ~title  (.set-title g!ax ~title))
   (.savefig g!fig (if ~title ~title (ctime)))))
   



(defmacro/g! do-plt [with-ax &optional title [fig-kwargs {}]]
  "Like plt, but you can do several things to the same ax 
	(e.g. multiple plots or additional options

	Usage example:
 >>> (do-plt ((scatter x y) (hist x :density True)))
	"
 `(do
   (import [matplotlib.pyplot :as plt] [time [ctime]])
   (setv [g!fig g!ax] (plt.subplots #**~fig-kwargs))
   ~@(lfor cmd with-ax `(insert-ax ~cmd))
   (when ~title  (.set-title g!ax ~title))
   (.savefig g!fig (if ~title ~title (ctime)))))
   


(defmacro/g! plt! [colorplot &optional title labels [fig-kwargs {}]]

 `(do
   (import [matplotlib.pyplot :as plt] [time [ctime]])
   (setv [g!fig g!ax] (plt.subplots #**~fig-kwargs))
   (setv g!sc (insert-ax ~colorplot))
   (when ~title  (.set-title g!ax ~title))
   (when ~labels
     (setv g!n-cats (len ~labels))  
     (setv g!cbar (.colorbar g!fig g!sc :ax g!ax)) :boundaries (- (np.arange (inc g!n-cats)) 0.5) 
     (.set-ticks g!cbar (np.arange g!n-cats))
     (.set-tickla  bels g!cbar ~labels))  
   (.savefig g!fig (if ~title ~title (ctime)))))



(defmacro/g! do-plt* [with-ax &optional with-fig title [fig-kwargs {}]]
  "Like plt, but you can do several things to the same ax 
	(e.g. multiple plots or additional options (AND to the fig)

	"
 `(do
   (import [matplotlib.pyplot :as plt] [time [ctime]])
   (setv [g!fig g!ax] (plt.subplots #**~fig-kwargs))
   ~@(lfor cmd with-ax `(insert-ax ~cmd))
   ~@(lfor cmd with-fig `(insert-fig ~cmd))
   (when ~title  (.set-title g!ax ~title))
   (.savefig g!fig (if ~title ~title (ctime)))))
   

(defmacro get-0 [x] `(get ~x 0))
(defmacro get-1 [x] `(get ~x 0))
(defmacro get-2 [x] `(get ~x 0))
(defmacro get-3 [x] `(get ~x 3))

;; for numpy arrays
(defmacro hlen [x] `(get (.shape ~x) 1))
(defmacro vlen [x] `(get (.shape ~x)))


(defn encoding [df col]
 (setv values  (get df col)  
       uniques (list (set values)))
 (dict (zip uniques (range (len uniques)))))

(defn encode [df col corresp] 
 (import [numpy [vectorize]]) 
 ((vectorize (fn [x] (get corresp (str x))))
  (getattr (get df col) "values"))) 

(defn cod [lista] (dfor [u v] (enumerate lista) [v u]))
