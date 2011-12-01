# Lorsque le nombre de règles du Makefile augmente, il devient très rapidement fastidieux 
# de trouver les messages d'erreur affichés au milieu des lignes de commandes. 
# Lorsque ECHO=no l'écho des lignes de commandes est désactivé car le caractère @ 
# va être rajouté devant les lignes de commande de compilation.
DEBUG= yes
ECHO= no


# Le débogage pour gdb fonctionne uniquement si DEBUG=yes
# Mettre "no" si c'est pour un débogage avec valgrind, "yes" si c'est un débogage avec gdb
# et met l'option de débogage -ggdb spécialement conçu pour gdb
# Si GDB= no l'option -g sera activé à la place de -ggdb. 
# Même si -ggdb apporte plus d'informations pour gdb, gdb peut travailler avec -g tout comme le pourra valgrind.
CC= g++
GDB= no

EXEC= ./sample

DSRC= ./src/
DOBJ= ./obj/
DINC= ./inc/
DDOC= ./doc/

CONTENU_DOBJ=$(wildcard $(DOBJ)*.o)
SRC= $(wildcard $(DSRC)*.cc)
OBJ= $(SRC:.cc=.o)

INC= $(wildcard $(DINC)*.h)

ifeq ($(ECHO),no)
	SIL=@
else
	SIL=
endif


all: AfficheMode OBJtoSRC $(EXEC) SRCtoOBJ


CFLAGS= -Wall -Wextra -ansi -pedantic -Wstrict-overflow=5 -Wshadow -Wpointer-arith -Wcast-align -Waggregate-return -Wno-missing-field-initializers -Wformat=2 -Wunknown-pragmas -I $(DINC) -fPIC
LDFLAGS=

ifeq ($(DEBUG),yes)
AfficheMode:
	@echo "Génération en mode debug"

CFLAGS+= -O0

ifeq ($(GDB),yes)
	CFLAGS+= -ggdb3
else
	CFLAGS+= -g
endif
else
AfficheMode:
	@echo "Génération en mode release"

CFLAGS+= -O3 -funroll-loops -fomit-frame-pointer -minline-all-stringops -s
endif
# Parmi toutes les options d'avertissement que propose gcc 
# et à l'aide des pages internet http://vodka-pomme.net/projects/avertissements-de-gcc et http://www.linux-kheops.com/doc/man/manfr/man-html-0.9/man1/gcc.1.html
# j'ai choisi les options d'avertissements suivantes qui me semble très utiles

#-pedantic contient -Wpointer-arith 
#-Wshadow : Avertir chaque fois qu'une variable locale écrase une autre variable locale. 
#-Wpointer-arith : Provoque des warnings lors de calculs douteux avec des pointeurs.
#-Wcast-align : Provoque un warning quand on risque de changer l'alignement d'un type.
#-Wconversion : Provoque un warning quand le passage d'un argument à une fonction change (relativement) beaucoup son type (i.e. la conversion nécessaire n'est pas triviale). 
#-Waggregate-return : Provoque un warning quand une fonction renvoie une structure ou une union. La norme interdit de renvoyer des structures, c'est donc une bonne option #		      pour vérifier qu'on la respecte. (et même en général, renvoyer beaucoup de données en retour d'une fonction est assez coûteux).
#-Wno-missing-field-initializers : -Wextra empêche d'initialiser des structures ou des tableaux partiellement comme GValue val = { 0, }; 
# 				   -Wno-missing-field-initializers désactive -Wmissing-field-initializers et permet maintenant 
#				   d'initialiser partiellement structures ou tableaux. 
#-Wformat=2 : Averti pour toute mauvaise utilisation de scanf, printf et averti également pour les risques de sécurités avec ces fonctions
# 	      est équivalent à -Wformat-nonliteral -Wformat-security -Wformat-y2k.
#-Wunknown-pragmas : averti quand une maccro #pragma n'est pas comprise par gcc.
#-s : Par défaut, les exécutables produits par GCC gardent leur table de symboles et les informations de relocation. 
# Ceci a pour conséquence d'alourdir le fichier exécutable. L'option -s (pour « strip ») passé à l'éditeur de liens permet de retirer ces données.
# La table de symboles est utile lors du débogage, donc ne pas utiliser cette option 
# si on compte ensuite utiliser un débogueur avec le programme !
#-funroll-loops : Déroule le contenu des fonctions se trouvant dans des boucles dont le nombre d'itérations est connu à la compilation.
# Rend le code plus volumineux mais peut dans certains cas améliorer grandement les performances. Cet option rend le code plus volumineux
# dans tous les cas et ne rend pas forcément le code plus rapide. Il vaut mieux vérifier de préférence si ça améliore réellement les performances
# pour le projet sur lequel on applique cette option.
# -minline-all-stringops : Pour les applications qui utilisent des fonctions standards, comme memset, memcpy ou strlen, l'option -minline-all-stringops
#			   peut augmenter les performances en alignant les opérations sur les chaînes de caractères.

#-ggdb(n) n indique le degré d'informations rajouté dans l'exécutable, n varie de 0 à 3.
# options que je n'aime pas : -Wconversion qui trouve des conversions partout (n'autorise pas de faire char var = 0; var += 1;)


# Si on veut utiliser %.o:%.cc qui crée une règle pour chaque fichier .o ayant été une dépendance d'une autre cible
# un fichier .cc portant le même nom, on ne peut pas faire autrement lorsqu'on utilise un dossier pour les sources et
# un dossier pour les fichiers binaires que de déplacer les fichiers binaires ou sources dans le même répertoire.
# Les deux cibles OBJtoSRC et SRCtoOBJ permettent d'organiser les .o avant et après la compilation.
# La commande shell de OBJtoSRC permet de déplacer tous les .o vers le dossier sources pour que la compilation puisse se faire.
# Après la compilation SRCtoOBJ est appelé pour remettre les .o dans le dossier des binaires
# ce qui permet d'alléger le dossier sources dans lequel je préfère avoir que des .cc
# Les conditions if vérifient que le dossier qui contient les fichiers binaires n'est pas vide et 
# que le dossier qui contient les sources et celui qui contient les binaires n'est pas le même auquel car ça ne sert à rien
# de déplacer les fichiers binaires.


# ne pas mettre $(shell mv...) car la première parenthèse permet déjà d'interpréter les commandes.
OBJtoSRC:
	@(if [ "$(CONTENU_DOBJ)" != "" ] && [ $(DSRC) != $(DOBJ) ] ; then mv $(DOBJ)*.o $(DSRC) ; fi) 


SRCtoOBJ:
	@(if [ $(DSRC) != $(DOBJ) ] ; then mv $(DSRC)*.o $(DOBJ) ; fi) 


$(EXEC): $(OBJ) 
	$(CC) -o $@ $^ $(LDFLAGS) $(CFLAGS)

# si un header a été modifié, je préfère tout recompiler
%.o: %.cc $(INC)
	$(SIL)$(CC) -o $@ -c $< $(CFLAGS)

doc_html: 
	firefox $(DDOC)html/index.html

.PHONY: clean mrproper

clean:
	rm -rf $(DOBJ)*.o

mrproper: clean
	rm -rf $(EXEC)

