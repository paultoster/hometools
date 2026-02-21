# %% [markdown]
# # Kapitel 04
# %% [markdown]
# > ### <span style="color:red">ACHTUNG:</span> Bitte zum Starten im Menü `Cell • Run All` ausführen.
# %% [markdown]
# ## Deaktivieren der Warnungen
# %%
import warnings
warnings.filterwarnings('ignore')
# %% [markdown]
# ## Adaline
# %% [markdown]
# #### Listing 4.11, Listing 4.12, Listing 4.13, Listing 4.14
# %%
# Numpy hilft uns mit den arrays
import numpy as np
# Grafische Darstellung
import matplotlib.pyplot as plt
# Das sind unsere Basisklassen
from sklearn.base import BaseEstimator, ClassifierMixin
# Prüfroutinen 
from sklearn.utils.validation import check_X_y, check_array, check_is_fitted, check_random_state
# Speichern 
from sklearn.utils.multiclass import unique_labels
# Ganz wichtig, sonst wird der Plot nicht angezeigt
# %matplotlib inline

# Unser Estimator, passend bezeichnet und die Basisklassen
class AdalineEstimator(BaseEstimator, ClassifierMixin):
    # Initialisierung    
    def __init__(self, eta=.001, n_iterations=500, random_state=None):
        """ Initialisierung der Objekte
        
        eta:          Lernrate
        n_iterations: Anzahl der Iterationen für das Lernen
        random_state: Um Wiederholbarkeit zu garantieren sollte ein numpy.random.RandomState Objekt 
                      konstruiert werden, das mit random_state Seed initialisiert wurde 
                      
        """
        # Die Anzahl der Iterationen   
        self.n_iterations = n_iterations
        # Die Seed für den Zufallsgenerator
        self.random_state = random_state        
        # Die Fehler im Lernprozeß für den Plot gepuffert
        self.errors = []
        # Die Lernrate    
        self.eta = eta
        # Gewichte für die Berechnung im KNN
        self.w = []
        # Alle Gewichte für Plot, zum Zeichnen der Trenngeraden     
        self.wAll = []
        
    # Der gewichtete Input       
    def net_i(self, x):
        """ Den gewichteten Input w*x berechnen      
        x: Ein Vektor          
        """
        return np.dot(x, self.w)
    
    # Aktivierungsfunktion
    def activation(self, x):
        """ Lineare Aktivierungsfunktion      
        """
        return self.net_i(x)
    
    # Outputfunktion, wobei der Output 1 und -1 sein kann 
    # im Gegensatz zum Perceptron, wo 1 und 0 ausgegeben werden
    def output(self, x):
        """ Outputfunktion      
        """
        if self.activation(x) >= 0.0:
            return 1
        else:
            return -1
        
    # Lernen
    def fit(self, X=None, y=None):
        """ Trainieren        
        X: Array-ähnliche Struktur mit [N,D], wobei 
           N = Zeilen = Anzahl der Lernbeispiele und 
           D = Spalten = Anzahl der Features 
        y: Array mit [N], mit N so wie oben       
        """ 
        # Erzeugung des Zufallsgenerators (RNG)
        random_state = check_random_state(self.random_state)        
        # Gewichtinitialisierung
        # np.size(.,1) = Anzahl der Spalten
        self.w = random_state.random_sample(np.size(X,1)) 
        # Prüfe, ob X und y die korrekte Shape haben: X.shape[0] = y.shape[0]
        X, y = check_X_y(X, y)
        # Lerndaten für spätere Verwendung ablegen
        self.X_ = X
        self.y_ = y
        index_liste = []
        # Lernen mit Gradientenabstieg 
        for i in range(self.n_iterations):
            # zufälliges durchwürfeln, für batch size = 1     
            # np.size(.,0) = Anzahl der Zeilen
            rand_index = random_state.randint(0,np.size(X,0))
            index_liste.append(rand_index)
            # Ein zufälliger Inputvektor
            x_ = X[rand_index]
            # Ein dazu passender Output (+1,-1)
            y_ = y[rand_index]
            # net input s berechnen
            s = np.dot(x_, self.w)
            # Fehler berechnen als Quadrat der Differenz zwischen 
            # gewünschem Output und net input
            error = (y_ - s)**2
            self.errors.append(error)
            # Adaline Lernen, so wie beschrieben
            self.w += self.eta * x_ * (y_ - s)
            # .copy() kopiert die Liste
            self.wAll.append(self.w.copy())
        print(f"{index_liste = }")
    # Auswerten                
    def predict(self,x):
        """ Auswerten eines Vektors    
        x: Ein Test Inputvektor        
        """   
        # Prüfen, ob fit aufgerufen wurde
        # Die Daten wurden in der Methode fit gesetzt
        check_is_fitted(self, ['X_', 'y_'])
        # Auswerten, Forward Path
        y_hat = self.output(x)  
        
        return y_hat
    
    # Plot        
    def plot(self):
        """ Ausgabe des Fehlers und der Lernkurve       
        Die im Fehlerarray gespeicherten Fehler als Grafik ausgeben
        Die Trenngeraden aus den gespeicherten Gewichten ausgeben        
        """                 
        x1 = []
        x2 = []
        colors = []
        
        for i in range(self.X_.shape[0]):
            x1.append(self.X_[i][1])
            x2.append(self.X_[i][2])
            y = self.y_[i]
            if y == 1:
                colors.append('r') # rot
            else:
                colors.append('b') # blau
        # Raster
        plt.style.use('seaborn-v0_8-whitegrid')
        # Errors
        plt.plot(self.errors)        
        #
        plt.title("Learning Curve", fontdict=None, loc='center', pad=1)
        plt.xlabel('iteration number')
        plt.ylabel('error')
        plt.figure(1)
        plt.show()
        # Scatter
        plt.figure(2)
        plt.scatter(x1, x2,c=colors)
        # plt.title("Scatter", fontdict=None, loc='center', pad=1)
        # plt.xlabel('x1')
        # plt.ylabel('x2')
        # Result Line
        x1Line = np.linspace(0.0, 1.0, 2)
        x2Line = lambda x1, w0, w1, w2: (-x1*w1 - w0) / w2;
        alpha = 0.0
        for idx, weight in enumerate(self.wAll):
            # alpha = Transparenz, je näher zum Ziel desto dunkler
            if(idx % 100 == 0):
                alpha = 1.0 #( idx / len(self.wAll) )
                plt.plot(x1Line, x2Line(x1Line,weight[0],weight[1],weight[2]), alpha=alpha , linestyle='solid', label=str(idx), linewidth=1.5)      
        # Ergebnisgerade 
        plt.plot(x1Line, x2Line(x1Line,weight[0],weight[1],weight[2]), alpha=alpha , linestyle='solid', label=str(idx), linewidth=2.0)  
        plt.legend(loc='best', shadow=True)
        plt.show()
def main():
    # Erzeugung des Zufallsgenerators (RNG)
    random_state = check_random_state(1)        
    # Initialisierung Datensätze
    I = []
    o = []
    # Datensätze für zwei Kategorien aufbauen 
    # Diesesmal ohne scikit-learn
    for x in random_state.random_sample(20):
        y = random_state.random_sample()
        I.append([1, x, y+1.0]) # Falls +0.0, dann überlappende Kategorien
        o.append(1)

    for x in random_state.random_sample(20):
        y = random_state.random_sample()
        I.append([1, x, y-1.0]) # Falls +0.0, dann überlappende Kategorien
        o.append(-1)

    # Trainingsdaten
    X = np.array(I)
    y = np.array(o)
    # Walte deines Amtes Estimator
    Adaline = AdalineEstimator(eta=0.01,n_iterations=300, random_state=10)
    # Lernen
    Adaline.fit(X,y)
    # Graphen ausgeben
    Adaline.plot()

# Hauptprogramm 
main()  
# %%
