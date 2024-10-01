#!/usr/bin/env python
# coding: utf-8

# # Locations games sans références


from fractions import Fraction
import random

def plus_grand_suivant(position,profile):
    """
    Retourne la valeur de l'action de l'adversaire qui suit un joueur,
    Paramètres:
        position: la postion du joueur
    Retour:
        l'action, ou 1 si le joueur est à l'extrême droit
    """
    #Action du joueur
    action = profile[position]
    #Si il est à l'extrême l'action à considérer est 1
    after = 1
    for grand in profile[position:] : 
        if grand > action:
            after = grand
            break
    return after

def plus_petit_avant(position,profile):
    """
    position: la postion du joueur
    """
    
    before = 0
    action = profile[position]
    for index_avant in range(position,-1,-1):
        action_avant = profile[index_avant]
        if action_avant < action:
            before = action_avant
            break
    return before

def gain_joueur(position,profile):
    """
    Calcule le gain d'un joueur donné, pour un profile donné
    Attention: Le profile doit être trié
    Paramètres:
        position: la postion du joueur dont on veut calculer le gain
        profile: le profile des actions des joueurs 
    Retour:
        un nombre entre 0 et 1 indiquant le gain du joueur
    """
    
    #L'action du joueur
    action = profile[position]
    
    #L'action de l'adversaire suivant
    action_suivante = plus_grand_suivant(position,profile)
    
    #Action de l'adversaire précédent
    action_avant = plus_petit_avant(position,profile)
    
    #Calcul du gain à gauche
    if action_avant in profile: # Pour gérer le cas où des joueurs joue aussi des valeurs à l'extrême de l'espace de concucurrence 
        gain_gauche = (action - action_avant)/2
    else :
        gain_gauche = action - action_avant
        
    #Calcul du gain à droite
    if action_suivante in profile:
        gain_droit = (action_suivante  - action )/2
    else:
        gain_droit = action_suivante  - action 
    
    return (gain_gauche + gain_droit)/profile.count(action)

def joueur_peut_devier(profile,position,deviation):

    action = profile[position]

    #Gain actuel du joueur
    gain_actuel = gain_joueur(position,profile)

    #On reprend les profiles de départ
    profile_deviation = list(profile) 
    #On met à jour la déviation
    profile_deviation[position] = deviation 
    profile_deviation.sort() #On trie
    gain_deviation = gain_joueur(profile_deviation.index(deviation),profile_deviation) #Le gain du joueur

    if gain_deviation> gain_actuel:
        return {"gain_actuel": gain_actuel, "localisation": deviation,"gain_deviation": gain_deviation} 
    return False

def verifier_profile(profile,nbre_deviations=10000):
    for nbre in range(nbre_deviations):
        profile.sort()
        position = random.randint(0,len(profile)-1)
        deviation = Fraction(random.uniform(0,1))
        deviation_result = joueur_peut_devier(profile,position,deviation)
        if deviation_result != False:
            print("Ce profile n'est pas un équilibre de Nash car le joueur ayant joué l'action"
                  ,profile[position], "\npeut dévier vers:"
                  ,float(deviation_result["localisation"]),"\npour gagner ",float(deviation_result["gain_deviation"]),"au lieu de"
                  ,float(deviation_result["gain_actuel"]),"\nLa déviation est obtenue après : ",nbre,"simulation")
            return
    print("Ce profile est potentiellement un équilibre de Nash car aucune déviation bénéfique n'a été trouvée après", nbre_deviations,
                 "simulations de déviation de façon aléatoire entre les ",len(profile),"joueurs")
    
def utilisateur_ecrire_profile():
    profile = input("Entrez le profile que vous voulez tester en les séparant par des point-virgules (;) \n ")
    nbre_deviations = input("Entrez le nombre de déviation que vous voulez simulé, par défaut il est de 10 000 \n")
    profile=profile.split(";")
    profile = list(map(lambda x: Fraction(x),profile))
    if nbre_deviations =="":
        verifier_profile(profile)
    else:
        verifier_profile(profile,int(nbre_deviations))
    


utilisateur_ecrire_profile()


