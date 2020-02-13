require_relative "Case.rb"
require_relative "Utilitaire.rb"
require_relative "SerGrille.rb"

#Classe représentant une Grille
# Une grille peut :
# avoir une table des cases : méthode contientCaseAvecEtiquette
# avoir une table des liens entre les cases, et supprimer les liens
# commencer les hypotheses des liens, les valider ou annuler

class Grille

    # Méthode d'accès en lecture/écriture de @tabCase
    attr_accessor:tabCase
    # Méthode d'accès en lecture/écriture de @tabLien
    attr_accessor:tabLien
    # Méthode d'accès en lecture/écriture de @hypothese
    attr_accessor:hypothese

    attr_reader:hauteur

    attr_reader:largeur

    # Rend la méthode new privée
    private_class_method:new

    # Initialisation de la grille
    #
    # === Paramètres
    #
    # * +tab+ => la table des cases
    # * +hauteur+ => le nombre maximal des lignes de la grille
    # * +largeur+ => le nombre maximal des colonnes de la grille
    #
    def initialize(tab,hauteur,largeur)
        @hypothese=false
        @tabLien=Array.new()
        @tabCase=Array.new()
        @tabCase=tab
        @hauteur=hauteur
        @largeur=largeur


        for i in 0..@tabCase.length-1 do
            for j in 0..@tabCase.length-1 do
                if(i !=j)
                    #on recupere le voisin le plus proche dans la direction nord
                    if((@tabCase[i].tabVoisins[0]==false && @tabCase[i].ligne>@tabCase[j].ligne && @tabCase[i].colonne==@tabCase[j].colonne) || ( @tabCase[i].ligne>@tabCase[j].ligne && @tabCase[i].colonne==@tabCase[j].colonne && @tabCase[j].ligne>@tabCase[i].tabVoisins[0].ligne ) )
                        @tabCase[i].tabVoisins[0]=@tabCase[j]
                        @tabCase[i].tabTriangle[0]=true
                    end
                    #on recupere le voisin le plus proche dans la direction Sud
                    if((@tabCase[i].tabVoisins[2]==false && @tabCase[i].ligne<@tabCase[j].ligne && @tabCase[i].colonne==@tabCase[j].colonne) || ( @tabCase[i].ligne<@tabCase[j].ligne && @tabCase[i].colonne==@tabCase[j].colonne && @tabCase[j].ligne<@tabCase[i].tabVoisins[2].ligne ) )
                        @tabCase[i].tabVoisins[2]=@tabCase[j]
                        @tabCase[i].tabTriangle[2]=true
                    end
                    #on recupere le voisin le plus proche dans la direction ouest
                    if((@tabCase[i].tabVoisins[3]==false && @tabCase[i].colonne>@tabCase[j].colonne && @tabCase[i].ligne==@tabCase[j].ligne) || ( @tabCase[i].colonne>@tabCase[j].colonne && @tabCase[i].ligne==@tabCase[j].ligne && @tabCase[j].colonne>@tabCase[i].tabVoisins[3].colonne ) )
                        @tabCase[i].tabVoisins[3]=@tabCase[j]
                        @tabCase[i].tabTriangle[3]=true
                    end
                    #on recupere le voisin le plus proche dans la direction est
                    if((@tabCase[i].tabVoisins[1]==false && @tabCase[i].colonne<@tabCase[j].colonne && @tabCase[i].ligne==@tabCase[j].ligne) || ( @tabCase[i].colonne<@tabCase[j].colonne && @tabCase[i].ligne==@tabCase[j].ligne && @tabCase[j].colonne<@tabCase[i].tabVoisins[1].colonne ) )
                        @tabCase[i].tabVoisins[1]=@tabCase[j]
                        @tabCase[i].tabTriangle[1]=true
                    end
                end
            end
        end
    end

    # Méthode de création d'une grille
    #
    # === Paramètres
    #
    # * +tab+ => la table des cases
    # * +hauteur+ => le nombre maximal des lignes de la grille
    # * +largeur+ => le nombre maximal des colonnes de la grille
    #
    def Grille.creer(tab,hauteur,largeur)
        new(tab,hauteur,largeur)
    end

    # Méthode d'affichage de la table des cases
    #
    def tabCaseAfficher()
        for i in 0..@tabCase.length-1
            puts(tabCase[i])
        end
    end

    # Méthode de suppression des liens entres les cases
    #
    # === Paramètres
    #
    # * + l + => le lien a supprimer
    #
    def supprimerLien(l)
      i=Utilitaire.index(@tabLien,l)
      x=Utilitaire.index(@tabCase,@tabLien[i].case1)
      y=Utilitaire.index(@tabCase,@tabLien[i].case2)
      @tabLien.delete_at(i)
      if(@tabCase[x].ligne<@tabCase[y].ligne && @tabCase[x].colonne == @tabCase[y].colonne)
           @tabCase[x].tabTriangle[2] = true
           @tabCase[y].tabTriangle[0] = true
      elsif(@tabCase[x].ligne>@tabCase[y].ligne && @tabCase[x].colonne == @tabCase[y].colonne)
           @tabCase[x].tabTriangle[0] = true
           @tabCase[y].tabTriangle[2] = true
       elsif(@tabCase[x].ligne==@tabCase[y].ligne && @tabCase[x].colonne < @tabCase[y].colonne)
           @tabCase[x].tabTriangle[1] = true
           @tabCase[y].tabTriangle[3] = true
       elsif(@tabCase[x].ligne==@tabCase[y].ligne && @tabCase[x].colonne > @tabCase[y].colonne)
           @tabCase[x].tabTriangle[3] = true
           @tabCase[y].tabTriangle[1] = true
       end
    end
    # Méthode de remplir la table des cases avec une valeur
    #
    # === Paramètres
    #
    # * +ligne+ => entier correspondant la ligne d'une case de la grille
    # * +colonne+ => entier correspondant la colonne d'une case de la grille
    #
    # === Retour
    #
    # retour la valeur de la case, sinon retour faux
    #
    def contientCaseAvecEtiquette(ligne,colonne)
        for i in 0..@tabCase.length-1 do
            if(@tabCase[i].ligne==ligne && @tabCase[i].colonne==colonne)
                return @tabCase[i]
            end
        end
        return false
    end


    # Méthode de cliquer le cercle de la case
    #
    # === Paramètres
    #
    # * +ligne+ => entier correspondant la ligne de la case de la grille
    # * +colonne+ => entier correspondant la colonne de la  case de la grille
    #
    # === Retour
    #
    # retour la table des voisins, sinon break
    #
    def clickCercle(ligne,colonne)#a modifier pour afficher toutes les cases reliées

        for i in 0..@tabCase.length-1 do
            if(@tabCase[i].ligne==ligne && @tabCase[i].colonne==colonne)
                break
            end
        end
        return @tabCase[i].tabVoisins

    end

    # Méthode de cliquer le triangle du cercle
    #
    # === Paramètres
    #
    # * +ligne+ => entier correspondant la ligne du triangle du cercle
    # * +colonne+ => entier correspondant la colonne du triangle du cercle
    # * +pos+ => entier correspondant la position du lien de deux cases
    #
    def clickTriangle(ligne,colonne,pos)
        for i in 0..@tabCase.length-1 do
            if(@tabCase[i].ligne==ligne && @tabCase[i].colonne==colonne)
                break
            end
        end
        @tabCase[i].creerLien(pos,@hypothese,@tabLien)

    end

    # Méthode de cliquer le lien  d'une case pour supprimer ce lien
    #
    # === Paramètres
    #
    # * +l+ => le lien qui a été cliqué
    #
    def clicLien(l)
        self.supprimerLien(l)
    end

    # Méthode de commencer à faire une hypothèse
    #
    def commencerHypothese()
        @hypothese=true
    end

    # Méthode de valider une hypothèse
    #
    def validerHypothese()
        for i in 0..@tabLien.length-1 do
            if(@tabLien[i].hypothese==true)
                @tabLien[i].hypothese=false
            end
        end
        @hypothese=false
    end

    # Méthode de cliquer le cercle de la case
    #
    # === Paramètres
    #
    # * +l+ => un lien
    #
    # === Retour
    #
    # retour le lien si c'est le même, sinon return nil
    #
    def lienSimilaire(l)
        @tabLien.each do  |lien|
            if(l!=lien  && (lien.case1==l.case1 && lien.case2==l.case2) || (lien.case1==l.case2 && lien.case2==l.case1))
                return lien
            end
        end
        return nil
    end

    # Méthode de annuler une hypothèse
    #
    def annulerHypothese()
        for i in 0..@tabLien.length-1 do
            if(@tabLien[i].hypothese==true)
                ligne=((@tabLien[i].case1.ligne + @tabLien[i].case2.ligne)-( (@tabLien[i].case1.ligne + @tabLien[i].case2.ligne)%2 )   )/2
                colonne=((@tabLien[i].case1.colonne + @tabLien[i].case2.colonne)-( (@tabLien[i].case1.colonne + @tabLien[i].case2.colonne)%2 )   )/2
                self.supprimerLien(ligne,colonne)
            end
        end
        @hypothese=false

    end

end
