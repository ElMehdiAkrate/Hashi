
#Représente un lien entre deux cases qui peut etre un lien hypothese
class Lien

    # @case1 => correspond a la premiere case auquelle est relié ce lien
    # @case2 => correspond a la deuxieme case auquelle est relié ce lien
    # @hypothese => boolean sur l'état du lien, si il est une hypothese(true) ou pas(false)

    # Methode d ’ acces en lecture de @case1
    attr_reader:case1
    # Methode d ’ acces en lecture de @case2
    attr_reader:case2
    # Methode d ’ acces en lecture / ecriture de @hypothese
    attr_accessor:hypothese

    # On rend privé la methode de classe new pour forcer l'utilisation de Lien.creer
    private_class_method:new


    # Initialisation d'un lien
    #
    # === Parametres
    #
    # * + case1 + = > case de départ du lien
    # * + case2 + = > case d'arrivé du lien
    # * + hypothese + = > boolean, vrai sur le lien est une hypothese, faux sinon
    #
    def initialize(case1,case2,hypothese)
        @case1=case1
        @case2=case2
        @hypothese=hypothese
    end

    
    # Creation d'un lien
    #
    # === Parametres
    #
    # * + case1 + = > case de départ du lien
    # * + case2 + = > case d'arrivé du lien
    # * + hypothese + = > boolean, vrai sur le lien est une hypothese, faux sinon
    #
    # === Retour
    #
    # le lien creer
    #
    def Lien.creer(case1,case2,hypothese)
        new(case1,case2,hypothese)
    end


    # affiche les info d'un lien
    #
    def afficherLien()
        puts("( #{@case1.etiquetteCase} , #{@case2.etiquetteCase} , #{self.hypothese} )")
    end



end
