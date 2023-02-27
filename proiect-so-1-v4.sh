#!/bin/bash

# Script-ul de mai jos are 2 functionalitati: dictionar de acronime si generarea de chestionare cu acronime.
# Optiunea 2 din Meniu (Chestionar acronime) functioneaza atat cu functia WHILE cat si cu functia FOR. La momentul incarcarii proiectului functia WHILE este comentata (conform feedback).


let numar_intrebari=10 #initializam numarul de intrebari cu 10, in cazul in care utilizatorul nu doreste sa seteze el insusi numarul
let numar_indicii=$((numar_intrebari / 10)) #vom avea maxim un indiciu per intrebare

echo "numarul de indicii este $numar_indicii" #afisam numarul de indicii pe care il vom avea
while :; do #cat timp nu se iese din meniu, vom executa:
	echo #folosim echo simplu pentru a lasa un rand gol
	echo "Meniu principal:" #afisam mesajul care se afla intre ghilimele. In cazul nostru, se afiseaza continutul meniului
	echo "1. Numar curent de intrebari chestionar: ${numar_intrebari} | Modifica" #afisam mesajul care se afla intre ghilimele, inclusiv numarul de intrebari initializat/citit de la tastatura
	echo "2. Chestionar acronime"
	echo "3. Dictionar acronime"
	echo "4. Iesire"
	echo

	#citeste varianta
	echo "Introduceti optiunea dorita:" #afisam un mesaj care sa notifice utilizatorul ca poate introduce optiunea pe care o doreste din meniu
	read optiune_meniu #citim optiunea utilizatorului pentru folosirea meniului

	#compara optiunea aleasa
	case $optiune_meniu in #in cazul in care utilizatorul alege optiunea
	1) #in cazul in care se alege 1, utilizatorul va modifica numarul de intrebari din chestionar
		echo "Optiunea selectata este 1 (Modifcare numar intrebari chestional)."
		echo "Seteaza numarul de intrebari: " #afisam un mesaj care sa notifice utilizatorul ca poate introduce numarul de intrebari dorite in chestionar
		read numar_intrebari #se citeste numarul de intrebari dorit de utilizator
		let numar_indicii=$((numar_intrebari / 10)) #pe baza numarului de intrebari citit, se calculeaza numarul de indicii
		echo "Numar indicii: $numar_indicii" #se afiseaza numarul de indicii calculat
		;;
	2) #in cazul in care se alege 2, utilizatorul va completa chestionarul de acronime
		echo "Optiunea selectata este 2 (Chestionar acronime)!"
		echo "Chestionarul este format din $numar_intrebari intrebari. Pe parcursul chestionarului aveti dreptul de a utiliza optiunea (limitata) ajutatoare 'Indiciu'." #afisam un mesaj prin care notificam utilizatorul ca va avea dreptul de a folosi indicii
		echo "Inserati raspunsul dumneavoastra dupa fiecare intrebare." 
		echo "Scorul obtinut va fi afisat dupa parcurgerea integrala a chestionarului."
		echo

		let rasp_corect=0 #initializam cu 0 numarul initial de raspunsuri corecte
		let rasp_gresit=0 #initializam cu 0 numarul initial de raspunsuri gresite
		let nr_indicii_folosite=0 #initializam cu 0 numarul initial de indicii folosite

		# WHILE
		#let contor=0
		#while [[ contor++ -lt numar_intrebari ]]; do

		 #FOR
		 for ((contor = 1; contor <= numar_intrebari; contor++)); do #bucla for se va executa pana cand se va depasi numarul de intrebari permise

			#salvam aici cate o variabila ce contine o linie aleatorie din fisierul acronyms.txt. Caracterul aleatoriu al liniei este data de functia shuf
			str=$(cat acronyms.txt | tail -n +3 | head -n 2485 | shuf | head -n 1) 
			str2=$(cat acronyms.txt | tail -n +3 | head -n 2485 | shuf | head -n 1)
			str3=$(cat acronyms.txt | tail -n +3 | head -n 2485 | shuf | head -n 1)

			str_acronym=$(echo $str | cut -d'-' -f1) #salvam acronimul in aceasta variabila
			str_corect=$(echo $str | cut -d'-' -f2-) #salvam varianta corecta
			str2_gresit=$(echo $str2 | cut -d'-' -f2-) #salvam cele doua variante gresite
			str3_gresit=$(echo $str3 | cut -d'-' -f2-)

			echo "Intrebarea nr.${contor}: Care este semnificatia acronimului ${str_acronym}?" #afisam numarul de intrebare la care s-a ajuns si acronimul generat aleatoriu din acronyms.txt

			#array cu indecsi
			num=(0 1 2)
			num=($(shuf -e "${num[@]}")) #amestecam indecsii in mod aleatoriu, pentru ca varianta corecta sa poata aparea in oricare dintre cele trei pozitii de selectat

			#stocam intr-un array atat raspunsul corect, cat si raspunsurile gresite
			arr=("$str_corect" "$str2_gresit" "$str3_gresit")

			#se inititalizeaza variabila temp pentru indexul aleatoriu
			temp=0

			#printeaza variantele de raspuns. Se incepe de la 0 si se termina la 2, deoarece primul element dintr-un vector va fi mereu 0
			temp=${num[0]}
			echo "1. ${arr[$temp]}"
			temp=${num[1]}
			echo "2. ${arr[$temp]}"
			temp=${num[2]}
			echo "3. ${arr[$temp]}"
			echo "4.  Indiciu (Indicii utilizate $nr_indicii_folosite / Indicii disponibile $numar_indicii)" #se afiseaza cate indicii au fost folosite din cele disponibile
			echo "5.  Inchide chestionar" 
			echo

			echo "Introduceti raspunsul dumneavoastra (1-5):"#afisam un mesaj care sa notifice utilizatorul ca poate introduce varianta dorita
			#variantele 1-3 sunt folosite pentru a alege una dintre optiunile de raspuns din chestionar, 4 pentru a folosi indiciu, 5 pentru a inchide chestionarul
			read optiune_raspuns #se citeste optiunea

			if [[ $optiune_raspuns == 4 ]]; then #in cazul in care se alege sa se foloseasca un indiciu, se executa urmatoarele linii
				if [[ $numar_indicii -gt $nr_indicii_folosite ]]; then #se verifica daca utilizatorul mai are indicii disponibile si, daca se indeplineste conditia, se executa urmatoarele randuri 
					echo "Indiciul este: " #se afiseaza mesajul care anunta faptul ca urmeaza indiciul
					echo $str_corect | sed 's/[a-zA-Z]/*/g' # se genereaza indiciul, prin inlocuirea literelor din raspunsul corect cu *
					nr_indicii_folosite=$((nr_indicii_folosite + 1)) #se mareste cu 1 numarul de indicii folosite, datorita faptului ca am folosit inca un indiciu
					echo "Numar indicii disponibile: $numar_indicii / Numar indicii utilizate $nr_indicii_folosite " #se afiseaza numarul de indicii folosite in raport cu cele utilizate
				elif [[ $numar_indicii -le $nr_indicii_folosite ]]; then #in cazul in care utilizatorul nu mai are indicii disponibile, se afiseaza mesajul de pe urmatorul rand
					echo "Numarul maxim de indicii a fost depasit."
				fi #se inchide al doilea if

				echo
				echo "Introduceti raspunsul dumneavoastra (1-3 sau 5):"
				read optiune_raspuns #se citeste optiunea
			fi #se inchide primul if

			case $optiune_raspuns in #in functie de varianta aleasa ca raspuns corect(1, 2 sau 3), se executa urmatoarele:
			1 | 2 | 3)								#ajustam optiunea citita de la tastatura cu indicele care contine raspunsul din fisier
				temp=${num[$optiune_raspuns - 1]} . #am tinut cont de faptul ca optiunea aleasa incepe cu 1, iar vectorul care contine variabila temp are indicele 0 
				if [[ "$str_corect" == "${arr[$temp]}" ]]; then #comparam raspunsul corect cu raspunsul ales de utilizator
					echo "Raspuns corect!" #in cazul in care sunt egale, afisam mesajul si incrementam variabila care innumara raspunsurile corecte cu 1
					rasp_corect=$((rasp_corect + 1))
				else
					echo "Raspuns gresit!" #in cazul in care nu sunt egale, afisam mesajul si incrementam variabila care innumara raspunsurile gresite cu 1
					rasp_gresit=$((rasp_gresit + 1))
				fi 
				;;
			5)
				echo "Inchidere chestionar ..."
				continue 2 #se inchide chestionarul, sarind direct la urmatoarea iteratie
				;;
			# Default
			*)
				echo "Optiune invalida" #in cazul in care utilizatorul nu alege niciuna dintre variantele valide, se mareste variabila care innumara raspunsurile gresite cu 1
				rasp_gresit=$((rasp_gresit + 1))
				;;
			esac #se inchide case-ul

			echo "Raspunsuri corecte  $rasp_corect / Raspunsuri gresite  $rasp_gresit" #se afiseaza cate raspunsuri corecte si cate raspunsuri gresite a dat utilizatorul pana in acel moment
			echo
		done #se inchide for-ul

		scor=$(echo "($rasp_corect*100/($contor-1))" | bc) #calculam scorul utilizatorului, in functie de numarul de raspunsuri corecte si de numarul de raspunsuri date in total de utilizator. Folosim comanda de calculator standard (bc)
		echo "Scorul dumneavoastra este: ${scor}%" #afisam scorul sub forma de procent
		echo
		;;
	3) #in cazul in care se alege 3, utilizatorul doreste afisarea unui dictionar de acronime
		echo "Optiunea selectata este 3 (Dictionar de acronime)!"
		echo "Introduceti acronimul: " #afisam un mesaj prin care notificam utilizatorul ca va putea introduce acronimul

		read temp #se citeste acronimul

		if [[ $(grep -E ${temp^^} acronyms.txt) ]]; then #verificam daca acronimul citit se regaseste in fisierul sursa - acronyms.txt 
			echo "$(grep -n "^${temp^^}" acronyms.txt)"  #cautarea se face folosind comanda grep
		else                                             #vom returna doar raspunsurile care incep cu acronimul citit
			echo "Acronimul introdus nu a fost gasit!"
		fi
		;;
	4) #in cazul in care se alege 4, se va iesi din meniu
		echo "Iesire ..."
		exit
		;;
	# Default
	*)
		echo "optiune invalida"
		;;

	esac
done #iesim din bucla principala while do
