
# # Equilibre symétriques

def getEquations(c,refs):
    eq1 = c*(refs[:,1]- refs[:,0]-Fraction(1,2))**2 +refs[:,1] + refs[:,0] - 1 - (delta(c))
    eq2= c*(refs[:,1] - refs[:,0]-Fraction(1,2))**2 - (refs[:,1] + refs[:,0]) + 1 - (delta(c))
    return eq1,eq2

def delta(c):
    return Fraction(1,4*c)#+ Fraction(1,2)

def cout_deviation(index_joueur,c,refs,actions_triees,is_ordered):
    return  c*(actions_triees[index_joueur]-refs[index_joueur if is_ordered else 1-index_joueur]-Fraction(1,2))**2



def tester_equilibre_symetrique(c,n=100,nbre_deviations=100,graphique=True):
    grille =np.array([Fraction(x,2*n) for x in range(0,n+1)]) 

    references = []

    for r1 in grille :
        r2 = 1-r1
        references.append([r1,r2])

    references = np.array(references)

    #Calcul des bornes
    bornes = np.apply_along_axis(calculs_bornes,1,references,c)

    #sélectionner les bornes du cas 1
    selection_cas1 = bornes[:,0]>=bornes[:,1]
    refs_cas1 =  references[selection_cas1]

    #Création des actions
    actions1 = np.full(shape=(refs_cas1.shape[0],2),fill_value=Fraction(1,2))

    matrice_cas1 = np.concatenate((refs_cas1,actions1),1)

    #sélectionner les bornes du cas 2
    actions2 = bornes[np.logical_not(selection_cas1)]
    refs_cas2 =  references[np.logical_not(selection_cas1)]

    matrice_cas2 = np.concatenate((refs_cas2,actions2),1)

    matrice_profile = np.concatenate((matrice_cas1,matrice_cas2),0)

    paiements= np.apply_along_axis(paiement_ref,1,matrice_profile,c)
    
    paiement_max =  np.max(paiements[:,0])

    
    refs_maximum = matrice_profile[paiements[:,0]==paiement_max,0]
    

    actions_max = matrice_profile[paiements[:,0]==paiement_max,2:4]

    if graphique:
        #Représentation du graphique
        plt.subplot(211)
        plt.title("Joueur1")
        plt.plot(references[:,0],paiements[:,0])
        plt.xlabel("Références r1")
        plt.ylabel("paiements")
        plt.show()

        plt.subplot(212)
        plt.plot(references[:,0],paiements[:,1])
        plt.title("Joueur2")
        plt.xlabel("Références r1")
        plt.ylabel("paiements")
        plt.show()

    return {
        "paiement_max":np.array(paiement_max),
        "refs_max":np.array(refs_maximum),
        "actions_max":np.array(actions_max)}


tester_equilibre_symetrique(1)


paiements_max=[]
refs =[]
actions=[]
couts = range(1,200)
for c in couts:
    result = tester_equilibre_symetrique(c,graphique=False)
    paiements_max.append(result["paiement_max"])
    refs.append(result["refs_max"])
    actions.append(result["actions_max"])
plt.plot(couts,paiements_max)
plt.xlabel("Coûts de déviation")
plt.ylabel("Paiements des joueurs")
plt.show()

print(np.array(refs))
print("\n\n\n")
print(np.array(actions))
