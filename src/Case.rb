require_relative "Lien"


# Une case du jeu avec des position ligne et colonne contenant une etiquette 
# correspondant au nombre de lien possible sur cette case
class Case

    # @ligne => entier correspondnant à la ligne de la case dans la grille
    # @colonne => entier correspondnant à la colonne de la case dans la grille
    # @etiquetteCase => entier correspondant au nombre de liens total possibles sur cette case
    # @tabVoisins => tableau(0 à 3) des cases voisines 
    # @tabTriangle => tableau(0 à 3) contenant des booleans correspondant à la possibilité ou non de créer un lien dans une direction

    # Méthode d'accès en lecture de @ligne
    attr_reader :ligne
    # Méthode d'accès en lecture de @colonne
    attr_reader :colonne
    # Méthode d'accès en lecture de @etiquetteCase
    attr_reader :etiquetteCase
    # Méthode d'accès en lecture / écriture de @tabVoisins
    attr_accessor :tabVoisins
    # Méthode d'accès en lecture / écriture de @tabTriangle
    attr_accessor :tabTriangle

    # On rend privé la méthode de classe new pour forcer l'utilisation de Case.creer
    private_class_method :new

    # Initialisation d'une case
    #
    # === Parametres
    #
    # * +ligne+ => la ligne de la case dans la grille
    # * +colonne+ => la colonne de la case dans la grille
    # * +etiquetteCase+ => le nombre de liens total pouvant être reliés à cette case
    #
    def initialize(ligne,colonne,etiquetteCase)
        @ligne=ligne
        @colonne=colonne
        @etiquetteCase=etiquetteCase
        @tabTriangle=Array.new(4,false)
        @tabVoisins=Array.new(4,false)

    end


    # Création d'une case
    #
    # === Paramètres
    #
    # * + ligne + = > la ligne de la case dans la grille
    # * + colonne + = > la colonne de la case dans la grille
    # * + etiquetteCase + = > le nombre de liens total pouvant être reliés à cette case
    #
    # === Retour
    #
    # La nouvelle Case
    #
    def Case.creer(ligne,colonne,etiquetteCase)
        new(ligne,colonne,etiquetteCase)
    end


    # Compte le nb de lien attachés à une case
    #
    # === Paramètres
    #
    # * +tabLien+ => le tableau des liens
    #
    # === Retour
    #
    # Le nombre de liens pour cette case
    #
    def nbLienCase(tabLien)
        compteur=0
        tabLien.each do |lien|
            if( self==lien.case1 || self==lien.case2 )
                compteur+=1
            end
        end
        return compteur
    end




    # Création d'un lien à partir de cette case dans une certaine direction
    #
    # === Paramètres
    #
    # * +posTabTriangle+ => entier qui correspond à la direction de création du lien (0==nord, 1==est, 2==sud, 3==ouest)
    # * +hypothese+ => booléen qui correspond à l'état du lien, si il est créé ou non lors d'une hypothese
    # * +tabLien+ => le tableau de lien de la grille
    #
    def creerLien(posTabTriangle,hypothese,tabLien)#ATTENTION : à gérer le croisement de lien ici avant création.
        if(self.tabTriangle[posTabTriangle]!=false && nbLienCase(tabLien)<@etiquetteCase   )
            l=Lien.creer(self,self.tabVoisins[posTabTriangle],hypothese)
            c=0
            tabLien.each do  |lien|
                #  puts('recherche si le lien existe')
                if((lien.case1.ligne == self.ligne && lien.case1.colonne == self.colonne) && (lien.case2.ligne == self.tabVoisins[posTabTriangle].ligne && lien.case2.colonne == self.tabVoisins[posTabTriangle].colonne ) )
                    c +=1
                    #puts('il existe un lien de self vers la direction')
                elsif ((lien.case2.ligne == self.ligne && lien.case2.colonne == self.colonne) && (lien.case1.ligne == self.tabVoisins[posTabTriangle].ligne && lien.case1.colonne == self.tabVoisins[posTabTriangle].colonne ))
                    c +=1
                    #puts('il existe un lien de ladirection vers self')
                end
            end

            if(c==1)
                self.tabTriangle[posTabTriangle] = false
                self.tabVoisins[posTabTriangle].tabTriangle[(posTabTriangle + 2)%4] = false
            end
            tabLien.push(l)
        else
            puts('impossible de créer un lien entre ' "#{@etiquetteCase}"' et ' "#{self.tabVoisins[posTabTriangle].etiquetteCase}"' deja existant')
        end
    end

end
