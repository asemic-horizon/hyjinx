(defmacro insert-ax [body] 
   `((getattr g!ax (str '~(first body))) ~@(rest body)))

(defmacro/g! plt [main &optional title [fig-kwargs {}]]
 `(do
   (import [matplotlib.pyplot :as plt] [time [ctime]])
   (setv [g!fig g!ax] (plt.subplots #**~fig-kwargs))
   (insert-ax ~main)
   (when ~title  (.set-title g!ax ~title))
   (.savefig g!fig (if ~title ~title (ctime)))))
   

(defmacro/g! do-plt [main &optional title [fig-kwargs {}]]
 `(do
   (import [matplotlib.pyplot :as plt] [time [ctime]])
   (setv [g!fig g!ax] (plt.subplots #**~fig-kwargs))
   ~@(lfor cmd main `(insert-ax ~cmd))
   (when ~title  (.set-title g!ax ~title))
   (.savefig g!fig (if ~title ~title (ctime)))))
   

