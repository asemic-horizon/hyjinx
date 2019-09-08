
(defmacro do-plot [main &optional title [fig-kwargs {}] ax-cmds]
 `(do
   (import [matplotlib.pyplot :as plt] [time [ctime]])
   (setv [fig ax] (plt.subplots #**~fig-kwargs))
   (do ~main)
   (when ~title  (.set-title ax ~title))
   (when ~ax-cmds (do ~ax-cmds))
   (.savefig fig (if ~title ~title (ctime))))) 