require_relative "Case"
require_relative "Utilitaire"
require_relative "SerGrille"

#Classe représentant une Grille
# Une grille peut :
# avoir une table des cases : méthode contientCaseAvecEtiquette
# avoir une table des liens entre les cases, et supprimer les liens
# commencer les hypotheses des liens, les valider ou annuler

class Grille

    # Méthode d'accès en lecture/écriture de @tabCase
    attr_accessor :tabCase
    # Méthode d'accès en lecture/écriture de @tabLien
    attr_accessor :tabLien
    # Méthode d'accès en lecture/écriture de @hypothese
    attr_accessor :hypothese

    # Méthode d'accès en lecture/écriture de @grilleRes
    attr_accessor :grilleRes

    attr_reader :hauteur

    attr_reader :largeur

    # Rend la méthode new privée
    private_class_method :new

    # Initialisation de la grille
    #
    # === Paramètres
    #
    # * +tab+ => la table des cases
    # * +hauteur+ => le nombre maximal des lignes de la grille
    # * +largeur+ => le nombre maximal des colonnes de la grille
    #
    def initialize(tab,hauteur,largeur,grilleRes)
        @hypothese=false
        @tabLien=Array.new()
        @tabCase=Array.new()
        @tabCase=tab
        @hauteur=hauteur
        @largeur=largeur
        @grilleRes=grilleRes


        for i in 0..@tabCase.length-1 do
            for j in 0..@tabCase.length-1 do
                if(i !=j)
                    #on récupère le voisin le plus proche dans la direction nord
                    if((@tabCase[i].tabVoisins[0]==false && @tabCase[i].ligne>@tabCase[j].ligne && @tabCase[i].colonne==@tabCase[j].colonne) || ( @tabCase[i].ligne>@tabCase[j].ligne && @tabCase[i].colonne==@tabCase[j].colonne && @tabCase[j].ligne>@tabCase[i].tabVoisins[0].ligne ) )
                        @tabCase[i].tabVoisins[0]=@tabCase[j]
                        @tabCase[i].tabTriangle[0]=true
                    end
                    #on récupère le voisin le plus proche dans la direction Sud
                    if((@tabCase[i].tabVoisins[2]==false && @tabCase[i].ligne<@tabCase[j].ligne && @tabCase[i].colonne==@tabCase[j].colonne) || ( @tabCase[i].ligne<@tabCase[j].ligne && @tabCase[i].colonne==@tabCase[j].colonne && @tabCase[j].ligne<@tabCase[i].tabVoisins[2].ligne ) )
                        @tabCase[i].tabVoisins[2]=@tabCase[j]
                        @tabCase[i].tabTriangle[2]=true
                    end
                    #on récupère le voisin le plus proche dans la direction ouest
                    if((@tabCase[i].tabVoisins[3]==false && @tabCase[i].colonne>@tabCase[j].colonne && @tabCase[i].ligne==@tabCase[j].ligne) || ( @tabCase[i].colonne>@tabCase[j].colonne && @tabCase[i].ligne==@tabCase[j].ligne && @tabCase[j].colonne>@tabCase[i].tabVoisins[3].colonne ) )
                        @tabCase[i].tabVoisins[3]=@tabCase[j]
                        @tabCase[i].tabTriangle[3]=true
                    end
                    #on récupère le voisin le plus proche dans la direction est
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
    def Grille.creer(tab,hauteur,largeur,grilleRes)
        new(tab,hauteur,largeur,grilleRes)
    end

    # Méthode d'affichage de la table des cases
    #
    def tabCaseAfficher()
        for i in 0..@tabCase.length-1
            puts(tabCase[i])
        end
    end

    # Méthode qui trouve une case selon ses coordonnées
    #
    # === Paramètres
    #
    # * +ligne+ => la position dans la grille
    # * +colonne+ => la position dans la grille
    #
    def caseIci(ligne, colonne)
        @tabCase.each do |c|
            if(c.ligne==ligne && c.colonne==colonne)
                return c
            end
        end
    end

    # Méthode de suppression des liens entres les cases
    #
    # === Paramètres
    #
    # * +l+ => le lien à supprimer
    #
    def supprimerLien(l)
        i=Utilitaire.index(@tabLien,l)
        x=Utilitaire.index(@tabCase,@tabLien[i].case1)
        y=Utilitaire.index(@tabCase,@tabLien[i].case2)
        #on peut remplacer par l.case1 et l.case2 au lieu des indices
        @tabLien.delete_at(i)

        

        
        self.actuCroisement()

    end

    # Méthode pour remplir la table des cases avec une valeur
    #
    # === Paramètres
    #
    # * +ligne+ => entier correspondant la ligne d'une case de la grille
    # * +colonne+ => entier correspondant la colonne d'une case de la grille
    #
    # === Retour
    #
    # Retourne la valeur de la case, sinon retour faux
    #
    def contientCaseAvecEtiquette(ligne,colonne)
        for i in 0..@tabCase.length-1 do
            if(@tabCase[i].ligne==ligne && @tabCase[i].colonne==colonne)
                return @tabCase[i]
            end
        end
        return false
    end


    # Méthode lors d'un clic sur un cercle
    #
    # === Paramètres
    #
    # * +case1+ => la case du clic
    # * +tabLien2+ => le tableau qui va contenir les liens à mettre en surbrillance
    #
    # === Retour
    #rien
    #
    def clicCercle(case1,tabLien2)#a modifier pour afficher toutes les cases reliées


        for i in 0..3 do
            if(case1.tabVoisins[i]!=false)
                if(case1.nbLienEntreDeuxCases(@tabLien,i) != 0 )
                    c=0
                    #on push le ou les lien(s) si ils ne sont pas dans le tabLien2
                    @tabLien.each do  |lien|
                        if((lien.case1.ligne == case1.ligne && lien.case1.colonne == case1.colonne) && (lien.case2.ligne == case1.tabVoisins[i].ligne && lien.case2.colonne == case1.tabVoisins[i].colonne ) )
                            if( Utilitaire.index(tabLien2,lien)==-1 )#probleme ici
                                tabLien2.push(lien)
                                c +=1
                            end
                        elsif ((lien.case2.ligne == case1.ligne && lien.case2.colonne == case1.colonne) && (lien.case1.ligne == case1.tabVoisins[i].ligne && lien.case1.colonne == case1.tabVoisins[i].colonne ))
                            if( Utilitaire.index(tabLien2,lien)==-1 )#probleme ici
                                tabLien2.push(lien)
                                c +=1
                            end  
                        end

                    end

                    if(c!=0)
                        clicCercle(case1.tabVoisins[i],tabLien2)
                    end
                end

            end
        end
        return 
    end

    # Méthode lors d'un dlic sur le triangle d'un cercle
    #
    # === Paramètres
    #
    # * +case1+ => la case du clic
    # * +pos+ => entier correspondant la position du lien de deux cases
    #
    def clicTriangle(case1,pos)
        case1.creerLien(pos,@hypothese,@tabLien)
        self.actuCroisement()
    end

    # actualise les triangles de chaques cases pour empecher les croisements de liens
    #
    def actuCroisement()

        @tabCase.each do |c|
            if(c.etiquetteCase.to_i() > c.nbLienCase(@tabLien) )
                for i in 0..3 do
                    if(c.tabVoisins[i]!=false)
                        c.tabTriangle[i]=true
                    else
                        c.tabTriangle[i]=false
                    end
                end
            end

            for i in 0..3 do
                if(c.tabTriangle[i]==true)
                    if(c.nbLienEntreDeuxCases(@tabLien,i)<=1 && c.etiquetteCase.to_i() > c.nbLienCase(@tabLien))
                        c.tabTriangle[i]=true
                    else
                        c.tabTriangle[i]=false
                    end
                end
            end


            for i in 0..3 do
                if(c.tabTriangle[i]==true)
                    if(c.lienPasseEntreDeuxCases(@tabLien,i)==false && c.etiquetteCase.to_i() > c.nbLienCase(@tabLien) && c.nbLienEntreDeuxCases(@tabLien,i)<=1)
                        c.tabTriangle[i]=true
                    else
                        c.tabTriangle[i]=false
                    end
                end
            end


        end

        @tabCase.each do |c|
            for i in 0..3 do
                if(c.tabVoisins[i]!=false && c.tabVoisins[i].tabTriangle[(i+2)%4]==false)
                    c.tabTriangle[i]=false
                end
            end

        end



        

    end


    # Méthode lors du clic sur un lien pour supprimer ce dernier
    #
    # === Paramètres
    #
    # * +l+ => le lien qui a été cliqué
    #
    def clicLien(l)
        self.supprimerLien(l)
    end

    # Méthode pour commencer à faire une hypothèse
    #
    def commencerHypothese()
        @hypothese=true
    end

    # Méthode pour valider une hypothèse
    #
    def validerHypothese()
        for i in 0..@tabLien.length-1 do
            if(@tabLien[i].hypothese==true)
                @tabLien[i].hypothese=false
            end
        end
        @hypothese=false
    end

    # Méthode permettant de savoir si un lien est le même qu'un autre
    #
    # === Paramètres
    #
    # * +l+ => un lien
    #
    # === Retour
    #
    # Retourne le lien si c'est le même, sinon nil
    #
    def lienSimilaire(l)
        @tabLien.each do |lien|
            if(l!=lien  && (lien.case1==l.case1 && lien.case2==l.case2) || (lien.case1==l.case2 && lien.case2==l.case1))
                return lien
            end
        end
        return nil
    end


    def verification()
        #revien d'action en action au dernier etat correct et renvoi le nb d'erreur

    end

    def refaire()
        self.annulerHypothese()
        @tabLien.each do |lien|
            self.supprimerLien(lien)
        end
        #a rajouter plus tard remise a 0 des actions
    end

    # Méthode pour annuler une hypothèse
    #
    def annulerHypothese()
        for i in 0..@tabLien.length-1 do
            if(@tabLien[i].hypothese==true)
                self.supprimerLien(@tabLien[i])
            end
        end
        @hypothese=false

    end

end
