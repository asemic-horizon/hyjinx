(defmacro insert-ax [body] 
   `((getattr g!ax (str '~(first body))) ~@(rest body)))

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
   

(defmacro/g! do-plt [main &optional title [fig-kwargs {}]]
	"Like plt, but you can do several things to the same ax 
	(e.g. multiple plots or additional *compiler-options

	Usage example:
 >>> (do-plt ((scatter x y) (hist x :density True)))
	"
 `(do
   (import [matplotlib.pyplot :as plt] [time [ctime]])
   (setv [g!fig g!ax] (plt.subplots #**~fig-kwargs))
   ~@(lfor cmd main `(insert-ax ~cmd))
   (when ~title  (.set-title g!ax ~title))
   (.savefig g!fig (if ~title ~title (ctime)))))
   

