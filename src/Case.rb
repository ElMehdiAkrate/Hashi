require_relative "Lien.rb"


# Une case du jeu avec des position ligne et colonne contenant une etiquette 
# correspondant au nombre de lien possible sur cette case
class Case

    # @ligne => entier correspondnant à la ligne de la case dans la grille
    # @colonne => entier correspondnant à la colonne de la case dans la grille
    # @etiquetteCase => entier correspondnant au nombre de lien total possible sur cette case
    # @tabVoisins => tableau(0 a 3) des cases voisines 
    # @tabTriangle => tableau(0 a 3) contenant des booleans correspondant a la possibilitée ou non de créer un lien dans une direction

    # Methode d ’ acces en lecture de @ligne
    attr_reader:ligne
    # Methode d ’ acces en lecture de @colonne
    attr_reader:colonne
    # Methode d ’ acces en lecture de @etiquetteCase
    attr_reader:etiquetteCase
    # Methode d ’ acces en lecture / ecriture de @tabVoisins
    attr_accessor:tabVoisins
    # Methode d ’ acces en lecture / ecriture de @tabTriangle
    attr_accessor:tabTriangle

    # On rend privé la methode de classe new pour forcer l'utilisation de Case.creer
    private_class_method:new

    # Initialisation d'une case
    #
    # === Parametres
    #
    # * + ligne + = > la ligne de la case dans la grille
    # * + colonne + = > la colonne de la case dans la grille
    # * + etiquetteCase + = > le nombre de lien total pouvant etre relié à cette case
    #
    def initialize(ligne,colonne,etiquetteCase)
        @ligne=ligne
        @colonne=colonne
        @etiquetteCase=etiquetteCase
        @tabTriangle=Array.new(4,false)
        @tabVoisins=Array.new(4,false)

    end


    # Creation d'une case
    #
    # === Parametres
    #
    # * + ligne + = > la ligne de la case dans la grille
    # * + colonne + = > la colonne de la case dans la grille
    # * + etiquetteCase + = > le nombre de lien total pouvant etre relié à cette case
    #
    # === Retour
    #
    # la case creer
    #
    def Case.creer(ligne,colonne,etiquetteCase)
        new(ligne,colonne,etiquetteCase)
    end


    # compte le nb de lien attaché a une case
    #
    # === Parametres
    #
    # * + tabLien + = > le tableau des liens
    #
    # === Retour
    #
    # le nombre de lien
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




    # creation d'un lien a partir de cette case dans une certaine direction
    #
    # === Parametres
    #
    # * + posTabTriangle + = > entier qui correspond a la direction de création du lien,0==nord,1==est,2==sud,3==ouest
    # * + hypothese + = > boolean qui correspond a l'état du lien, si il est créer ou non lors d'une hypothese
    # * + tabLien + = > le tableau de lien de la grille
    #
    # === Retour
    #
    # rien
    #
    def creerLien(posTabTriangle,hypothese,tabLien)#ATTENTION : a gerer le croisement de lien ici avant creation.
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
            puts('impossible de creer un lien entre ' "#{@etiquetteCase}"' et ' "#{self.tabVoisins[posTabTriangle].etiquetteCase}"' deja existant')
        end
    end

end
